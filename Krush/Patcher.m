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
    return patch;
}

-(BOOL)patchSymbol:(NSString *)symbolName withReturnValue:(unsigned int)ret
{
    for (MachO *mach in [[self binary] machs])
    {
        NSDictionary *symbols = [mach findAllSymbols];
        
        if (!symbols[symbolName])
        {
            return FALSE; // symbol not found
        }
        else
        {
            NSError *error = NULL;
            NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:[binary path] error:&error];
            
            unsigned long symbol_offset = [mach convertVirtualOffset:[symbols[symbolName] unsignedLongValue]];
            
            NSData *opcode = [Assembler opcodeForRetValue:ret arch:mach.arch];
            [handle seekToFileOffset:symbol_offset];
            [handle writeData:opcode];
        }
    }
    
    return TRUE; // just going to assume things worked
}

-(BOOL)replaceData:(NSData *)search with:(NSData *)replace
{
    NSRange searchRange = NSMakeRange(0, [[binary binary] length]);
    NSRange dataRange = [[binary binary] rangeOfData:search options:0 range:searchRange];
    
    if (dataRange.location == NSNotFound)
    {
        return FALSE; // data not found
    }
    else
    {
        NSError *error = NULL;
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:[binary path] error:&error];
        [handle seekToFileOffset:dataRange.location];
        [handle writeData:replace];
        
        return TRUE;
    }
}

-(BOOL)replaceData:(NSData *)search with:(NSData *)replace useWildcards:(BOOL)wildcard
{
    return FALSE; // not implemented
}

@end
