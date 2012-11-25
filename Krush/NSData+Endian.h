//
//  NSData+Endian.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>


/// An NSData category that allows swapping of the data's endian.

@interface NSData (Endian)

/** Swaps the endian of the data.
 
 @return The source data with the endian swapped. <00000001> is returned as <01000000>.
 */
-(NSData *)swapEndian;

@end
