//
//  ObjcStructs.h
//
//  Created by ████
//

struct objc_module
{
    uint32_t version;
    uint32_t size;
    uint32_t name;
    uint32_t symtab;  
};

struct objc_symtab
{
    uint32_t selector_ref_count;
    uint32_t refs;
    uint16_t class_def_count;
    uint16_t catagory_def_count;
};

struct objc_class
{
    uint32_t isa;
    uint32_t super_class;
    uint32_t name;
    uint32_t version;
    uint32_t info;
    uint32_t instance_size;
    uint32_t ivars;
    uint32_t methods;
    uint32_t cache;
    uint32_t protocols;  
};

struct objc_catagory
{
    uint32_t category_name;
    uint32_t class_name;
    uint32_t methods;
    uint32_t class_methods;
    uint32_t protocols;  
};

struct objc_ivar_list
{
    uint32_t ivar_count;
    // followed by ivars
};

struct objc_ivar
{
    uint32_t name;
    uint32_t type;
    uint32_t offset;  
};

struct objc_method_list
{
    uint32_t _obsolete;
    uint32_t method_count;
    // followed by methods
};

struct objc_method
{
    uint32_t name;
    uint32_t types;
    uint32_t imp;  
};

struct objc_protocol_list
{
    uint32_t next;
    uint32_t count;
    //uint32_t list;  
};

struct objc_protocol
{
    uint32_t isa;
    uint32_t protocol_name;
    uint32_t protocol_list;
    uint32_t instance_methods;
    uint32_t class_methods;
};

struct objc_protocol_method_list
{
    uint32_t method_count;
    // Followed by methods
};

struct objc_protocol_method
{
    uint32_t name;
    uint32_t types;
};

struct objc64_class
{
    uint64_t isa;
    uint64_t superclass;
    uint64_t cache;
    uint64_t vtable;
    uint64_t data; // points to class_ro_t
    uint64_t reserved1;
    uint64_t reserved2;
    uint64_t reserved3;
};

struct objc64_class_ro_t
{
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;
    uint32_t reserved; // *** this field does not exist in the 32-bit version ***
    uint64_t ivarLayout;
    uint64_t name;
    uint64_t baseMethods;
    uint64_t baseProtocols;
    uint64_t ivars;
    uint64_t weakIvarLayout;
    uint64_t baseProperties;  
};

struct objc64_method
{
    uint64_t name;
    uint64_t types;
    uint64_t imp;  
};

struct objc64_ivar
{
    uint64_t offset;
    uint64_t name;
    uint64_t type;
    uint32_t alignment;
    uint32_t size;
};

struct objc64_property
{
    uint64_t name;
    uint64_t attributes;  
};

struct objc64_protocol
{
    uint64_t isa;
    uint64_t name;
    uint64_t protocols;
    uint64_t instanceMethods;
    uint64_t classMethods;
    uint64_t optionalInstanceMethods;
    uint64_t optionalClassMethods;
    uint64_t instanceProperties; // So far, always 0  
};

struct objc64_catagory
{
    uint64_t name;
    uint64_t class;
    uint64_t instanceMethods;
    uint64_t classMethods;
    uint64_t protocols;
    uint64_t instanceProperties;
    uint64_t v7;
    uint64_t v8;  
};