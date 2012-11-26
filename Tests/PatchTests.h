//
//  PatchTests.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>
#import <GHUnit/GHUnit.h>
#import <Krush/Binary.h>
#import <Krush/Patcher.h>
#import "NSData+Digest.h" // I guess we can't get this from Krush?

@interface PatchTests : GHTestCase

@property Patcher *patcher;

@end
