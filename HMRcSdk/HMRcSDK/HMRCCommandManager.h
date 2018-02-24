//
//  HMRCCommandManager.h
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/2/1.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMRCTimer.h"
#import "HMRcModel.h"
#import "HMRcCommandsModel.h"
/**
 发送设置转码回调信息

 @param successInfo  返回成功的数据
 @param sn           ack码
 @param errorCode    失败回调码
 */
typedef void(^RcCallBack)(id successInfo, NSInteger sn ,NSInteger errorCode);

@interface HMRCCommandManager : NSObject

/**
 单例
 */
+ (instancetype)sharedManager;


#pragma mark ---------设备的发送指令--------

/**
 获取密钥
 
 @param callBack 信息回调
 */
- (void)getRcAeckeyWithCallBack:(RcCallBack)callBack;

/**
 获取设备的基本信息

 @param rcModel  需要模型对象中的密钥
 @param callBack 信息回调
 */
- (void)getDeviceInfoWithHmRcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack;


/**
 设置时区
 
 @param timeZone 时区
 @param rcModel  需要模型对象中的密钥
 @param callBack 信息回调
 */
- (void)setRcTimeZone:(NSString *)timeZone RcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack;

/**
 获取红外设备名字
 
 @param rcModel  需要模型对象中的密钥
 @param callBack 信息回调
 */
- (void)getRcDeviceNameWithRcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack;


/**
 设置红外设备名字

 @param deviceName 红外设备的名字
 @param rcModel    需要模型对象中的密钥
 @param callBack   信息回调
 */
- (void)setRcDeviceName:(NSString *)deviceName  hmRcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack;

/**
 固件升级

 @param deviceType 固件类型
 @param rcModel    需要模型对象中的密钥
 @param callBack   信息回调
 */
- (void)updateRcFirmware:(NSInteger )deviceType RcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack;

/**
 红外学习功能

 @param rcModel   需要模型对象中的密钥
 @param OD        虚拟设备id
 @param callBack  信息回调
 */
- (void)statLearnRcActionWithRcModel:(HMRcModel *)rcModel odId:(NSString *)OD callBack:(RcCallBack)callBack;

/**
 获取定时时间指令
 
 @param rcModel 密钥
 @param OD 虚拟设备id
 @param callBack 回调信息
 */
- (void)getRcTimerWithRcModel:(HMRcModel *)rcModel odId:(NSString *)OD callBack:(RcCallBack)callBack;


/**
 app设置定时时间指令
 
 @param rcModel 密钥
 @param OD 虚拟设备id
 @param rcTimer 定时器对象
 @param callBack 信息回调
 */
- (void)setRcTimerWithRcModel:(HMRcModel *)rcModel odId:(NSString *)OD hmRcTimer:(HMRCTimer *)rcTimer callBack:(RcCallBack)callBack;


/**
 虚拟设备发送红外码库
 
 @param rcModel  密钥
 @param sModel    红外码值HMSendCodeModel模型
 @param callBack 回调消息码
 */
- (void)setFictitiousDeviceRcCodeWitHmRcModel:(HMRcModel *)rcModel
                              HmSendCodeModel:(HMSendCodeModel *)sModel
                                     callBack:(RcCallBack)callBack;


/**
 获取红外温度
 
 @param rcModel  密钥
 @param callBack 消息回调
 */
- (void)getRcTemperatureWithRcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack;


/**
 获取温度报警阈值
 
 @param rcModel  密钥
 @param callBack 消息回调
 */
- (void)getRcTemperatureLimitValueWithRcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack;


/**
 设置温度报警阈值
 
 @param rcModel  密钥
 @param tpAlarm  温度报警阈值
 @param callBack 信息回调
 */
- (void)setRcTemperatureLimitValueWithRcModel:(HMRcModel *)rcModel
                             HmTempAlarmModel:(HMTempAlarmModel *)tpAlarm
                                     callBack:(RcCallBack)callBack;

/**
 创建本地码库
 
 @param rcModel       密钥
 @param localCodeList 红外码值列表
 @param callBack      回复信息
 */
- (void)createLocalCodeWithRcModel:(HMRcModel *)rcModel
                        localCodes:(NSArray <HMSendCodeModel *> *)localCodeList
                          callBack:(RcCallBack)callBack;

/**
 删除本地码库
 
 @param rcModel  密钥
 @param od       虚拟设备id
 @param callBack 回复信息
 */
- (void)deleteLocalCodeWithRcModel:(HMRcModel *)rcModel
                                OD:(NSString *)od
                          callBack:(RcCallBack)callBack;

#pragma mark ----------设备回复/主动上报的信息
/**
 设备回复或主动上报的信息
 
 @param rcModel 密钥
 @param data 回复或上报的数据信息
 @param callBack 回调的信息
 */
- (void)baseReplyWithRcModel:(HMRcModel *)rcModel backData:(NSData *)data callBack:(RcCallBack)callBack;


@end
