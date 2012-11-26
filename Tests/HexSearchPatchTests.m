//
//  HexSearchPatchTests.m
//
//  Created by ████
//

#import "HexSearchPatchTests.h"

@implementation HexSearchPatchTests

-(void)setUp
{
    NSError *error = NULL;
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"test2" ofType:@""] toPath:@"/tmp/test2" error:&error];
    
    Binary *bin = [[Binary alloc] initWithBinaryAtPath:@"/tmp/test2"];
    self.patcher = [Patcher patcherWithBinary:bin];
}

-(void)tearDown
{
    NSError *error = NULL;
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:@"/tmp/test2" error:&error];
}

-(void)testInvalidSearch
{
    NSData *search = [@"FUCKFUCKFUCKFUCKFUCKFUCK" dataUsingEncoding:NSASCIIStringEncoding];
    NSData *replace = [@"SHITSHITSHITSHITSHITSHIT" dataUsingEncoding:NSASCIIStringEncoding];
    
    BOOL result = [self.patcher replaceData:search with:replace];
    GHAssertFalse(result, @"Invalid search was claimed as successful.");
}

-(void)testRet1
{
    NSData *search = [NSData dataWithBytes:"\x55\x48\x89\xe5\x48\x8d\x3d\x4d\x03\x00\x00\x48\xbe\x07\x06\x05\x04\x03\x02\x01\x00" length:21];
    NSData *replace = [NSData dataWithBytes:"\x48\x31\xc0\x48\xff\xc0\xc3\x4d\x03\x00\x00\x48\xbe\x07\x06\x05\x04\x03\x02\x01\x00" length:21];
    
    BOOL result = [self.patcher replaceData:search with:replace];
    GHAssertTrue(result, @"Ret1 hex search failed.");
    
    NSData *original = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test2" ofType:@""]];
    NSData *patched = [NSData dataWithContentsOfFile:@"/tmp/test2"];
    
    GHAssertEqualStrings([original MD5HexDigest], @"6db314ee2537dba69a5703f461771cc0", @"Original binary's md5 is invalid.");
    GHAssertEqualStrings([patched MD5HexDigest], @"72d0713f4bec8e45876bd939388c6b88", @"Patched binary's md5 is invalid.");
}

-(void)testMultipleOccurances
{
    NSData *search = [NSData dataWithBytes:"\x07\x06\x05\x04\x03\x02\x01\x00" length:8];
    NSData *replace = [NSData dataWithBytes:"\x00\x01\x02\x03\x04\x05\x06\x07" length:8];
    
    BOOL result = [self.patcher replaceData:search with:replace];
    GHAssertTrue(result, @"Multiple occurance search failed.");
    
    NSData *original = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test2" ofType:@""]];
    NSData *patched = [NSData dataWithContentsOfFile:@"/tmp/test2"];
    
    GHAssertEqualStrings([original MD5HexDigest], @"6db314ee2537dba69a5703f461771cc0", @"Original binary's md5 is invalid.");
    GHAssertEqualStrings([patched MD5HexDigest], @"d313a28bd564c94a1450b23e2eb585df", @"Patched binary's md5 is invalid.");
}

-(void)testReplaceString
{
    BOOL result = [self.patcher replaceString:@"NOO" with:@"YAY"];
    GHAssertTrue(result, @"First patch returned false.");
    result = [self.patcher replaceString:@"Earth" with:@"World"];
    GHAssertTrue(result, @"Second patch returned false.");
    
    NSData *original = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test2" ofType:@""]];
    NSData *patched = [NSData dataWithContentsOfFile:@"/tmp/test2"];
    
    GHAssertEqualStrings([original MD5HexDigest], @"6db314ee2537dba69a5703f461771cc0", @"Original binary's md5 is invalid.");
    GHAssertEqualStrings([patched MD5HexDigest], @"14d7c594371b238721b6b1de8646573d", @"Patched binary's md5 is invalid.");
}

@end
