//
//  NSData+Conversion.m
//
//  Created by ████
//

#import "NSData+Util.h"

@implementation NSData (Util)

-(unsigned long)toInt
{
    return *(unsigned long *)[[self swapEndian] bytes];
}

-(NSString *)hexadecimalString
{
    // Returns hexadecimal string of NSData. Empty string if data is empty.
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
    {
        return [NSString string];
    }
    
    NSUInteger dataLength  = [self length];
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendString:[NSString stringWithFormat:@"%02x", (unsigned int)dataBuffer[i]]];
    }
    return [NSString stringWithString:hexString];
}

-(NSString *)toString
{
    NSString *string = [[[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding]
                    stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    return string;
}

-(NSString *)toStringWithLength:(int)len
{
    NSString *string = [[[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding] substringToIndex:len];
    return string;
}

-(char *)toChar
{
    char *data;
    NSString *string = [[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding];
    data = (char *)[string UTF8String];
    return data;
}

-(char *)toCharWithLength:(int)len
{
    char *data;
    NSString *string = [[[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding] substringToIndex:len];
    data = (char *)[string UTF8String];
    if (strlen(data) >= len)
    {
        data[len-1] = '\0'; // so we have to chop off the last character
    }
    return data;
}


-(unsigned long)intDataInRange:(NSRange)range
{
    return [[self subdataWithRange:range] toInt];
}

-(unsigned long)littleEndianIntDataInRange:(NSRange)range
{
    return [[[self subdataWithRange:range] swapEndian] toInt];
}

-(NSString *)stringDataInRange:(NSRange)range
{
    return [[self subdataWithRange:range] toString];
}

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

-(NSData *)readTillNullAtOffset:(unsigned long)off
{
    unsigned long offset = off;
    NSMutableData *buffer = [NSMutableData data];
    
    for (int i = 0; (off + (1 * i)) < ([self length] - 1); i++)
    {
        NSData *temp = [self subdataWithRange:NSMakeRange(offset += 1, 1)];
        if (*(char *)[temp bytes] == '\0')
        {
            [buffer appendData:temp];
            break;
        }
        else
        {
            [buffer appendData:temp];
            continue;
        }
    }
    
    return [NSData dataWithData:buffer];
}

@end
