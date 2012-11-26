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
    NSArray *resultRanges = [target_contents rangesOfData:search options:NULL range:searchRange];
    if (!resultRanges)
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

@end
