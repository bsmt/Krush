//
//  ObjcClass.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>
#import "MachO.h"
#import "ObjcSymtab.h"
#import "ObjcMethod.h"
#import "NSData+Conversion.h"

/** Represents an Objective-C class, and contains all provided information about it. */

@interface ObjcClass : NSObject

@property unsigned long _isa;
@property NSString *super_class;
@property NSString *name;
@property unsigned long version;
@property unsigned long info;
@property unsigned long instance_size;
@property unsigned long instance_vars;
@property unsigned long method_lists;
@property unsigned long cache;
@property unsigned long protocols;
@property NSMutableArray *methods;


/// @name Initialization

/** Find all classes defined in the binary.
 
 @param symtab An ObjcSymtab object, which contains all of the needed information to find classes.
 @return An array of all known classes.
 */
+(NSArray *)classesInMachO:(MachO *)mach withSymtab:(ObjcSymtab *)symtab;

/** Create an ObjcClass object referencing one defined in the MachO.
 
 This method is to be used with 32 bit binaries only.
 
 @param mach The MachO to search in.
 @param offset The virtual offset the class is defined at.
 @return An ObjcClass located at the specified offset.
 @see objc2ClassInMachO:atVirtualOffset:
 */
+(ObjcClass *)classInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset; // i386

/** Create an ObjcClass object referencing one defined in the MachO.
 
 This method is to be used with 64 bit binaries only.
 
 @param mach The MachO to search in.
 @param offset The virtual offset the class is defined at.
 @return An ObjcClass located at the specified offset.
 @see classInMachO:atVirtualOffset:
 */
+(ObjcClass *)objc2ClassInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset; // x86_64


@end
