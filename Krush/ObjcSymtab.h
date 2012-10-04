//
//  ObjcSymbols.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>
#import "ObjcModule.h"
#import "MachO.h"
#import "ObjcStructs.h"

@interface ObjcSymtab : NSObject

@property unsigned int selector_ref_count;
@property unsigned int references;
@property unsigned int class_def_count;
@property unsigned int catagory_def_count;
@property NSArray *definitions; // locations of class/cat info

+(ObjcSymtab *)symtabFromStruct:(struct objc_symtab)symtab definitions:(NSArray *)defs;
+(NSArray *)symtabsFromModuleList:(NSArray *)modules inMachO:(MachO *)mach;

@end
