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

@property unsigned int version;
@property unsigned int size;
@property unsigned int name;
@property unsigned int symtab;

+(ObjcModule *)moduleFromStruct:(struct objc_module)mod_struct;
+(NSArray *)modulesInMachO:(MachO *)mach;

@end
