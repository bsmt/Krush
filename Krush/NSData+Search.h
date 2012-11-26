//
//  NSData+Search.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>


/// An NSData category that allows searching that's more advanced than the methods provided by Foundation.

@interface NSData (Search)

/** Looks for the specified search data and returns the ranges of all occurances it finds.
 
 Returns NULL if no occurances were found.
 
 @param search The data to search for.
 @param option NSDataSearchOptions that can be ORed together.
 @param range The range within the target data to search in.
 @return An array of NSValue objects that contain an NSRange of an occurance of the search data.
 */
-(NSArray *)rangesOfData:(NSData *)search options:(NSDataSearchOptions)option range:(NSRange)searchRange;

@end
