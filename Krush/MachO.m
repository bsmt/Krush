//
//  MachO.m
//
//  Created by ████
//

#import "MachO.h"
#import "MachO+Symbol.h"

@implementation MachO

@synthesize data;
@synthesize location;
@synthesize arch;
@synthesize header;
@synthesize segments;
@synthesize symtab;

-(MachO *)init
{
    self = [super init];
    
    if (self)
    {
        self.segments = [NSMutableArray array];
    }
    
    return self;
}

+(MachO *)i386ObjectAtOffset:(unsigned int)off inData:(NSData *)bin
{
    MachO *mach = [[MachO alloc] init];
    mach.data = bin;
    mach.location = off;
    unsigned int offset = off;

    mach.arch = CPU_TYPE_I386;
    mach.header = [Header headerInData:bin atOffset:offset];
    offset += sizeof(struct mach_header);
    
    [Command parseLoadCommandsInMachO:mach atOffset:offset inData:bin];
    
    return mach;
}

+(MachO *)x86_64ObjectAtOffset:(unsigned int)off inData:(NSData *)bin
{
    MachO *mach = [[MachO alloc] init];
    mach.data = bin;
    mach.location = off;
    unsigned int offset = off;
    
    mach.arch = CPU_TYPE_X86_64;
    mach.header = [Header headerInData:bin atOffset:offset];
    offset += sizeof(struct mach_header_64);
    
    [Command parseLoadCommandsInMachO:mach atOffset:offset inData:bin];
    
    return mach;
}

-(SegmentCommand *)segmentWithName:(NSString *)segname
{
    for (SegmentCommand *i in [self segments])
    {
        if ([[i segmentName] isEqualToString:segname])
        {
            return i;
        }
    }
    
    return NULL;
}

-(SegmentCommand64 *)segment64WithName:(NSString *)segname
{
    for (SegmentCommand64 *i in [self segments])
    {
        if ([[i segmentName] isEqualToString:segname])
        {
            return i;
        }
    }
    
    return NULL;
}

-(Section *)section:(NSString *)sectName inSegment:(NSString *)segName
{
    SegmentCommand *seg = [self segmentWithName:segName];
    if (seg)
    {
        return [seg sectionWithName:sectName];
    }
    
    return 0;
}

-(Section64 *)section64:(NSString *)sectName inSegment:(NSString *)segName
{
    SegmentCommand64 *seg = [self segment64WithName:segName];
    if (seg)
    {
        return [seg section64WithName:sectName];
    }
    
    return 0;
}

-(unsigned int)convertVirtualOffset:(uint64_t)virtual
{
    unsigned int base = location;
    unsigned int section_offset;
    unsigned int vmaddr;

    if (arch == CPU_TYPE_I386)
    {
        SegmentCommand *seg = [self segmentWithName:@"__TEXT"];
        if (!seg)
        {
            return 0;
        }
        Section *sect = [seg sectionWithName:@"__text"];
        if (!sect)
        {
            return 0;
        }
        
        vmaddr = [sect address];
        section_offset = [sect offset];
        
        return (unsigned int)(base + section_offset + virtual - vmaddr);
    }
    else if (arch == CPU_TYPE_X86_64)
    {
        SegmentCommand64 *seg = [self segment64WithName:@"__TEXT"];
        if (!seg)
        {
            return 0;
        }
        Section64 *sect = [seg section64WithName:@"__text"];
        if (!sect)
        {
            return 0;
        }
        
        vmaddr = (unsigned int)[sect address];
        section_offset = [sect offset];
        
        return (unsigned int)(base + section_offset + virtual - vmaddr);
    }
    else
    {
        return 0;
    }
    
}

-(unsigned int)convertRealOffset:(uint64_t)real
{
    unsigned int base = location;
    unsigned int section_offset;
    unsigned int vmaddr;
    
    if (arch == CPU_TYPE_I386)
    {
        SegmentCommand *seg = [self segmentWithName:@"__TEXT"];
        if (!seg)
        {
            return 0;
        }
        Section *sect = [seg sectionWithName:@"__text"];
        if (!sect)
        {
            return 0;
        }
        
        vmaddr = [sect address];
        section_offset = [sect offset];
        
        return (unsigned int)(real - base - section_offset + vmaddr);
    }
    else if (arch == CPU_TYPE_X86_64)
    {
        SegmentCommand64 *seg = [self segment64WithName:@"__TEXT"];
        if (!seg)
        {
            return 0;
        }
        Section64 *sect = [seg section64WithName:@"__text"];
        if (!sect)
        {
            return 0;
        }
        
        vmaddr = (unsigned int)[sect address];
        section_offset = [sect offset];
        
        return (unsigned int)(real - base - section_offset + vmaddr);
    }
    else
    {
        return 0;
    }
    
}

-(NSString *)description
{
    NSMutableString *desc = [[NSString stringWithFormat:@"Location: %d\nArch: %d\n", location, arch] mutableCopy];
    if (arch == CPU_TYPE_I386)
    {
        for (SegmentCommand *seg in [self segments])
        {
            [desc appendFormat:@"%@\n", seg];
        }
    }
    else if (arch == CPU_TYPE_X86_64)
    {
        for (SegmentCommand64 *seg in [self segments])
        {
            [desc appendFormat:@"%@\n", seg];
        }
    }
    
    return [NSString stringWithString:desc];
}

@end
