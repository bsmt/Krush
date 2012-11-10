//
//  ObjcSymbols.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>
#import "ObjcModule.h"
#import "MachO.h"
#import "ObjcStructs.h"

/** Represents an Objective-C symbol table.
 
 These are used in both 32 and 64 bit binaries.
*/

@interface ObjcSymtab : NSObject

@property unsigned long selector_ref_count;
@property unsigned long references;
@property unsigned long class_def_count;
@property unsigned long catagory_def_count;
@property NSArray *definitions; // locations of class/cat info


/// @name Initialization

/** Create an ObjcSymtab object using an objc_symtab struct and a list of symbol definitions.
 
 @param symtab The objc_symtab struct.
 @param defs A list of definitions to use with the symbol table.
 @return An ObjcSymtab object.
 */
+(ObjcSymtab *)symtabFromStruct:(struct objc_symtab)symtab definitions:(NSArray *)defs;

/** Find all symbol tables in the binary using a list of all modules in the binary.
 
 @param modules A list of every ObjcModule in the MachO.
 @param mach The MachO to search in.
 @return An array of every Objective-C symtab in the MachO.
 */
+(NSArray *)symtabsFromModuleList:(NSArray *)modules inMachO:(MachO *)mach;

@end
