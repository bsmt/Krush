//
//  NSData+Conversion.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>

@interface NSData (Conversion)

-(unsigned long)toInt;

-(NSString *)hexadecimalString;

// Convert the NSData to an ASCII NSString.
-(NSString *)toString;

// Same thing as toString basically, just lets you be more explicit.
-(NSString *)toStringWithLength:(int)len;

// Convert the NSData to a char string.
-(char *)toChar;

// Null terminates the end of the string for you (sort of).
-(char *)toCharWithLength:(int)len;

// Equivalent of [[self subDataWithRange:range] toInt];
-(unsigned long)intDataInRange:(NSRange)range;

// Same as intDataInRange but swaps endian.
-(unsigned long)littleEndianIntDataInRange:(NSRange)range;

// Equivalent of [[self subDataWithRange:range] toString];
-(NSString *)stringDataInRange:(NSRange)range;

// Swaps the endian of the data.
-(NSData *)swapEndian;

// Returns the data it finds before a null byte starting at off.
-(NSData *)readTillNullAtOffset:(unsigned long)off;

@end
