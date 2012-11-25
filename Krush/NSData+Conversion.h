//
//  NSData+Conversion.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>


/// An NSData category that helps with converting NSData objects to other types.

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

@end