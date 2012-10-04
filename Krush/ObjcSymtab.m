//
//  ObjcSymbols.m
//
//  Created by ████
//

#import "ObjcSymtab.h"

@implementation ObjcSymtab

+(ObjcSymtab *)symtabFromStruct:(struct objc_symtab)sym definitions:(NSArray *)defs
{
    ObjcSymtab *symtab = [[ObjcSymtab alloc] init];
    if (!symtab)
    {
        return NULL;
    }
    
    symtab.selector_ref_count = sym.selector_ref_count;
    symtab.references = sym.refs;
    symtab.class_def_count = sym.class_def_count;
    symtab.catagory_def_count = sym.catagory_def_count;
    symtab.definitions = defs;
    
    return symtab;
}

+(NSArray *)symtabsFromModuleList:(NSArray *)modules inMachO:(MachO *)mach
{
    NSMutableArray *sym_list = [NSMutableArray array];

    if (mach.arch != CPU_TYPE_I386)
    {
        return NULL;
    }

    for (ObjcModule *mod in modules)
    {
        if (mod.symtab == 0)
        {
            continue;
        }

        unsigned int symtab_location = [mach convertVirtualOffset:mod.symtab];  // all we care about
        struct objc_symtab *sym = (struct objc_symtab *)((char *)[[mach data] bytes] + symtab_location);
        NSMutableArray *defs = [NSMutableArray array];
        
        // read definitions
        if ((sym->class_def_count + sym->catagory_def_count) > 0)
        {
            unsigned int def_offset = symtab_location + sizeof(struct objc_symtab);
            int i = 0;
            while (i < (sym->class_def_count + sym->catagory_def_count))
            {
                if (def_offset >= [[mach data] length])
                {
                    break;
                }
                 
                unsigned int def = [[mach data] littleEndianIntDataInRange:NSMakeRange(def_offset, 4)];
                [defs addObject:[NSNumber numberWithInt:def]];
                i++;
                def_offset += 4;
            }
        }

        ObjcSymtab *symtab = [ObjcSymtab symtabFromStruct:*sym definitions:defs];
        [sym_list addObject:symtab];
    }

    return [NSArray arrayWithArray:sym_list];
}

@end
