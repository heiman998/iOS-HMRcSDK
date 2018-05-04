//
//  HmUtils.h
//  HmMqttSdk
//
//  Created by mac on 2017/11/29.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HmUtils : NSObject



+ (NSString *) convertToJsonData:(NSDictionary *)dict;
+ (NSString *) hexStringFromData:(NSData*)data;
- (unsigned) parseIntFromData:(NSData *)data;

+ (BOOL) validPhone:(NSString*)phone;
+ (BOOL) isValidateEmail:(NSString *)email;
+ (BOOL) isEmptyString:(NSString *)string;
+ (BOOL) isEmptyArray:(NSArray *)array;

@end
