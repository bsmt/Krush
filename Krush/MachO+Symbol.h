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

@interface MachO (Symbol)

-(unsigned int)virtualOffsetForSymbol:(NSString *)sym;
-(unsigned int)realOffsetForSymbol:(NSString *)sym;

-(NSDictionary *)findAllSymbols;
-(NSArray *)classes;
-(NSArray *)categories;

@end
