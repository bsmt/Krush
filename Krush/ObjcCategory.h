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
@property unsigned int loc_instance_methods;
@property unsigned int loc_class_methods;
@property unsigned int protocols;
@property NSArray *class_methods;
@property NSArray *instance_methods;

+(NSArray *)categoriesInMachO:(MachO *)mach withSymtab:(ObjcSymtab *)symtab;
+(ObjcCategory *)categoryInMachO:(MachO *)mach atVirtualOffset:(unsigned int)offset;

@end
