//
//  NSData+Reading.m
//
//  Created by ████
//

#import "NSData+Reading.h"
#import "NSData+Conversion.h"
#import "NSData+Endian.h"

@implementation NSData (Reading)

-(NSData *)readTillNullAtOffset:(unsigned long)off
{
    unsigned long offset = off;
    NSMutableData *buffer = [NSMutableData data];
    
    for (int i = 0; (off + i) < ([self length] - 1); i++)
    {
        NSData *temp = [self subdataWithRange:NSMakeRange(offset += 1, 1)];
        if (*(char *)[temp bytes] != '\0')
        {
            // add the byte if it isn't a null
            [buffer appendData:temp];
        }
        else
        {
            break;
        }
    }
    
    return [NSData dataWithData:buffer];
}

-(NSString *)stringDataInRange:(NSRange)range
{
    return [[self subdataWithRange:range] toString];
}


-(unsigned long)intDataInRange:(NSRange)range
{
    return [[self subdataWithRange:range] toInt];
}

-(unsigned long)littleEndianIntDataInRange:(NSRange)range
{
    return [[[self subdataWithRange:range] swapEndian] toInt];
}

@end
