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
 
 It contains one or more MachO objects that contain code for each architecture supported by the binary.
 */

@interface Binary : NSObject

/// Path to the binary to be parsed.
@property NSURL *path;

/// Binary contents.
@property NSData *binary;

/// Array containing MachO objects, one for each architecture.
@property NSMutableArray *machs;

/// @name Initialization

/** Make a new Binary object from one at the given path.
 
 @param path Path to the target binary. Can contain tildes.
 @return Initialized Binary object that has been parsed for all MachO information.
 */
-(id)initWithBinaryAtPath:(NSString *)path;

/// @name Actions

/// Gather all required information from the Mach Objects inside the binary.
-(void)parseBinary;

@end
