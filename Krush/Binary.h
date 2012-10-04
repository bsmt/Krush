//
//  Binary.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>

#import "NSData+Util.h"
#import "MachO.h"

#include <mach-o/loader.h>
#include <mach-o/fat.h>

/** Main class for abstracting binaries.
 
 It contains one or more MachO objects, held in the machs array that represent the different objects (one for each arch)
contained in the binary.
*/

@interface Binary : NSObject

/// Path to the binary to be parsed.
@property NSURL *path;

/// Binary contents.
@property NSData *binary;

/// Array containing MachO objects, one for each architecture.
@property NSMutableArray *machs;

-(id)initWithBinaryAtPath:(NSString *)path;

-(void)parseBinary;

@end
