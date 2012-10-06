//
//  Command.m
//
//  Created by ████
//

#import "Command.h"
#import "MachO.h"

@implementation Command

+(void)parseLoadCommandsInMachO:(MachO *)mach atOffset:(unsigned int)off inData:(NSData *)binary
{
    unsigned int offset = off;
    
    for (int iter = 0; iter < mach.header.ncmds; iter++)
    {
        if (offset >= [binary length])
        {
            break;
        }
        
        unsigned int start = offset;
        uint32_t cmd = (uint32_t)[binary littleEndianIntDataInRange:NSMakeRange(offset, 4)];
        uint32_t size = (uint32_t)[binary littleEndianIntDataInRange:NSMakeRange(offset + 4, 4)];
    
        switch (cmd)
        {
            case LC_SEGMENT: // segment of this file to be mapped
            {
                SegmentCommand *seg = [SegmentCommand segmentCommandAtOffset:offset inData:binary];
                [mach.segments addObject:seg];
                offset += seg.size;
                break;
            }
            
            case LC_SEGMENT_64:
            {
                SegmentCommand64 *seg = [SegmentCommand64 segment64CommandAtOffset:offset inData:binary];
                [mach.segments addObject:seg];
                offset += seg.size;
                break;
            }
            
            case LC_SYMTAB:
            {
                SymtabCommand *sym = [SymtabCommand symtabCommandAtOffset:offset inData:binary];
                mach.symtab = sym;
                offset += sym.size;
                break;
            }
            
            default:
            {
                offset = start + size;
                break;
            }
        }
    }
}

@end
