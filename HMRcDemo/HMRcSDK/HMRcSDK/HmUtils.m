//
//  HmUtils.m
//  HmMqttSdk
//
//  Created by mac on 2017/11/29.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HmUtils.h"

@implementation HmUtils

// 验证手机号和密码是否符合规则
+ (BOOL) validPhone:(NSString*)phone {
    NSString *regex = @"^[1][234578][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:phone];
}

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断字符串是否无效
+(BOOL)isEmptyString:(NSString *)string{
    if (string == nil || string.length == 0) {
        return YES;
    }else{
        return NO;
    }
}
//判断数组是否为空
+(BOOL)isEmptyArray:(NSArray *)array{
    
    if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0){
        return NO;
    }else{
        return YES;
    }
}

//data   ： <845dd768 14c6>    怎么转成这样的    字符串：845DD76814C6
+ (NSString *) hexStringFromData:(NSData*)data{
    return [[[[NSString stringWithFormat:@"%@",data]
              stringByReplacingOccurrencesOfString: @"<" withString: @""]
             stringByReplacingOccurrencesOfString: @">" withString: @""]
            stringByReplacingOccurrencesOfString: @" " withString: @""];
}

//NSString转NSData
+ (NSData *) hexToBytes:(NSString *)str
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

//int转NSData
- (NSData *) setId:(int)Id
{
    //用4个字节接收
    Byte bytes[4];
    bytes[0] = (Byte)(Id>>24);
    bytes[1] = (Byte)(Id>>16);
    bytes[2] = (Byte)(Id>>8);
    bytes[3] = (Byte)(Id);
    NSData *data = [NSData dataWithBytes:bytes length:4];
    return data;
}
- (NSData *) set2Id:(int)Id
{
    //用2个字节接收
    Byte bytes[2];
    bytes[0] = (Byte)(Id>>8);
    bytes[1] = (Byte)(Id);
    NSData *data = [NSData dataWithBytes:bytes length:2];
    return data;
}

////4字节表示的int
//NSData *intData = [data subdataWithRange:NSMakeRange(2, 4)];
//int value = CFSwapInt32BigToHost(*(int*)([intData bytes]));//655650
////2字节表示的int
//NSData *intData = [data subdataWithRange:NSMakeRange(4, 2)];
//int value = CFSwapInt16BigToHost(*(int*)([intData bytes]));//290
////1字节表示的int
//char *bs = (unsigned char *)[[data subdataWithRange:NSMakeRange(5, 1) ] bytes];
//int value = *bs;//34

//没有三个字节转int的方法，这里补充一个通用方法
- (unsigned)parseIntFromData:(NSData *)data
{
    
    NSString *dataDescription = [data description];
    NSString *dataAsString = [dataDescription substringWithRange:NSMakeRange(1, [dataDescription length]-2)];
    
    unsigned intData = 0;
    NSScanner *scanner = [NSScanner scannerWithString:dataAsString];
    [scanner scanHexInt:&intData];
    return intData;
}

// 字典转json字符串方法

+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}


@end
