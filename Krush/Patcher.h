//
//  Patcher.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>

#import "Binary.h"
#import "MachO.h"
#import "MachO+Symbol.h"
#import "Assembler.h"

@interface Patcher : NSObject

@property Binary *binary;

+(Patcher *)patcherWithBinary:(Binary *)bin;

-(void)patchSymbol:(NSString *)symbolName withReturnValue:(unsigned int)ret;
-(void)replaceData:(NSData *)search with:(NSData *)replace;
-(void)replaceData:(NSData *)search with:(NSData *)replace useWildcards:(BOOL)wildcard;

@end
