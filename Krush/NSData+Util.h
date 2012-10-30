//
//  NSData+Conversion.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>

/** A set of methods that help with reading NSData from bianry files.
 
 Common operations are converting to strings, swapping endian, reading strings, and checksuming.
 */

@interface NSData (Conversion)


/// @name Integer conversion

/** Convert the binary data to a 64bit unsigned integer.
 
 @return The unsigned long form of the data. For instance, the NSData <00001000> would be converted to 0x1000.
 @see intDataInRange:
 */
-(unsigned long)toInt;


/// @name String conversion

/** Convert the NSData into an NSString representing the data.
 
 @return The data as an NSString. <01020304> returns as @"01020304".
 @see toString:
 @see toStringWithLength:
 @see toChar
 @see toCharWithLength:
 */
-(NSString *)hexadecimalString;

/** Convert the NSData to an NSString encoded in ASCII.
 
 @return The NSData encoded as an ASCII NSString.
 @see toStringWithLength:
 @see stringDataInRange:
 @see toChar
 @see toCharWithLength:
 */
 -(NSString *)toString;

/** Convert the NSData to an ASCII NSString while limiting the length.
 
 @param len The length of the string to read.
 @return The NSData encoded as an ASCII NSString.
 @see toString
 @see toChar
 @see toCharWithLength:
 */
-(NSString *)toStringWithLength:(int)len;

/** Convert the data in the specified range to an NSString encoded in ASCII.
 
 Equivalent of [[data subDataWithRange:range] toString];
 @param range The range to read the string from.
 @return The NSData in range encoded as an ASCII NSString.
 */
-(NSString *)stringDataInRange:(NSRange)range;

/** Convert the NSData to an ASCII char string.

 @return The ASCII encoded NSData in a char * buffer.
 @see toCharWithLength:
 */
 -(char *)toChar;

/** Convert the NSData to an ASCII char string while limiting the length.
 
 @param len The length of the string to read.
 @return The ASCII encoded NSData in a char * buffer.
 @see toChar
 */
-(char *)toCharWithLength:(int)len;


/// @name Integer conversion

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


/// @name Endian

/** Swaps the endian of the data.
 
 @return The source data with the endian swapped. <00000001> is returned as <01000000>.
 */
-(NSData *)swapEndian;


/// @name Reading

/** Returns the data terminated by a NULL byte starting at off.
 
 @param off Offset to read from.
 @return The data found starting at off that ends with a NULL.
 */
-(NSData *)readTillNullAtOffset:(unsigned long)off;

@end
