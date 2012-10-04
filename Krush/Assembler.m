//
//  Assembler.m
//
//  Created by ████
//

#import "Assembler.h"

@implementation Assembler

+(NSData *)opcodeForRetValue:(unsigned int)ret arch:(cpu_type_t)arch
{
    NSData *op;
    
    if (ret == 0)
    {
        if (arch == CPU_TYPE_I386)
        {
            op = [NSData dataWithBytes:"\x31\xc0\xc3" length:3];
        }
        else if (arch == CPU_TYPE_X86_64)
        {
            op = [NSData dataWithBytes:"\x48\x31\xc0\xc3" length:4];
        }
    }
    else if (ret == 1)
    {
        if (arch == CPU_TYPE_I386)
        {
            op = [NSData dataWithBytes:"\x31\xc0\x40\xc3" length:4];
        }
        else if (arch == CPU_TYPE_X86_64)
        {
            op = [NSData dataWithBytes:"\x48\x31\xc0\x48\xff\xc0\xc3" length:7];
        }
    }
    else
    {
        if (arch == CPU_TYPE_I386)
        {
            unsigned int r = CFSwapInt32(ret);
            char *array = (char *)&r;
            char end[7];
            sprintf(end, "\xb8%c%c%c%c\xc3", array[3], array[2], array[1], array[0]);
            op = [NSData dataWithBytes:end length:6];
        }
        else if (arch == CPU_TYPE_X86_64)
        {
            unsigned int r = CFSwapInt32(ret);
            char *array = (char *)&r;
            char end[9];
            sprintf(end, "\x48\xc7\xc0%c%c%c%c\xc3", array[3], array[2], array[1], array[0]);
            op = [NSData dataWithBytes:end length:8];
        }
    }
    
    return op;
}

@end
