//
//  Assembler.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>

#import "NSData+Util.h"

#include <machine/endian.h>

/** Assembles instructions needed by the Patcher. */

@interface Assembler : NSObject

/** Assembles a mov $number, %rax instruction.
 
 @param ret Return value to put in %eax or %rax.
 @return The opcode for that instruction. For example, mov $0x1, %eax on i386 returns 31c040c3.
 */
+(NSData *)opcodeForRetValue:(unsigned int)ret arch:(cpu_type_t)arch;

@end
