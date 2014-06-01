//
//  MachO+Symbol.m
//
//  Created by ████
//

#import "MachO+Symbol.h"
#import "MachO+Constants.h"

@implementation MachO (Symbol)

-(unsigned long)virtualOffsetForSymbol:(NSString *)sym
{
    NSDictionary *symbols = [self findAllSymbols];
    return [symbols[sym] unsignedLongValue];
}

-(unsigned long)realOffsetForSymbol:(NSString *)sym
{
    return [self convertVirtualOffset:[self virtualOffsetForSymbol:sym]];
}

-(NSDictionary *)findAllSymbols
{
    NSMutableDictionary *symbols = [NSMutableDictionary dictionary];
    
    unsigned int nlistOff = self.location + self.symtab.symoff;
    unsigned int strOff = self.location + self.symtab.stringoff;
    
    // find symbols from nlists pointed to by LC_SYMTAB
    // these contain c/c++ symbols as well as objc some of the time
    for (int i = 0; i < self.symtab.nsyms; i++)
    {
        if (self.arch == CPU_TYPE_I386)
        {
            struct nlist nl;
            nl = *(struct nlist *)([[self data] bytes] + nlistOff);
            nlist32 *nlist = [[nlist32 alloc] initWithStruct:nl];
            nlistOff += sizeof(struct nlist);
            [[[self symtab] nlists] addObject:nlist];
            
            if (([nlist type] & N_TYPE) == N_SECT)
            {
                NSString *name = [[[self data] readTillNullAtOffset:(strOff + [nlist stringIndex] - 1)] toString];
                if ([name rangeOfString:@"+"].location != NSNotFound || [name rangeOfString:@"-"].location != NSNotFound)
                {
                    // we skip objc info because it isn't always in the nlists
                    continue;
                }
                symbols[name] = [NSNumber numberWithUnsignedLong:(unsigned long)nlist.value];
            }
        }
        else if (self.arch == CPU_TYPE_ARM)
        {
            struct nlist nl;
            nl = *(struct nlist *)([[self data] bytes] + nlistOff);
            nlist32 *nlist = [[nlist32 alloc] initWithStruct:nl];
            nlistOff += sizeof(struct nlist);
            [[[self symtab] nlists] addObject:nlist];
            
            if (([nlist type] & N_TYPE) == N_SECT)
            {
                NSString *name = [[[self data] readTillNullAtOffset:(strOff + [nlist stringIndex] - 1)] toString];
                if ([name rangeOfString:@"+"].location != NSNotFound || [name rangeOfString:@"-"].location != NSNotFound)
                {
                    // we skip objc info because it isn't always in the nlists
                    continue;
                }
                symbols[name] = [NSNumber numberWithUnsignedLong:(unsigned long)nlist.value];
            }
        }
        
        else if (self.arch == CPU_TYPE_ARM64)
        {
            struct nlist_64 nl;
            nl = *(struct nlist_64 *)([[self data] bytes] + nlistOff);
            nlist64 *nlist = [[nlist64 alloc] initWithStruct:nl];
            nlistOff += sizeof(struct nlist_64);
            [[[self symtab] nlists] addObject:nlist];
            
            if (([nlist type] & N_TYPE) == N_SECT)
            {
                NSString *name = [[[self data] readTillNullAtOffset:(strOff + [nlist stringIndex] - 1)] toString];
                if ([name rangeOfString:@"+"].location != NSNotFound || [name rangeOfString:@"-"].location != NSNotFound)
                {
                    continue;
                }
                symbols[name] = [NSNumber numberWithUnsignedLong:nlist.value];
            }
        }
        
        else if (self.arch == CPU_TYPE_X86_64)
        {
            struct nlist_64 nl;
            nl = *(struct nlist_64 *)([[self data] bytes] + nlistOff);
            nlist64 *nlist = [[nlist64 alloc] initWithStruct:nl];
            nlistOff += sizeof(struct nlist_64);
            [[[self symtab] nlists] addObject:nlist];
            
            if (([nlist type] & N_TYPE) == N_SECT)
            {
                NSString *name = [[[self data] readTillNullAtOffset:(strOff + [nlist stringIndex] - 1)] toString];
                if ([name rangeOfString:@"+"].location != NSNotFound || [name rangeOfString:@"-"].location != NSNotFound)
                {
                    continue;
                }
                symbols[name] = [NSNumber numberWithUnsignedLong:nlist.value];
            }
        }
    }
    
    NSArray *classes = [self classes];
    for (ObjcClass *class in classes)
    {
        for (ObjcMethod *method in class.methods)
        {
            if (method.type == INSTANCE_METHOD)
            {
                NSString *method_string = [NSString stringWithFormat:@"-[%@ %@]", class.name, method.name];
                symbols[method_string] = [NSNumber numberWithUnsignedLong:method.imp];
            }
            else if (method.type == CLASS_METHOD)
            {
                NSString *method_string = [NSString stringWithFormat:@"+[%@ %@]", class.name, method.name];
                symbols[method_string] = [NSNumber numberWithUnsignedLong:method.imp];
            }
        }
    }
    
    NSArray *categories = [self categories];
    for (ObjcCategory *category in categories)
    {
        for (ObjcMethod *method in category.instance_methods)
        {
            if (method.type == CAT_INSTANCE_METHOD)
            {
                NSString *method_string = [NSString stringWithFormat:@"-[%@ (%@) %@]", category.class_name,
                                           category.category_name, method.name];
                symbols[method_string] = [NSNumber numberWithUnsignedLong:method.imp];
            }
        }
        
        for (ObjcMethod *method in category.class_methods)
        {
            if (method.type == CAT_CLASS_METHOD)
            {
                NSString *method_string = [NSString stringWithFormat:@"+[%@ (%@) %@]", category.class_name,
                                           category.category_name, method.name];
                symbols[method_string] = [NSNumber numberWithUnsignedLong:method.imp];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:symbols];
}

-(NSArray *)classes
{
    if (self.arch == CPU_TYPE_I386)
    {
        NSArray *modules = [ObjcModule modulesInMachO:self];
        NSArray *symtabs = [ObjcSymtab symtabsFromModuleList:modules inMachO:self];
        
        NSMutableArray *classes = [NSMutableArray array];
        
        for (ObjcSymtab *symtab in symtabs)
        {
            NSArray *temp_classes = [ObjcClass classesInMachO:self withSymtab:symtab];
            [classes addObjectsFromArray:temp_classes];
        }
        
        return [NSArray arrayWithArray:classes];
    }
    else if (self.arch == CPU_TYPE_X86_64)
    {
        Section64 *class_list = [self section64:@"__objc_classlist" inSegment:@"__DATA"];
        
        NSMutableArray *classes = [NSMutableArray array];
        
        for (int i = 0; i < class_list.size; i += 8)
        {
            unsigned long pointer = [self.data littleEndianIntDataInRange:
                                     NSMakeRange([self convertVirtualOffset:class_list.address] + i, 8)];
            ObjcClass *class = [ObjcClass objc2ClassInMachO:self atVirtualOffset:pointer];
            [classes addObject:class];
        }
        
        return [NSArray arrayWithArray:classes];
    }
    else if (self.arch == CPU_TYPE_ARM64)
    {
        Section64 *class_list = [self section64:@"__objc_classlist" inSegment:@"__DATA"];
        
        NSMutableArray *classes = [NSMutableArray array];
        
        for (int i = 0; i < class_list.size; i += 8)
        {
            unsigned long pointer = [self.data littleEndianIntDataInRange:
                                     NSMakeRange([self convertVirtualOffset:class_list.address] + i, 8)];
            ObjcClass *class = [ObjcClass objc2ClassInMachO:self atVirtualOffset:pointer];
            [classes addObject:class];
        }
        
        return [NSArray arrayWithArray:classes];
    }
    
    else if (self.arch == CPU_TYPE_ARM)
    {
        NSArray *modules = [ObjcModule modulesInMachO:self];
        NSArray *symtabs = [ObjcSymtab symtabsFromModuleList:modules inMachO:self];
        
        NSMutableArray *classes = [NSMutableArray array];
        
        for (ObjcSymtab *symtab in symtabs)
        {
            NSArray *temp_classes = [ObjcClass classesInMachO:self withSymtab:symtab];
            [classes addObjectsFromArray:temp_classes];
        }
        
        return [NSArray arrayWithArray:classes];
    }
    
    else
    {
        return NULL;
    }
}

-(NSArray *)categories
{
    if (self.arch == CPU_TYPE_I386)
    {
        NSArray *modules = [ObjcModule modulesInMachO:self];
        NSArray *symtabs = [ObjcSymtab symtabsFromModuleList:modules inMachO:self];
        
        NSMutableArray *categories = [NSMutableArray array];
        
        for (ObjcSymtab *symtab in symtabs)
        {
            NSArray *temp_cats = [ObjcCategory categoriesInMachO:self withSymtab:symtab];
            [categories addObjectsFromArray:temp_cats];
        }
        
        return [NSArray arrayWithArray:categories];
    }
    else if (self.arch == CPU_TYPE_X86_64)
    {
        Section64 *cat_list = [self section64:@"__objc_catlist" inSegment:@"__DATA"];
        
        NSMutableArray *cats = [NSMutableArray array];
        
        for (int i = 0; i < cat_list.size; i += 8)
        {
            unsigned long pointer = [self.data littleEndianIntDataInRange:
                                     NSMakeRange([self convertVirtualOffset:cat_list.address] + i, 8)];
            ObjcCategory *category = [ObjcCategory objc2CategoryInMachO:self atVirtualOffset:pointer];
            [cats addObject:category];
        }
        
        return [NSArray arrayWithArray:cats];
        
    }
    else
    {
        return NULL;
    }
}

@end
