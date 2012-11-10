//
//  ObjcModule.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>
#import "MachO.h"
#import "SegmentCommand.h"
#import "ObjcStructs.h"

/** Represents an Objective C Module structure.
 
 These are only used in 32 bit MachOs.
*/

@interface ObjcModule : NSObject

@property unsigned long version;
@property unsigned long size;
@property unsigned long name;
@property unsigned long symtab;


/// @name Initialization

/** Creates an ObjcModule object from an objc_module struct
 
 @param mod_struct The objc_module struct from the binary.
 @return An ObjcModule object containing the information from the struct.
 */
+(ObjcModule *)moduleFromStruct:(struct objc_module)mod_struct;

/** Find all Objective-C module information in a MachO.
 
 @param mach The MachO to search in.
 @return An array of ObjcModule objects.
 */
+(NSArray *)modulesInMachO:(MachO *)mach;

@end
