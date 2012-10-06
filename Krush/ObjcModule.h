//
//  ObjcModule.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>
#import "MachO.h"
#import "SegmentCommand.h"
#import "ObjcStructs.h"

@interface ObjcModule : NSObject

@property unsigned long version;
@property unsigned long size;
@property unsigned long name;
@property unsigned long symtab;

+(ObjcModule *)moduleFromStruct:(struct objc_module)mod_struct;
+(NSArray *)modulesInMachO:(MachO *)mach;

@end
