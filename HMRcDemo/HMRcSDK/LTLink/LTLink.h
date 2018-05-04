//
//  LTLink2.h
//  LTLink2
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 longsys. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(int, ERROR_CODE)
{
    ERROR_NIL = 1,      //空指针
    ERROR_RUNNING = 2,  //重复运行
    ERROR_LENGTH = 3,   //ssid或密码长度错误
    ERROR_IP = 4,       //IP地址获取不到
    ERROR_SOCKET = 5,   //通信端口被占用或打开失败。
    ERROR_DATA = 6,     //数据出错
};

@interface LTLink : NSObject
- (void) startGuidance;
- (void) startLinkWithSSID:(NSString*)ssid password:(NSString*)password secureKey:(NSString *)secureKey;
- (void) stopLink;
- (int) getErrorCode;
- (NSString*)getVersion;
@end
