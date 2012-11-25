//
//  NSData+Digest.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>


/// An NSData category that hashes the data with MD5.

@interface NSData (Digest)

/** Hashes the NSData as MD5.
 
 MD5 utilities were taken from https://github.com/siuying/NSData-MD5
 @return The md5sum of the data.
 */
-(NSData *)MD5Digest;

/** Hex representation of the NSData's md5sum.
 
 @return The md5sum of the data in a hex string.
 */
-(NSString *)MD5HexDigest;

@end
