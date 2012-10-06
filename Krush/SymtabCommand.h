//
//  SymtabCommand.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>

#include <mach-o/loader.h>
#include <mach-o/nlist.h>

@interface SymtabCommand : NSObject

@property unsigned int location;
@property NSMutableArray *nlists;
@property uint32_t command;
@property uint32_t size;
@property uint32_t symoff;
@property uint32_t nsyms;
@property uint32_t stringoff;
@property uint32_t stringsize;

-(SymtabCommand *)initWithStruct:(struct symtab_command)sym;
+(SymtabCommand *)symtabCommandAtOffset:(unsigned int)off inData:(NSData *)binary;

@end

@interface nlist32 : NSObject

@property uint32_t stringIndex;
@property uint8_t type;
@property uint8_t sect;
@property uint16_t desc;
@property uint32_t value;

-(nlist32 *)initWithStruct:(struct nlist)nl;

@end

@interface nlist64 : NSObject

@property uint32_t stringIndex;
@property uint8_t type;
@property uint8_t sect;
@property uint16_t desc;
@property unsigned long value;

-(nlist64 *)initWithStruct:(struct nlist_64)nl;

@end