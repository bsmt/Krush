//
//  NSData+Search.m
//
//  Created by ████
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
    
    searchRange.location = initial.location + initial.length;
    searchRange.length = [self length] - (initial.location + initial.length);
    while(true)
    {
        NSRange nextOccurance = [self rangeOfData:search options:option range:searchRange];
        if (nextOccurance.location != NSNotFound)
        {
            [ranges addObject:[NSValue value:&nextOccurance withObjCType:@encode(NSRange)]];
            searchRange.location = nextOccurance.location + nextOccurance.length;
            searchRange.length = [self length] - (nextOccurance.location + nextOccurance.length);
        }
        else
        {
            break;
        }
    }
    
    return [NSArray arrayWithArray:ranges];
}

@end
