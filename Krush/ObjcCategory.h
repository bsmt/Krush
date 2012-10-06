//
//  ObjcCatagory.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>
#import "MachO.h"
#import "ObjcSymtab.h"
#import "ObjcMethod.h"

@interface ObjcCategory : NSObject

@property NSString *category_name;
@property NSString *class_name;
@property unsigned long loc_instance_methods;
@property unsigned long loc_class_methods;
@property unsigned long protocols;
@property NSArray *class_methods;
@property NSArray *instance_methods;

+(NSArray *)categoriesInMachO:(MachO *)mach withSymtab:(ObjcSymtab *)symtab;
+(ObjcCategory *)categoryInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset; // i386
+(ObjcCategory *)objc2CategoryInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset;

@end
