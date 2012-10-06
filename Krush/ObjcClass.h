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

+(NSArray *)classesInMachO:(MachO *)mach withSymtab:(ObjcSymtab *)symtab;
+(ObjcClass *)classInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset; // i386
+(ObjcClass *)objc2ClassInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset; // x86_64


@end
