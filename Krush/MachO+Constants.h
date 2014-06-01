//
//  MachO+Constants.h
//  Krush
//
//  Created by Max Bazaliy on 6/2/14.
//
//

#ifndef Krush_MachO_Constants_h
#define Krush_MachO_Constants_h

#ifndef CPU_TYPE_ARM64
# define CPU_TYPE_ARM64 (CPU_TYPE_ARM | CPU_ARCH_ABI64)
#endif

#ifndef CPU_TYPE_ARM
#define CPU_TYPE_ARM ((cpu_type_t) 12)
#endif


#endif
