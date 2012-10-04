//
//  ObjcClass.m
//
//  Created by ████
//

#import "ObjcClass.h"

@implementation ObjcClass

+(NSArray *)classesInMachO:(MachO *)mach withSymtab:(ObjcSymtab *)symtab
{
    NSMutableArray *classes = [NSMutableArray array];
    int i = 0;
    while (i < symtab.class_def_count)
    {
        // class definitions occur first in the symtab's list. so we don't have to worry about taking category definitions.
        unsigned int def = [[symtab definitions][i] intValue];
        ObjcClass *class = [ObjcClass classInMachO:mach atVirtualOffset:(unsigned int)def];
        if (class)
        {
            [classes addObject:class];
        }
        i++;
    }
    
    return [NSArray arrayWithArray:classes];
}

+(ObjcClass *)classInMachO:(MachO *)mach atVirtualOffset:(unsigned int)offset
{
    if (offset == 0)
    {
        return NULL;
    }
    
    ObjcClass *class = [[ObjcClass alloc] init];
    unsigned int real_offset = [mach convertVirtualOffset:offset];
    struct objc_class *class_struct = (struct objc_class *)((char *)[[mach data] bytes] + real_offset);
    
    class._isa = class_struct->isa;
    unsigned int superclass_offset = [mach convertVirtualOffset:class_struct->super_class] - 1;
    class.super_class = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:superclass_offset]
                                              encoding:NSASCIIStringEncoding];
    unsigned int name_offset = [mach convertVirtualOffset:class_struct->name] - 1;
    class.name = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:name_offset]
                                       encoding:NSASCIIStringEncoding];
    class.version = class_struct->version;
    class.info = class_struct->info;
    class.instance_size = class_struct->instance_size;
    class.instance_vars = class_struct->ivars;
    class.method_lists = class_struct->methods;
    class.cache = class_struct->cache;
    class.protocols = class_struct->protocols;
    class.methods = [NSMutableArray array];
    
    // find class methods
    unsigned int metaclass_offset = [mach convertVirtualOffset:class._isa]; // metaclass section has class method info
    struct objc_class *metaclass = (struct objc_class *)((char *)[[mach data] bytes] + metaclass_offset);
    
    if (metaclass->methods != 0)
    {
        NSArray *class_methods = [ObjcMethod methodsInMachO:mach atVirtualOffset:metaclass->methods type:CLASS_METHOD];
        [[class methods] addObjectsFromArray:class_methods];
    }
    
    // find instance methods
    if (class.method_lists != 0)
    {
        NSArray *inst_methods = [ObjcMethod methodsInMachO:mach atVirtualOffset:class.method_lists type:INSTANCE_METHOD];
        [[class methods] addObjectsFromArray:inst_methods];
    }
    
    return class;
}

@end
