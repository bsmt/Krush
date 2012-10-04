//
//  ObjcClass.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>
#import "MachO.h"
#import "ObjcSymtab.h"
#import "ObjcMethod.h"
#import "NSData+Util.h"

@interface ObjcClass : NSObject

@property unsigned int _isa;
@property NSString *super_class;
@property NSString *name;
@property unsigned int version;
@property unsigned int info;
@property unsigned int instance_size;
@property unsigned int instance_vars;
@property unsigned int method_lists;
@property unsigned int cache;
@property unsigned int protocols;
@property NSMutableArray *methods;

+(NSArray *)classesInMachO:(MachO *)mach withSymtab:(ObjcSymtab *)symtab;
+(ObjcClass *)classInMachO:(MachO *)mach atVirtualOffset:(unsigned int)offset;

@end
