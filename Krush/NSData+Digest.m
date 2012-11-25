//
//  NSData+Digest.m
//
//  Created by ████
//

#import "NSData+Digest.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (Digest)

-(NSData *)MD5Digest
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(self.bytes, (unsigned int)self.length, result);
    return [[NSData alloc] initWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

-(NSString *)MD5HexDigest
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(self.bytes, (unsigned int)self.length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    return ret;
}

@end
