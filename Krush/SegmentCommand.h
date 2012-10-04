//
//  SegmentCommand.h
//
//  Created by ████
//

#import <Cocoa/Cocoa.h>
#import "Command.h"

#include <mach-o/loader.h>

@interface Section : NSObject

@property NSString *sectionName;
@property NSString *segmentName;
@property uint32_t address;
@property uint32_t size;
@property uint32_t offset;
@property uint32_t align;
@property uint32_t relocationOffset;
@property uint32_t nreloc;
@property uint32_t flags;
@property uint32_t reserved1;
@property uint32_t reserved2;

-(Section *)initWithStruct:(struct section)sect;

@end


@interface SegmentCommand : NSObject

@property unsigned int location;
@property NSMutableArray *sections;
@property uint32_t command;
@property uint32_t size;
@property NSString *segmentName;
@property uint32_t vmaddr;
@property uint32_t vmsize;
@property uint32_t fileoff;
@property uint32_t filesize;
@property vm_prot_t maxprot;
@property vm_prot_t initprot;
@property uint32_t nsects;
@property uint32_t flags;

-(SegmentCommand *)initWithStruct:(struct segment_command)segment;
+(SegmentCommand *)segmentCommandAtOffset:(unsigned int)off inData:(NSData *)binary;

-(Section *)sectionWithName:(NSString *)sectname;

-(NSString *)description;

@end


@interface Section64 : NSObject

@property NSString *sectionName;
@property NSString *segmentName;
@property uint64_t address;
@property uint64_t size;
@property uint32_t offset;
@property uint32_t align;
@property uint32_t relocationOffset;
@property uint32_t nreloc;
@property uint32_t flags;
@property uint32_t reserved1;
@property uint32_t reserved2;
@property uint32_t reserved3;

-(Section64 *)initWithStruct:(struct section_64)sect;

@end


@interface SegmentCommand64 : NSObject

@property unsigned int location;
@property NSMutableArray *sections;
@property uint32_t command;
@property uint32_t size;
@property NSString *segmentName;
@property uint64_t vmaddr;
@property uint64_t vmsize;
@property uint64_t fileoff;
@property uint64_t filesize;
@property vm_prot_t maxprot;
@property vm_prot_t initprot;
@property uint32_t nsects;
@property uint32_t flags;

-(SegmentCommand64 *)initWithStruct:(struct segment_command_64)segment;
+(SegmentCommand64 *)segment64CommandAtOffset:(unsigned int)off inData:(NSData *)binary;

-(Section64 *)section64WithName:(NSString *)sectname;

-(NSString *)description;

@end