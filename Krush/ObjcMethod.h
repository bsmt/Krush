//
//  ObjcMethod.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>
#import "MachO.h"
#import "ObjcStructs.h"

enum method_type
{
    INSTANCE_METHOD = 0,
    CLASS_METHOD = 1,
    CAT_INSTANCE_METHOD = 2,
    CAT_CLASS_METHOD = 3
};

/** Represents a method belonging to an ObjcClass or ObjcCategory object. */

@interface ObjcMethod : NSObject

@property enum method_type type;
@property NSString *name;
@property NSString *types;
@property unsigned long imp;


/// @name Initialization

/** Find all methods of a certain type in a MachO.
 
 @param mach The MachO to search in.
 @param offset The virtual offset where the list of methods starts.
 @param type The type of method. Either, INSTANCE_METHOD, CLASS_METHOD, CAT_INSTANCE_METHOD or CAT_CLASS_METHOD.
 @return An array of all methods in the MachO.
 */
+(NSArray *)methodsInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset type:(enum method_type)type;

/** Create an ObjcMethod object referencing one defined in the MachO.
 
 This method is to be used with 32 bit binaries only.
 
 @param method_struct the objc_method struct from the binary that defines one method.
 @param mach The MachO to search in.
 @param type The type of method that is being defined.
 @return An ObjcMethod object based on the information given.
 @see objc2MethodFromStruct:inMachO:type:
 */
+(ObjcMethod *)methodFromStruct:(struct objc_method)method_struct inMachO:(MachO *)mach type:(enum method_type)type; // i386

/** Create an ObjcMethod object referencing one defined in the MachO.
 
 This method is to be used with 64 bit binaries only.
 
 @param method_struct the objc_method struct from the binary that defines one method.
 @param mach The MachO to search in.
 @param type The type of method that is being defined.
 @return An ObjcMethod object based on the information given.
 @see methodFromStruct:inMachO:type:
 */
+(ObjcMethod *)objc2MethodFromStruct:(struct objc64_method)method_struct inMachO:(MachO *)mach type:(enum method_type)type; // x86_64

@end
