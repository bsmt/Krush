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

/** Patches Binary objects and other types of files. */

@interface Patcher : NSObject

/// The Binary that will be patched.
@property Binary *binary;


/// @name Initialization

/** Create a new Patcher object targetting the specified Binary.
 
 @param bin The target Binary.
 @return A patcher object ready to modify the Binary.
 */
+(Patcher *)patcherWithBinary:(Binary *)bin;


/// @name Patching

/** Patch a symbol with a return statement in the Binary's MachOs.
 
 @param symbolName The symbol to patch. For example you may want to patch a function called -[Object canDoStuff].
 @return The patch status. TRUE = success, FALSE = failure.
 */
-(BOOL)patchSymbol:(NSString *)symbolName withReturnValue:(unsigned int)ret;

/** Replace all occurances of the given search data.
 
 @param search The data to search for.
 @param replace The data that will replace it.
 @return The patch status. TRUE = success, FALSE = failure.
 */
-(BOOL)replaceData:(NSData *)search with:(NSData *)replace;

/** Replace all occurances of the given search data with support for wildcards while searching.
 
 @param search The data to search for. To specify a wildcard, use the byte 0x2a (ASCII encoded *).
 @param replace The data that will replace any matches.
 @return The patch status. TRUE = success, FALSE = failure.
 */
-(BOOL)replaceData:(NSData *)search with:(NSData *)replace useWildcards:(BOOL)wildcard;

@end
