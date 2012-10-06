//
//  ObjcMethod.m
//
//  Created by ████
//

#import "ObjcMethod.h"

@implementation ObjcMethod

+(NSArray *)methodsInMachO:(MachO *)mach atVirtualOffset:(unsigned long)offset type:(enum method_type)type
{
    if (offset == 0)
    {
        // return empty array
        return @[];
    }
    
    unsigned long real_offset = [mach convertVirtualOffset:offset];
    NSMutableArray *methods = [NSMutableArray array];
    struct objc_method_list *method_list = (struct objc_method_list *)((char *)[[mach data] bytes] + real_offset);
    real_offset += sizeof(struct objc_method_list);
        
    int i = 0;
    while (i < method_list->method_count)
    {
        if (mach.arch == CPU_TYPE_I386)
        {
            struct objc_method *method_struct = (struct objc_method *)((char *)[[mach data] bytes] + real_offset);
            real_offset += sizeof(struct objc_method);
            ObjcMethod *method = [ObjcMethod methodFromStruct:*method_struct inMachO:mach type:type];
            [methods addObject:method];
        }
        else if (mach.arch == CPU_TYPE_X86_64)
        {
            struct objc64_method *method_struct = (struct objc64_method *)((char *)[[mach data] bytes] + real_offset);
            real_offset += sizeof(struct objc64_method);
            ObjcMethod *method = [ObjcMethod objc2MethodFromStruct:*method_struct inMachO:mach type:type];
            [methods addObject:method];
        }
        i++;
    }
        
    return [NSArray arrayWithArray:methods];
}

+(ObjcMethod *)methodFromStruct:(struct objc_method)method_struct inMachO:(id)mach type:(enum method_type)type
{
    ObjcMethod *method = [[ObjcMethod alloc] init];
    if (!method)
    {
        return NULL;
    }
    
    method.type = type;
    unsigned long name_offset = [mach convertVirtualOffset:method_struct.name];
    NSString *name = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:name_offset - 1]
                                           encoding:NSASCIIStringEncoding];
    method.name = name;
    unsigned long types_offset = [mach convertVirtualOffset:method_struct.types];
    NSString *types = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:types_offset - 1]
                                            encoding:NSASCIIStringEncoding];
    method.types = types;
    method.imp = method_struct.imp;
    
    return method;
}

+(ObjcMethod *)objc2MethodFromStruct:(struct objc64_method)method_struct inMachO:(MachO *)mach type:(enum method_type)type
{
    ObjcMethod *method = [[ObjcMethod alloc] init];
    if (!method)
    {
        return NULL;
    }
    
    method.type = type;
    unsigned long name_offset = [mach convertVirtualOffset:method_struct.name];
    NSString *name = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:name_offset - 1]
                                           encoding:NSASCIIStringEncoding];
    method.name = name;
    unsigned long types_offset = [mach convertVirtualOffset:method_struct.types];
    NSString *types = [[NSString alloc] initWithData:[[mach data] readTillNullAtOffset:types_offset - 1]
                                            encoding:NSASCIIStringEncoding];
    method.types = types;
    method.imp = method_struct.imp;
    
    return method;
}

@end
