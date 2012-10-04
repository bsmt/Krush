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

@interface ObjcMethod : NSObject

@property enum method_type type;
@property NSString *name;
@property NSString *types;
@property unsigned int imp;

+(NSArray *)methodsInMachO:(MachO *)mach atVirtualOffset:(unsigned int)offset type:(enum method_type)type; // offset = start of objc_method_list
+(ObjcMethod *)methodFromStruct:(struct objc_method)method_struct inMachO:(MachO *)mach type:(enum method_type)type;

@end
