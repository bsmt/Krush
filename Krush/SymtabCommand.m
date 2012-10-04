//
//  SymtabCommand.m
//
//  Created by ████
//

#import "SymtabCommand.h"

@implementation SymtabCommand

@synthesize location;
@synthesize nlists;
@synthesize command;
@synthesize size;
@synthesize symoff;
@synthesize nsyms;
@synthesize stringoff;
@synthesize stringsize;

-(SymtabCommand *)initWithStruct:(struct symtab_command)sym
{
    self = [super init];
    if (self)
    {
        self.command = sym.cmd;
        self.size = sym.cmdsize;
        self.symoff = sym.symoff;
        self.nsyms = sym.nsyms;
        self.stringoff = sym.stroff;
        self.stringsize = sym.strsize;
    }
    return self;
}

+(SymtabCommand *)symtabCommandAtOffset:(unsigned int)off inData:(NSData *)binary
{
    struct symtab_command sym;
    sym = *(struct symtab_command *)((char *)[binary bytes] + off);
    SymtabCommand *symtab = [[SymtabCommand alloc] initWithStruct:sym];
    symtab.location = off;
    symtab.nlists = [NSMutableArray array];
        
    return symtab;
}

@end

@implementation nlist32

@synthesize stringIndex;
@synthesize type;
@synthesize sect;
@synthesize desc;
@synthesize value;

-(nlist32 *)initWithStruct:(struct nlist)nl
{
    self = [super init];
    if (self)
    {
        self.stringIndex = nl.n_un.n_strx;
        self.type = nl.n_type;
        self.sect = nl.n_sect;
        self.desc = nl.n_desc;
        self.value = nl.n_value;
    }
    return self;
}

@end

@implementation nlist64

@synthesize stringIndex;
@synthesize type;
@synthesize sect;
@synthesize desc;
@synthesize value;

-(nlist64 *)initWithStruct:(struct nlist_64)nl
{
    self = [super init];
    if (self)
    {
        self.stringIndex = nl.n_un.n_strx;
        self.type = nl.n_type;
        self.sect = nl.n_sect;
        self.desc = nl.n_desc;
        self.value = nl.n_value;
    }
    return self;
}

@end