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

+(ObjcClass *)classInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset
{
    if (offset == 0)
    {
        return NULL;
    }
    
    ObjcClass *class = [[ObjcClass alloc] init];
    unsigned long real_offset = [mach convertVirtualOffset:offset];
    struct objc_class *class_struct = (struct objc_class *)((char *)[[mach data] bytes] + real_offset);
    
    class._isa = class_struct->isa;
    unsigned long superclass_offset = [mach convertVirtualOffset:class_struct->super_class] - 1;
    class.super_class = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:superclass_offset]
                                              encoding:NSASCIIStringEncoding];
    unsigned long name_offset = [mach convertVirtualOffset:class_struct->name] - 1;
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
    unsigned long metaclass_offset = [mach convertVirtualOffset:class._isa]; // metaclass section has class method info
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

+(ObjcClass *)objc2ClassInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset
{
    if (offset == 0)
    {
        return NULL;
    }
    
    ObjcClass *class = [[ObjcClass alloc] init];
    
    unsigned long file_offset = [mach convertVirtualOffset:offset];
    struct objc64_class *class_struct = (struct objc64_class *)((char *)[[mach data] bytes] + file_offset);
    
    class._isa = class_struct->isa;
    
    // it uses some constants for built-in things like NSObject
    if (class_struct->superclass == 0)
    {
        class.super_class = @"NSObject";
    }
    else
    {
        unsigned long superclass_offset = [mach convertVirtualOffset:class_struct->superclass] - 1;
        class.super_class = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:superclass_offset]
                                                  encoding:NSASCIIStringEncoding];
    }
    
    class.cache = class_struct->cache;
    // we're ignoring vtable for now...
    
    struct objc64_class_ro_t *class_data = (struct objc64_class_ro_t *)((char *)[[mach data] bytes] +
                                                                        [mach convertVirtualOffset:class_struct->data]);
    
    class.version = 0;
    class.info = 0;
    class.instance_size = class_data->instanceSize;
    class.instance_vars = class_data->ivars;
    class.method_lists = class_data->baseMethods;
    class.protocols = class_data->baseProtocols;
    class.methods = [NSMutableArray array];
    
    unsigned long name_offset = [mach convertVirtualOffset:class_data->name] - 1;
    class.name = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:name_offset]
                                       encoding:NSASCIIStringEncoding];
    
    // find class methods
    unsigned long metaclass_offset = [mach convertVirtualOffset:class._isa];
    struct objc64_class *metaclass = (struct objc64_class *)((char *)[[mach data] bytes] + metaclass_offset);
    struct objc64_class_ro_t *metaclass_data = (struct objc64_class_ro_t *)((char *)[[mach data] bytes] +
                                                                            [mach convertVirtualOffset:metaclass->data]);
    
    if (metaclass_data->baseMethods != 0)
    {
        NSArray *class_methods = [ObjcMethod methodsInMachO:mach atVirtualOffset:metaclass_data->baseMethods
                                                       type:CLASS_METHOD];
        [[class methods] addObjectsFromArray:class_methods];
    }

    // find instance methods
    if (class_data->baseMethods != 0)
    {
        NSArray *instance_methods = [ObjcMethod methodsInMachO:mach atVirtualOffset:class_data->baseMethods
                                                          type:INSTANCE_METHOD];
        [[class methods] addObjectsFromArray:instance_methods];
    }
    
    return class;
}

@end
