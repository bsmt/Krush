//
//  Patcher.m
//
//  Created by ████
//

#import "Patcher.h"

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
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:[binary path] error:&error];

    for (MachO *mach in [[self binary] machs])
    {
        NSDictionary *symbols = [mach findAllSymbols];
        
        if (!symbols[symbolName])
        {
            return FALSE; // symbol not found
        }
        else
        {
            unsigned long symbol_offset = [mach convertVirtualOffset:[symbols[symbolName] unsignedLongValue]];
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
    NSRange dataRange = [target_contents rangeOfData:search options:0 range:searchRange];
    
    if (dataRange.location == NSNotFound)
    {
        return FALSE; // data not found
    }
    else
    {
        NSError *error = NULL;
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:[self target] error:&error];
        [handle seekToFileOffset:dataRange.location];
        [handle writeData:replace];
        
        [handle closeFile];
        return TRUE;
    }
}

-(BOOL)replaceString:(NSString *)search with:(NSString *)replace
{
    NSData *search_data = [search dataUsingEncoding:NSASCIIStringEncoding];
    NSData *replace_data = [replace dataUsingEncoding:NSASCIIStringEncoding];
    
    BOOL result = [self replaceData:search_data with:replace_data];
    return result;
}

-(BOOL)wildcardReplaceData:(NSData *)search with:(NSData *)replace
{
    NSData *target_contents = [NSData dataWithContentsOfURL:[self target]];
    NSArray *parts = [search componentsSeparatedByByte:0x2a]; // wildcard indicator is 0x2a (* ascii)
    
    int index = 0; // our position in the patch data
    for (NSData *component in parts)
    {
        NSRange dataRange = [target_contents rangeOfData:component options:0
                                                   range:NSMakeRange(0, [target_contents length])];
        if (dataRange.location == NSNotFound)
        {
            return FALSE; // didn't find that part
        }
        else
        {
            // add 1 to length to cover the skipped wildcard
            NSData *patchData = [replace subdataWithRange:NSMakeRange(index, (dataRange.length + 1))];
            
            NSError *error = NULL;
            NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:[self target] error:&error];
            [handle seekToFileOffset:dataRange.location];
            [handle writeData:patchData];
            
            [handle closeFile];
        }
    }

    return TRUE;
}

@end
