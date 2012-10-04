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

-(void)replaceData:(NSData *)search with:(NSData *)replace
{
    NSRange searchRange = NSMakeRange(0, [[binary binary] length]);
    NSRange dataRange = [[binary binary] rangeOfData:search options:0 range:searchRange];
    
    if (dataRange.location == NSNotFound)
    {
        return;
    }
    
    NSError *error = NULL;
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:[binary path] error:&error];
    [handle seekToFileOffset:dataRange.location];
    [handle writeData:replace];
}

-(void)replaceData:(NSData *)search with:(NSData *)replace useWildcards:(BOOL)wildcard
{
    return;
}

@end
