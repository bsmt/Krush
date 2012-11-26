//
//  NSData+Search.m
//  Krush
//
//  Created by bsmt on 11/25/12.
//
//

#import "NSData+Search.h"

@implementation NSData (Search)

-(NSArray *)rangesOfData:(NSData *)search options:(NSDataSearchOptions)option range:(NSRange)searchRange
{
    NSMutableArray *ranges = [NSMutableArray array];
    
    NSRange initial = [self rangeOfData:search options:option range:searchRange];
    if (initial.location == NSNotFound)
    {
        return NULL; // no occurances
    }
    
    [ranges addObject:[NSValue value:&initial withObjCType:@encode(NSRange)]];
    while(true)
    {
        NSRange nextOccurance = [self rangeOfData:search options:option range:searchRange];
        if (initial.location != NSNotFound)
        {
            [ranges addObject:[NSValue value:&nextOccurance withObjCType:@encode(NSRange)]];
        }
        else
        {
            break;
        }
    }
    
    return [NSArray arrayWithArray:ranges];
}

@end
