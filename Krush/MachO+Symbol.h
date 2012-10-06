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
#import "NSData+Util.h"

@interface MachO (Symbol)

-(unsigned long)virtualOffsetForSymbol:(NSString *)sym;
-(unsigned long)realOffsetForSymbol:(NSString *)sym;

-(NSDictionary *)findAllSymbols;
-(NSArray *)classes;
-(NSArray *)categories;

@end
