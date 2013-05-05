//
//  ObjcModule.m
//
//  Created by ████
//

#import "ObjcModule.h"

@implementation ObjcModule

+(ObjcModule *)moduleFromStruct:(struct objc_module)mod_struct
{
    ObjcModule *mod = [[ObjcModule alloc] init];
    if (!mod)
    {
        return NULL;
    }
    else
    {
        mod.version = mod_struct.version;
        mod.size = mod_struct.size;
        mod.name = mod_struct.name;
        mod.symtab = mod_struct.symtab;
        return mod;
    }
}

+(NSArray *)modulesInMachO:(MachO *)mach
{
    if (mach.arch != CPU_TYPE_I386) // __OBJC,__module_info only exists in 32bit
    {
        return NULL;
    }

    Section *modSect = [mach section:@"__module_info" inSegment:@"__OBJC"];
    if (!modSect)
    {
        return NULL;
    }
    
    NSMutableArray *modules = [[NSMutableArray alloc] init];
    unsigned int actualOffset = mach.location + modSect.offset;
    unsigned int end = actualOffset + modSect.size;
    
    while (actualOffset < end)
    {
        struct objc_module *mod_struct = (struct objc_module *)([[mach data] bytes] + actualOffset);
        ObjcModule *mod = [ObjcModule moduleFromStruct:*mod_struct];
        [modules addObject:mod];
        actualOffset += sizeof(struct objc_module);
    }
    
    return [NSArray arrayWithArray:modules];
}

@end
