//
//  Patcher.m
//
//  Created by ████
//

#import "Patcher.h"
#import "MachO+Constants.h"

@implementation Patcher

@synthesize binary;

+(Patcher *)patcherWithBinary:(Binary *)bin
{
    Patcher *patch = [[Patcher alloc] init];
    patch.binary = bin;
    patch.target = bin.path;
    return patch;
}

+(Patcher *)patcherWithFile:(NSURL *)path
{
    Patcher *patch = [[Patcher alloc] init];
    patch.target = path;
    return patch;
}


-(BOOL)patchSymbol:(NSString *)symbolName withReturnValue:(unsigned int)ret
{
    if (![self binary])
    {
        // This method requires a MachO binary
        return FALSE;
    }
    
    NSError *error = NULL;
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:[binary path]
                                                             error:&error];
    
    for (MachO *mach in [[self binary] machs])
    {
        NSDictionary *symbols = [mach findAllSymbols];
        
        if (!symbols[symbolName])
        {
            return FALSE; // symbol not found
        }
        else
        {
            unsigned long symbol_offset = [mach convertVirtualOffset:
                                           [mach virtualOffsetForSymbol:symbolName]];
            NSData *opcode = [Assembler opcodeForRetValue:ret arch:mach.arch];
            [handle seekToFileOffset:symbol_offset];
            [handle writeData:opcode];
        }
    }
    
    [handle closeFile];
    return TRUE; // just going to assume things worked
}

-(BOOL)replaceData:(NSData *)search with:(NSData *)replace
{
    NSData *target_contents = [NSData dataWithContentsOfURL:[self target]];
    NSRange searchRange = NSMakeRange(0, [target_contents length]);
    NSArray *resultRanges = [target_contents rangesOfData:search options:0 range:searchRange];
    if ([resultRanges count] == 0)
    {
        return FALSE; // data not found
    }
    
    for (NSValue *rangeObj in resultRanges)
    {
        NSRange range;
        [rangeObj getValue:&range];
        
        NSError *error = NULL;
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:[self target] error:&error];
        [handle seekToFileOffset:range.location];
        [handle writeData:replace];
        
        [handle closeFile];
    }
    
    return TRUE;
}

-(BOOL)replaceString:(NSString *)search with:(NSString *)replace
{
    NSData *search_data = [search dataUsingEncoding:NSASCIIStringEncoding];
    NSData *replace_data = [replace dataUsingEncoding:NSASCIIStringEncoding];
    
    BOOL result = [self replaceData:search_data with:replace_data];
    return result;
}

-(BOOL)insertLoadDylibCommand:(NSString *)dylibName
{
    if (![self binary])
        return FALSE; // this is only needed on MachOs
    
    NSString *dylib_path = [NSString stringWithFormat:
                            @"@executable_path/%@", dylibName];
    unsigned int neededLength = 24 + (unsigned int)[dylib_path length];
    
    for (MachO *i in [binary machs])
    {
        unsigned int commandEnd = [i location] + [i.header sizeofcmds];
        // sizeofcmds starts after the header, so we need to add the correct length
        if ([i arch] == CPU_TYPE_X86_64)
            commandEnd += sizeof(struct mach_header_64);
        else if ([i arch] == CPU_TYPE_X86)
            commandEnd += sizeof(struct mach_header);
        else if ([i arch] == CPU_TYPE_ARM)
            commandEnd += sizeof(struct mach_header);
        else if ([i arch] == CPU_TYPE_ARM64)
            commandEnd += sizeof(struct mach_header_64);
        
        // check if data we are replacing is null
        NSData *occupant = [[i data] subdataWithRange:NSMakeRange(commandEnd,
                                                                  neededLength)];
        if(strcmp([occupant bytes], "\0"))
            return FALSE;
        
        // create load command structs
        struct dylib_command command;
        struct dylib dylib;
        dylib.name.offset = 24;
        dylib.timestamp = 0;
        dylib.current_version = 0;
        dylib.compatibility_version = 0;
        command.cmd = LC_LOAD_DYLIB;
        
        if ([i arch] == CPU_TYPE_ARM) {
            command.cmdsize = neededLength + (4 - (neededLength % 4)); // pad to multiple of 4
        }  else if ([i arch] == CPU_TYPE_ARM64) {
            command.cmdsize = neededLength + (8 - (neededLength % 8)); // pad to multiple of 8
        } else {
            command.cmdsize = neededLength + (8 - (neededLength % 8)); // pad to multiple of 8
        }
        
        command.dylib = dylib;
        
        // write data
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:[binary path]
                                                                 error:nil];
        NSMutableData *replace = [NSMutableData data];
        [replace appendBytes:&command length:sizeof(struct dylib_command)];
        [replace appendData:[dylib_path dataUsingEncoding:NSASCIIStringEncoding]];
        [handle seekToFileOffset:commandEnd];
        [handle writeData:replace];
        
        // fixup headers
        // change ncmds
        [handle seekToFileOffset:[i location] + 16]; // fifth item in struct
        unsigned int new_ncmds = [[i header] ncmds] + 1;
        [handle writeData:[NSData dataWithBytes:&new_ncmds length:4]];
        // change sizeofcmds
        [handle seekToFileOffset:[i location] + 20]; // sixth item in struct
        unsigned int new_size = [[i header] sizeofcmds] + neededLength;
        
        if ([i arch] == CPU_TYPE_ARM) {
            new_size += (4 - (new_size % 4)); // pad to a multiple of 4
        }  else if ([i arch] == CPU_TYPE_ARM64) {
            new_size += (8 - (new_size % 8)); // pad to a multiple of 8
        } else {
            new_size += (8 - (new_size % 8)); // pad to a multiple of 8
        }
        
        [handle writeData:[NSData dataWithBytes:&new_size length:4]];
        [handle closeFile];
    }
    
    return TRUE;
}

@end
