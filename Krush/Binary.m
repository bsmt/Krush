//
//  Binary.m
//
//  Created by ████
//

#import "Binary.h"

@implementation Binary

@synthesize path;
@synthesize binary;
@synthesize machs;

-(id)initWithBinaryAtPath:(NSString *)binPath
{
    self = [super init];

    if (self)
    {
        path = [NSURL fileURLWithPath:binPath];
        binary = [NSData dataWithContentsOfURL:path];
        machs = [NSMutableArray array];
        [self parseBinary];
    }
    
    return self;
}

-(void)parseBinary
{
    if (!binary)
    {
        return;
    }
    
    unsigned int magic = (unsigned int)[binary intDataInRange:NSMakeRange(0, 4)];
    
    if (magic == FAT_MAGIC) // fat binary
    {
        unsigned int offset = 0;
        struct fat_header fat;
        fat = *(struct fat_header *)((char *)[binary bytes] + offset);
        fat.nfat_arch = CFSwapInt32(fat.nfat_arch);
        offset += sizeof(struct fat_header);
        
        for (int i = 0; i < fat.nfat_arch; i++)
        {
            struct fat_arch arch;
            arch = *(struct fat_arch *)((char *)[binary bytes] + offset);
            arch.cputype = CFSwapInt32(arch.cputype);
            arch.cpusubtype = CFSwapInt32(arch.cpusubtype);
            arch.offset = CFSwapInt32(arch.offset);
            arch.size = CFSwapInt32(arch.size);
            arch.align = CFSwapInt32(arch.align);
            
            if (arch.cputype == CPU_TYPE_I386) // object is i386
            {
                MachO *object = [MachO i386ObjectAtOffset:arch.offset inData:binary];
                [machs addObject:object];
            }
            else if (arch.cputype == CPU_TYPE_X86_64) // object is x86_64
            {
                MachO *object = [MachO x86_64ObjectAtOffset:arch.offset inData:binary];
                [machs addObject:object];
            }
            offset += sizeof(struct fat_arch);
        }
    }
    else if (magic == MH_CIGAM) // i386 only
    {
        MachO *object = [MachO i386ObjectAtOffset:0 inData:binary];
        [machs addObject:object];
    }
    else if (magic == MH_CIGAM_64) // x86_64 only
    {
        MachO *object = [MachO x86_64ObjectAtOffset:0 inData:binary];
        [machs addObject:object];
    }
}

@end
