//
//  Header.h
//
//  Created by ████
//

#import <Cocoa/Cocoa.h>
#import "NSData+Util.h"

#include <mach-o/loader.h>

@interface Header : NSObject

@property unsigned int offset;
@property uint32_t magic;
@property cpu_type_t cputype;
@property cpu_subtype_t cpusubtype;
@property uint32_t filetype;
@property uint32_t ncmds;
@property uint32_t sizeofcmds;
@property uint32_t flags;
@property uint32_t reserved;

-(Header *)initWith32Struct:(struct mach_header)head;
-(Header *)initWith64Struct:(struct mach_header_64)head;
+(Header *)headerInData:(NSData *)data atOffset:(unsigned int)off;

@end
