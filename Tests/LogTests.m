//
//  LogTests.m
//
//  Created by ████
//

#import "LogTests.h"

@implementation LogTests

-(void)setUp
{
    // insert test binary here
    self.bin = [[Binary alloc] initWithBinaryAtPath:@""];
}

-(void)testListMachOs
{
    for (MachO *mach in self.bin.machs)
    {
        GHTestLog(@"%@\n", mach);
    }
}

-(void)testList32bitSymbols
{
    for (MachO *mach in self.bin.machs)
    {
        if (mach.arch == CPU_TYPE_I386)
        {
            GHTestLog(@"%@", [mach findAllSymbols]);
        }
    }
}

-(void)testList64BitSymbols
{
    for (MachO *mach in self.bin.machs)
    {
        if (mach.arch == CPU_TYPE_X86_64)
        {
            GHTestLog(@"%@", [mach findAllSymbols]);
        }
    }
}

@end
