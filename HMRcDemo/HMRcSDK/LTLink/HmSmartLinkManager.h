//
//  HmSmartLinkManager.h
//  CustomProject
//
//  Created by haimen_ios_imac on 2018/2/8.
//  Copyright © 2018年 深圳海曼科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HmNetInBlock)(BOOL success, id responseObj);

/**  ====== WIFI入网设备类型 ======
 
 * DEVICE_TYPE_WIFI_HS1GW: HEIMAN(海曼) 小网关 
 * DEVICE_TYPE_WIFI_METERING_PLUGIN: HEIMAN(海曼) WIFI计量插座
 * DEVICE_TYPE_WIFI_AIR: HEIMAN(海曼) WIFI空气质量
 * DEVICE_TYPE_WIFI_GAS: HEIMAN(海曼) WIFI气感报警器
 * DEVICE_TYPE_INFRA_RED: HEIMAN(海曼) WIFI红外遥控器
 
 */
typedef enum: NSInteger {
    
    HM_DEVICE_TYPE_WIFI_HS1GW,
    HM_DEVICE_TYPE_WIFI_METERING_PLUGIN,
    HM_DEVICE_TYPE_WIFI_AIR,
    HM_DEVICE_TYPE_WIFI_GAS,
    HM_DEVICE_TYPE_WIFI_INFRA_RED
    
} HM_DEVICE_TYPE;

/**  ====== 错误类型 ======
 
 * WIFI_DISCONNECT_CODE: 未连接WIFI
 
 */

#define NETIN_SUCCESS_CODE       0
#define PASSWORD_ERROR_CODE     -1
#define WIFI_DISCONNECT_CODE    -2
#define NETIN_OUTTIME_CODE      -3

@interface HmSmartLinkManager : NSObject

/**
 超时时间，默认为120.0s
 */
@property (nonatomic, assign) NSTimeInterval outTimerInterval;


/**
 单例
 */
+ (instancetype)sharedManager;

/**
 开始WIFI配网操作

 @param devType 设备类型
 @param wifiPass wifi密码
 @param resultBlock 结果回调
 @param outBlock 超时回调
 */
- (void)startWifiNetInWithDevType:(HM_DEVICE_TYPE)devType
                     wifiPassword:(NSString *)wifiPass
                   resultResponse:(HmNetInBlock)resultBlock
                      outResponse:(HmNetInBlock)outBlock;
/**
 停止WIFI配网操作

 @param responseBlock 停止回调
 */
- (void)stopWifiNetInResponse:(void(^)(BOOL success))responseBlock;

@end
