//
//  SegmentCommand.m
//
//  Created by ████
//

#import "SegmentCommand.h"
#import "Command.h"

@implementation SegmentCommand

@synthesize location;
@synthesize sections;
@synthesize command;
@synthesize size;
@synthesize segmentName;
@synthesize vmaddr;
@synthesize vmsize;
@synthesize fileoff;
@synthesize filesize;
@synthesize maxprot;
@synthesize initprot;
@synthesize nsects;
@synthesize flags;

-(SegmentCommand *)initWithStruct:(struct segment_command)segment
{
    self = [super init];
    if (self)
    {
        self.command = segment.cmd;
        self.size = segment.cmdsize;
        self.segmentName = @(segment.segname);
        self.vmaddr = segment.vmaddr;
        self.vmsize = segment.vmsize;
        self.fileoff = segment.fileoff;
        self.filesize = segment.filesize;
        self.maxprot = segment.maxprot;
        self.initprot = segment.initprot;
        self.nsects = segment.nsects;
        self.flags = segment.flags;
    }
    return self;
}

+(SegmentCommand *)segmentCommandAtOffset:(unsigned int)off inData:(NSData *)binary
{
    struct segment_command seg;
    seg = *(struct segment_command *)([binary bytes] + off);
    SegmentCommand *cmd = [[SegmentCommand alloc] initWithStruct:seg];
    cmd.location = off;
    cmd.sections = [NSMutableArray array];
    
    unsigned int offset = off + sizeof(struct segment_command);
    for (int i = 0; i < cmd.nsects; i++)
    {
        struct section sect;
        sect = *(struct section *)([binary bytes] + offset);
        Section *section = [[Section alloc] initWithStruct:sect];
        offset += sizeof(struct section);
        
        [cmd.sections addObject:section];
    }
    
    return cmd;
}

-(Section *)sectionWithName:(NSString *)sectname
{
    for (Section *i in [self sections])
    {
        if ([[i sectionName] isEqualToString:sectname])
        {
            return i;
        }
    }
    return NULL;
}

-(NSString *)description
{
    NSMutableString *desc = [NSMutableString string];
    for (Section *sec in [self sections])
    {
        [desc appendString:[NSString stringWithFormat:@"section: %@,%@\n",
                            [sec segmentName], [sec sectionName]]];
    }
    return [NSString stringWithString:desc];
}

@end

@implementation Section

@synthesize sectionName;
@synthesize segmentName;
@synthesize address;
@synthesize size;
@synthesize offset;
@synthesize align;
@synthesize relocationOffset;
@synthesize nreloc;
@synthesize flags;
@synthesize reserved1;
@synthesize reserved2;

-(Section *)initWithStruct:(struct section)sect
{
    self = [super init];
    if (self)
    {
        self.segmentName = @(sect.segname);
        self.sectionName = [@(sect.sectname)
                            stringByReplacingOccurrencesOfString:self.segmentName withString:@""];
        self.address = sect.addr;
        self.size = sect.size;
        self.offset = sect.offset;
        self.align = sect.align;
        self.relocationOffset = sect.reloff;
        self.nreloc = sect.nreloc;
        self.flags = sect.flags;
        self.reserved1 = sect.reserved1;
        self.reserved2 = sect.reserved2;
    }
    return self;
}

@end


@implementation SegmentCommand64

@synthesize location;
@synthesize sections;
@synthesize command;
@synthesize size;
@synthesize segmentName;
@synthesize vmaddr;
@synthesize vmsize;
@synthesize fileoff;
@synthesize filesize;
@synthesize maxprot;
@synthesize initprot;
@synthesize nsects;
@synthesize flags;

-(SegmentCommand64 *)initWithStruct:(struct segment_command_64)segment
{
    self = [super init];
    if (self)
    {
        self.command = segment.cmd;
        self.size = segment.cmdsize;
        self.segmentName = @(segment.segname);
        self.vmaddr = segment.vmaddr;
        self.vmsize = segment.vmsize;
        self.fileoff = segment.fileoff;
        self.filesize = segment.filesize;
        self.maxprot = segment.maxprot;
        self.initprot = segment.initprot;
        self.nsects = segment.nsects;
        self.flags = segment.flags;
    }
    return self;
}

+(SegmentCommand64 *)segment64CommandAtOffset:(unsigned int)off inData:(NSData *)binary
{
    struct segment_command_64 seg;
    seg = *(struct segment_command_64 *)([binary bytes] + off);
    SegmentCommand64 *cmd = [[SegmentCommand64 alloc] initWithStruct:seg];
    cmd.location = off;
    cmd.sections = [NSMutableArray array];
    unsigned int offset = off + sizeof(struct segment_command_64);
    
    for (int i = 0; i < cmd.nsects; i++)
    {
        struct section_64 sect;
        sect = *(struct section_64 *)([binary bytes] + offset);
        Section64 *section = [[Section64 alloc] initWithStruct:sect];
        offset += sizeof(struct section_64);
        
        [cmd.sections addObject:section];
    }
    
    return cmd;
}

-(Section64 *)section64WithName:(NSString *)sectname
{
    for (Section64 *i in [self sections])
    {
        if ([[i sectionName] isEqualToString:sectname])
        {
            return i;
        }
    }
    return NULL;
}

-(NSString *)description
{
    NSMutableString *desc = [NSMutableString string];
    for (Section64 *sec in [self sections])
    {
        [desc appendString:[NSString stringWithFormat:@"section: %@,%@\n",
                            [sec segmentName], [sec sectionName]]];
    }
    return [NSString stringWithString:desc];
}

@end

@implementation Section64

@synthesize sectionName;
@synthesize segmentName;
@synthesize address;
@synthesize size;
@synthesize offset;
@synthesize align;
@synthesize relocationOffset;
@synthesize nreloc;
@synthesize flags;
@synthesize reserved1;
@synthesize reserved2;
@synthesize reserved3;

-(Section64 *)initWithStruct:(struct section_64)sect
{
    self = [super init];
    if (self)
    {
        self.segmentName = @(sect.segname);
        self.sectionName = [@(sect.sectname)
                            stringByReplacingOccurrencesOfString:self.segmentName withString:@""];
        self.address = sect.addr;
        self.size = sect.size;
        self.offset = sect.offset;
        self.align = sect.align;
        self.relocationOffset = sect.reloff;
        self.nreloc = sect.nreloc;
        self.flags = sect.flags;
        self.reserved1 = sect.reserved1;
        self.reserved2 = sect.reserved2;
        self.reserved3 = sect.reserved3;
    }
    return self;
}

@end