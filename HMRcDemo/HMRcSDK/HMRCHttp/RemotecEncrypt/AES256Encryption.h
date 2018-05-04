//
//  AES256Encryption.h
//  testing
//
//  Created by Jackson Ng on 3/4/16.
//  Copyright © 2016 Jackson Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface AES256Encryption : NSData

+ (NSData *)AES256EncryptWithKey:(NSString *)key data:(NSData*)data iv:(Byte *)iv encryptOrDecrypt:(CCOperation)encryptOrDecrypt;
+ (NSString *) getKey;
+ (NSString *) md5:(NSString *) input;
+ (NSData *)generateSalt256;

@end
