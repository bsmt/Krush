//
//  NSData+Endian.m
//
//  Created by ████
//

#import "NSData+Endian.h"

@implementation NSData (Endian)

-(NSData *)swapEndian
{
    NSMutableData *data = [NSMutableData data];
    int i = (int)[self length] - 1;
    while (i >= 0)
    {
        [data appendData:[self subdataWithRange:NSMakeRange(i, 1)]];
        i--;
    }
    return [NSData dataWithData:data];
}

@end
