//
//  Header.m
//
//  Created by ████
//

#import "Header.h"

@implementation Header

@synthesize offset;
@synthesize magic;
@synthesize cputype;
@synthesize cpusubtype;
@synthesize filetype;
@synthesize ncmds;
@synthesize sizeofcmds;
@synthesize flags;
@synthesize reserved;

-(Header *)initWith32Struct:(struct mach_header)head
{
    self = [super init];
    if (self)
    {
        self.magic = head.magic;
        self.cputype = head.cputype;
        self.cpusubtype = head.cpusubtype;
        self.filetype = head.filetype;
        self.ncmds = head.ncmds;
        self.sizeofcmds = head.sizeofcmds;
        self.flags = head.flags;
        self.reserved = 0;
    }
    return self;
}

-(Header *)initWith64Struct:(struct mach_header_64)head
{
    self = [super init];
    if (self)
    {
        self.magic = head.magic;
        self.cputype = head.cputype;
        self.cpusubtype = head.cpusubtype;
        self.filetype = head.filetype;
        self.ncmds = head.ncmds;
        self.sizeofcmds = head.sizeofcmds;
        self.flags = head.flags;
        self.reserved = head.reserved;
    }
    return self;
}

+(Header *)headerInData:(NSData *)data atOffset:(unsigned int)off
{
    uint32_t magic = (uint32_t)[data intDataInRange:NSMakeRange(off, 4)];
    
    if (magic == MH_CIGAM)
    {
        struct mach_header mach;
        mach = *(struct mach_header *)([data bytes] + off);
        Header *header = [[Header alloc] initWith32Struct:mach];
        return header;
    }
    else if (magic == MH_CIGAM_64)
    {
        struct mach_header_64 mach;
        mach = *(struct mach_header_64 *)([data bytes] + off);
        Header *header = [[Header alloc] initWith64Struct:mach];
        return header;
    }
    else
    {
        return NULL; // not sure what dafuq we just got...
    }
}

@end
