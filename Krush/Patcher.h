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
#import "NSData+Split.h"
#import "NSData+Search.h"

/** Patches Binary objects and other types of files. */

@interface Patcher : NSObject

/// The Binary object that will be patched.
@property Binary *binary;

/// The file that will be modified.
@property NSURL *target;


/// @name Initialization

/** Create a new Patcher object targetting the specified Binary.
 
 @param bin The target Binary.
 @return A patcher object ready to modify the Binary.
 */
+(Patcher *)patcherWithBinary:(Binary *)bin;

/** Create a new Patcher object targetting the specified file.
 
 @param path The path to the target file.
 @return A patcher object ready to modify the file.
 */
+(Patcher *)patcherWithFile:(NSURL *)path;


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

/** Replace all occurances of the given string.
 
 Same thing as converting a string to NSData and using replaceData:with:
 
 @param search The string to search for.
 @param replace The string that will take its place.
 @return The patch status. TRUE = success, FALSE = failure.
 */
-(BOOL)replaceString:(NSString *)search with:(NSString *)replace;

/** Insert an LC_LOAD_DYLIB command into the MachO headers in the binary.
 
 @param dylibName Name of the dylib with the extension. This assumes the dylib is in @executable_path (MacOS) with the main binary.
 @return The patch status.
 */
-(BOOL)insertLoadDylibCommand:(NSString *)dylibName;

@end
