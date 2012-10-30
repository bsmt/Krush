//
//  PatchTests.m
//
//  Created by ████
//

#import "PatchTests.h"

@implementation PatchTests

-(void)setUp
{
    // copy test binary to /tmp
    NSError *error = NULL;
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"test1" ofType:@""] toPath:@"/tmp/test1" error:&error];
    
    Binary *bin = [[Binary alloc] initWithBinaryAtPath:@"/tmp/test1"];
    //Binary *bin = [[Binary alloc] initWithBinaryAtPath:[[NSBundle mainBundle] pathForResource:@"test1" ofType:@""]];
    self.patcher = [Patcher patcherWithBinary:bin];
}

-(void)tearDown
{
    NSError *error = NULL;
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:@"/tmp/test1" error:&error];
}

-(void)testSymbolPatch
{
    // original md5: b695e44a3dc25f4bf22cfadc3b7014a2
    // patched md5: cea94a2bf13b9d5a7b0f690cc62e41b4
    
    GHAssertTrue([self.patcher patchSymbol:@"_fuck" withReturnValue:0], @"Patching fuck() failed.");
    GHAssertTrue([self.patcher patchSymbol:@"_derp" withReturnValue:1], @"Patching derp() failed.");
    GHAssertTrue([self.patcher patchSymbol:@"+[AClass anClass]" withReturnValue:0], @"Patching +[Aclass anClass] failed.");

    NSData *original = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test1" ofType:@""]];
    NSData *patched = [NSData dataWithContentsOfFile:@"/tmp/test1"];
    
    GHAssertEqualStrings([original MD5HexDigest], @"b695e44a3dc25f4bf22cfadc3b7014a2", @"Unpatched binary's md5 doesn't match.");
    GHAssertEqualStrings([patched MD5HexDigest], @"cea94a2bf13b9d5a7b0f690cc62e41b4", @"Patched binary's md5 doesn't match.");
}

@end
