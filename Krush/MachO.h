//
//  MachO.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>

#import "Header.h"
#import "Command.h"
#import "SegmentCommand.h"
#import "SymtabCommand.h"

#include <mach-o/loader.h>

@interface MachO : NSObject

@property NSData *data;
@property unsigned int location;
@property cpu_type_t arch;
@property(retain) Header *header;
@property NSMutableArray *segments;
@property SymtabCommand *symtab;

-(MachO *)init;
+(MachO *)i386ObjectAtOffset:(unsigned int)off inData:(NSData *)bin;
+(MachO *)x86_64ObjectAtOffset:(unsigned int)off inData:(NSData *)bin;

-(SegmentCommand *)segmentWithName:(NSString *)segname;
-(SegmentCommand64 *)segment64WithName:(NSString *)segname;
-(Section *)section:(NSString *)sectName inSegment:(NSString *)segName;
-(Section64 *)section64:(NSString *)sectName inSegment:(NSString *)segName;

-(unsigned long)convertVirtualOffset:(unsigned long)virtual;
-(unsigned long)convertRealOffset:(unsigned long)real;

-(NSString *)description;

@end
