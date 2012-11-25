//
//  NSData+Reading.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>


/// An NSData category that allows reading parts of the data buffer.

@interface NSData (Reading)

/** Returns the data terminated by a NULL byte starting at off.
 
 @param off Offset to read from.
 @return The data found starting at off that ends with a NULL.
 */
-(NSData *)readTillNullAtOffset:(unsigned long)off;

/** Convert the data in the specified range to an NSString encoded in ASCII.
 
 Equivalent of [[data subDataWithRange:range] toString];
 @param range The range to read the string from.
 @return The NSData in range encoded as an ASCII NSString.
 */
-(NSString *)stringDataInRange:(NSRange)range;

/** Convert the data in the specified range to an unsigned long
 
 Equivalent of [[data subDataWithRange:range] toInt];
 Note: Limited to 8 bytes or less because it returns as an unsigned long.
 @param range The range to convert the data from.
 @return The data converted to an unsigned long. <00001000> becomes 0x000010000.
 @see littleEndianIntDataInRange:
 */
-(unsigned long)intDataInRange:(NSRange)range;

/** Same as intDataInRange but swaps the endian.
 
 @param range The range to convert the data from.
 @return The data converted to an unsigned long with the endian switch. <00001000> becomes 0x00100000.
 @see intDataInRange:
 */
-(unsigned long)littleEndianIntDataInRange:(NSRange)range;

@end
