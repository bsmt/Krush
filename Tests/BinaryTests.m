//
//  BinaryTests.m
//
//  Created by ████
//

#import "BinaryTests.h"

@implementation BinaryTests

-(void)setUp
{
    // insert test binary here
    self.bin = [[Binary alloc] initWithBinaryAtPath:[[NSBundle mainBundle] pathForResource:@"test1" ofType:@""]];
}

-(void)testSymbolOffsets
{
    for (MachO *mach in self.bin.machs)
    {
        if (mach.arch == CPU_TYPE_I386) // 32 bit
        {
            NSDictionary *symbols = [mach findAllSymbols];

            // class method
            unsigned long anClass = [symbols[@"+[AClass anClass]"] unsignedLongValue];
            unsigned long anClass_offset = 0x00001e4a;
            // category class method
            unsigned long coolestString = [symbols[@"+[NSString (test) coolestString]"] unsignedLongValue];
            unsigned long coolestString_offset = 0x00001ea7;
            // category instance method
            unsigned long stuff = [symbols[@"-[NSString (test) stuff]"] unsignedLongValue];
            unsigned long stuff_offset = 0x00001eb8;
            // instance method
            unsigned long doStuff = [symbols[@"-[AClass doStuff]"] unsignedLongValue];
            unsigned long doStuff_offset = 0x00001e87;
            // instance method
            unsigned long moreStuff = [symbols[@"-[AClass moreStuffWithArguments:]"] unsignedLongValue];
            unsigned long moreStuff_offset = 0x00001e96;
            // instance method
            unsigned long what = [symbols[@"-[AClass what]"] unsignedLongValue];
            unsigned long what_offset = 0x00001e8c;
            // c function
            unsigned long _fuck = [symbols[@"_fuck"] unsignedLongValue];
            unsigned long _fuck_offset = 0x00001dda;
            // c function
            unsigned long _derp = [symbols[@"_derp"] unsignedLongValue];
            unsigned long _derp_offset = 0x00001ddf;
            
            // assertions
            GHAssertEquals(anClass, anClass_offset, @"+[AClass anClass] offset is incorrect.");
            GHAssertEquals(coolestString, coolestString_offset, @"+[NSString (test) coolestString] offset is incorrect.");
            GHAssertEquals(stuff, stuff_offset, @"-[NSString (test) stuff] offset is incorrect.");
            GHAssertEquals(doStuff, doStuff_offset, @"-[AClass doStuff] offset is incorrect.");
            GHAssertEquals(moreStuff, moreStuff_offset, @"-[AClass moreStuffWithArguments:] offset is incorrect.");
            GHAssertEquals(what, what_offset, @"-[AClass what] offset is incorrect.");
            GHAssertEquals(_fuck, _fuck_offset, @"fuck() offset is incorrect");
            GHAssertEquals(_derp, _derp_offset, @"derp() offset is incorrect");
        }
        else if (mach.arch == CPU_TYPE_X86_64)
        {
            NSDictionary *symbols = [mach findAllSymbols];
            
            // class method
            unsigned long anClass = [symbols[@"+[AClass anClass]"] unsignedLongValue];
            unsigned long anClass_offset = 0x0000000100001bb6;
            // category class method
            unsigned long coolestString = [symbols[@"+[NSObject (test) coolestString]"] unsignedLongValue];
            unsigned long coolestString_offset = 0x0000000100001bfd;
            // category instance method
            unsigned long stuff = [symbols[@"-[NSObject (test) stuff]"] unsignedLongValue];
            unsigned long stuff_offset = 0x0000000100001c0a;
            // instance method
            unsigned long doStuff = [symbols[@"-[AClass doStuff]"] unsignedLongValue];
            unsigned long doStuff_offset = 0x0000000100001bdf;
            // instance method
            unsigned long moreStuff = [symbols[@"-[AClass moreStuffWithArguments:]"] unsignedLongValue];
            unsigned long moreStuff_offset = 0x0000000100001bf0;
            // instance method
            unsigned long what = [symbols[@"-[AClass what]"] unsignedLongValue];
            unsigned long what_offset = 0x0000000100001be5;
            // c function
            unsigned long _fuck = [symbols[@"_fuck"] unsignedLongValue];
            unsigned long _fuck_offset = 0x0000000100001b54;
            // c function
            unsigned long _derp = [symbols[@"_derp"] unsignedLongValue];
            unsigned long _derp_offset = 0x0000000100001b5a;
            
            // assertions
            GHAssertEquals(anClass, anClass_offset, @"+[AClass anClass] offset is incorrect.");
            GHAssertEquals(coolestString, coolestString_offset, @"+[NSString (test) coolestString] offset is incorrect.");
            GHAssertEquals(stuff, stuff_offset, @"-[NSString (test) stuff] offset is incorrect.");
            GHAssertEquals(doStuff, doStuff_offset, @"-[AClass doStuff] offset is incorrect.");
            GHAssertEquals(moreStuff, moreStuff_offset, @"-[AClass moreStuffWithArguments:] offset is incorrect.");
            GHAssertEquals(what, what_offset, @"-[AClass what] offset is incorrect.");
            GHAssertEquals(_fuck, _fuck_offset, @"fuck() offset is incorrect");
            GHAssertEquals(_derp, _derp_offset, @"derp() offset is incorrect");
        }
    }
}

-(void)testListObjects
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
