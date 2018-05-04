//
//  AES256Encryption.m
//  referenceCode
//
//  Created by Jackson Ng on 4/18/16.
//  Copyright © 2016 Jackson Ng. All rights reserved.
//

#import "AES256Encryption.h"
#import "GTMBase64.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation AES256Encryption

+ (NSData *)AES256EncryptWithKey:(NSString *)key data:(NSData*)data iv:(Byte *)iv encryptOrDecrypt:(CCOperation)encryptOrDecrypt {
    
    // 'key' should be 32 bytes, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        data = [GTMBase64 decodeData:data];
    }
    
    NSUInteger dataLength = [data length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(encryptOrDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          iv /* initialization vector (16 bytes) */,
                                          [data bytes], dataLength, /* input */
                                          buffer,       bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus != kCCSuccess){
        NSLog(@"ERROR WITH FILE ENCRYPTION / DECRYPTION");
        return nil;
    }
    
    NSData *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [NSData dataWithBytes:(const void *)buffer length:(NSInteger)numBytesDecrypted];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)buffer length:numBytesDecrypted];
        result = [GTMBase64 encodeData:myData];
    }
    
    free(buffer); //free the buffer;
    return result;
}

+ (NSString *) getKey{
    // prepare key
    NSString *prefix = @"HEIMAN___212___0_HM_";
    //[Server getUserDatawithkey:@"prefix"];
    
    NSDate *currentTime = [NSDate date];
    NSTimeInterval interval = [currentTime timeIntervalSince1970];// + (3600 * 8);
    NSString *subStrTime = [[NSString stringWithFormat:@"%f", interval] substringWithRange:NSMakeRange(0, 9)];
    
    NSString *keyB = [[self md5:subStrTime] substringWithRange:NSMakeRange(0, 12)];
    
    NSString *key = [NSString stringWithFormat:@"%@%@", prefix, keyB];
    
    //NSLog(@"key :%@", key);
    
    return key;
}

+ (NSString *) md5:(NSString *) input{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSData *)generateSalt256 {
    unsigned char salt[32];
    for (int i=0; i<32; i++) {
        salt[i] = (unsigned char)arc4random();
    }
    //NSLog(@"%s", salt);
    NSData * dataSalt = [NSData dataWithBytes:salt length:sizeof(salt)];
    return dataSalt;
}

@end
