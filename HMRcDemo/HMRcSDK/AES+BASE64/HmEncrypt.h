//
//  HmEncrypt.h
//  CTest
//
//  Created by haimen_ios_imac on 2017/5/18.
//  Copyright © 2017年 深圳海曼科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HmEncrypt : NSObject

/**
 获取得特定key值

 @param lpKey 待转换的key unsigned char 型
 @return unsigned char 结果
 */
+ (unsigned char *)getKey:(unsigned char *)lpKey;

/**
 aes加密方法

 @param data 待加密数据
 @param key key，
 @return 完成加密数据
 */
+ (NSData *)aesEncrypt:(NSData *)data key:(NSData *)key;

/**
 aes解密方法

 @param data 待解密数据
 @param key key
 @return 完成解密数据
 */
+ (NSData *)aesDecrypt:(NSData *)data key:(NSData *)key;


/**
 海曼解密数据方法

 @param key 秘钥键
 @param payData 接受到的加密数据
 @return id类型
 */
+ (NSDictionary *)hmDecryptWithPrivateKey:(NSString *)key
                      payData:(NSData *)payData;


/**
 海曼加密数据方法

 @param key 密钥
 @param jsonDict 接受到的加密数据
 @return 字符串
 */
+ (NSString *)hmEncrypt:(NSString *)key
       jsonData:(NSDictionary *)jsonDict;


@end
