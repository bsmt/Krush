//
//  Command.h
//
//  Created by ████
//

#import <Cocoa/Cocoa.h>
#import "NSData+Util.h"
#import "SegmentCommand.h"
#import "SymtabCommand.h"

#include <mach-o/loader.h>

@class MachO;

@interface Command : NSObject

+(void)parseLoadCommandsInMachO:(MachO *)mach atOffset:(unsigned int)off inData:(NSData *)binary;

@end
