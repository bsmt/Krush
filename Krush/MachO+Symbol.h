//
//  MachO+Symbol.h
//
//  Created by ████
//

#import "MachO.h"
#import "ObjcModule.h"
#import "ObjcSymtab.h"
#import "ObjcClass.h"
#import "ObjcCategory.h"
#import "NSData+Reading.h"

/** A category on the MachO class that adds support for finding symbols. */

@interface MachO (Symbol)


/// @name Symbol Searching

/** Find an individual symbol in the MachO.
 
 @param sym The symbol name. E.g. -[HerpClass derpMethod:]
 @return The virtual offset that the symbol points to.
 */
-(unsigned long)virtualOffsetForSymbol:(NSString *)sym;

/** Find an individual symbol in the MachO.
 
 @param sym The symbol name. E.g. -[DerpClass herpMethod:]
 @return The real file offset that the symbol points to.
 */
-(unsigned long)realOffsetForSymbol:(NSString *)sym;

/** Find all symbols in the MachO.
 
 @return A dictionary with every symbol found in the MachO. Key is the symbol name, value is the virtual offset.
 */
-(NSDictionary *)findAllSymbols;

/** Find all Objective-C classes in the MachO.
 
 @return An array with every class found in the MachO.
 */
-(NSArray *)classes;

/** Find all Objective-C categories in the MachO.
 
 @return An array with every category found in the MachO.
 */
-(NSArray *)categories;

@end
