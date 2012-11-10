//
//  ObjcCatagory.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>
#import "MachO.h"
#import "ObjcSymtab.h"
#import "ObjcMethod.h"

/** Represents an Objective-C category. */

@interface ObjcCategory : NSObject

@property NSString *category_name;
@property NSString *class_name;
@property unsigned long loc_instance_methods;
@property unsigned long loc_class_methods;
@property unsigned long protocols;
@property NSArray *class_methods;
@property NSArray *instance_methods;


/// @name Initialization

/** Find all categories defined in the MachO.
 
 @param mach The MachO to search in.
 @param symtab The ObjcSymtab that provides information about all defined categories.
 @return An array of all categories in the MachO.
 */
+(NSArray *)categoriesInMachO:(MachO *)mach withSymtab:(ObjcSymtab *)symtab;

/** Create an ObjcCategory object referencing one defined in the MachO.
 
 This method is to be used with 32 bit binaries only.
 
 @param mach The MachO to search in.
 @param offset The virtual offset the category is defined at.
 @return An ObjcCategory based on one located at the specified offset.
 @see objc2CategoryInMachO:atVirtualOffset:
 */
+(ObjcCategory *)categoryInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset; // i386

/** Create an ObjcCategory object referencing one defined in the MachO.
 
 This method is to be used with 64 bit binaries only.
 
 @param mach The MachO to search in.
 @param offset The virtual offset the category is defined at.
 @return An ObjcCategory based on one located at the specified offset.
 @see categoryInMachO:atVirtualOffset:
 */
+(ObjcCategory *)objc2CategoryInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset;

@end
