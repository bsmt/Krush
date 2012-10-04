//
//  Assembler.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>

#import "NSData+Util.h"

#include <machine/endian.h>

@interface Assembler : NSObject

+(NSData *)opcodeForRetValue:(unsigned int)ret arch:(cpu_type_t)arch;

@end
