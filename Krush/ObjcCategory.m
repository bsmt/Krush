//
//  ObjcCatagory.m
//
//  Created by ████
//

#import "ObjcCategory.h"

@implementation ObjcCategory

+(NSArray *)categoriesInMachO:(MachO *)mach withSymtab:(ObjcSymtab *)symtab
{
    NSMutableArray *categories = [NSMutableArray array];
    int index = (int)symtab.class_def_count; // start at end of class defs
    int i = 0;
    while (i < symtab.catagory_def_count)
    {
        unsigned int def = [[symtab definitions][index] intValue];
        ObjcCategory *category = [ObjcCategory categoryInMachO:mach atVirtualOffset:def];
        if (category)
        {
            [categories addObject:category];
        }
        index++;
        i++;
    }
    
    return [NSArray arrayWithArray:categories];
}

+(ObjcCategory *)categoryInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset
{
    if (offset == 0)
    {
        return NULL;
    }
    
    ObjcCategory *category = [[ObjcCategory alloc] init];
    if (!category)
    {
        return NULL;
    }
    
    unsigned long real_offset = [mach convertVirtualOffset:offset];
    struct objc_catagory *cat_struct = (struct objc_catagory *)((char *)[[mach data] bytes] + real_offset);
    
    unsigned long cat_name_offset = [mach convertVirtualOffset:cat_struct->category_name] - 1;
    category.category_name = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:cat_name_offset]
                                                   encoding:NSASCIIStringEncoding];
    unsigned long class_name_offset = [mach convertVirtualOffset:cat_struct->class_name] - 1;
    category.class_name = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:class_name_offset]
                                                encoding:NSASCIIStringEncoding];
    category.loc_instance_methods = cat_struct->methods;
    category.loc_class_methods = cat_struct->class_methods;
    category.protocols = cat_struct->protocols;
    
    // find class methods
    category.class_methods = [ObjcMethod methodsInMachO:mach atVirtualOffset:category.loc_class_methods type:CAT_CLASS_METHOD];
    
    // find instance methods
    category.instance_methods = [ObjcMethod methodsInMachO:mach atVirtualOffset:category.loc_instance_methods type:CAT_INSTANCE_METHOD];
    
    return category;
}

+(ObjcCategory *)objc2CategoryInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset
{
    if (offset == 0)
    {
        return NULL;
    }
    
    ObjcCategory *category = [[ObjcCategory alloc] init];
    if (!category)
    {
        return NULL;
    }
    
    unsigned long real_offset = [mach convertVirtualOffset:offset];
    struct objc64_catagory *cat_struct = (struct objc64_catagory *)((char *)[[mach data] bytes] + real_offset);
    
    unsigned long name_offset = [mach convertVirtualOffset:cat_struct->name];
    category.category_name = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:name_offset - 1]
                                                   encoding:NSASCIIStringEncoding];
    
    // need to figure this out
    category.class_name = @"NSObject";
    
    category.loc_instance_methods = cat_struct->instanceMethods;
    category.loc_class_methods = cat_struct->classMethods;
    category.protocols = cat_struct->protocols;
    
    // find class methods
    category.class_methods = [ObjcMethod methodsInMachO:mach atVirtualOffset:category.loc_class_methods type:CAT_CLASS_METHOD];
    
    // find instance methods
    category.instance_methods = [ObjcMethod methodsInMachO:mach atVirtualOffset:category.loc_instance_methods type:CAT_INSTANCE_METHOD];
    
    return category;
}

@end
