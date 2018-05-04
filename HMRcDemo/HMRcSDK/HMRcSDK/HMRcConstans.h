//
//  HMRcConstans.h
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/1/30.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRcConstans : NSObject

#pragma mark--------- 红外遥控转发器协议OID分配

extern NSString *const GW_OID_BASEINFO_KEY ;           //获取基本信息
extern NSString *const GW_OID_AESKEY ;                 //获取秘钥     注：公钥加密私钥
extern NSString *const GW_OID_TIMEZONE_KEY ;           //设置/获取时区
extern NSString *const GW_OID_SETANDGET_DEVICENAME;    //获取/设置设备名称
extern NSString *const GW_OID_OTA_UPDATE ;           //固件升级
extern NSString *const GW_OID_LEARN ;                  //红外学习功能
extern NSString *const GW_OID_VIRTUAL_DEVICE_SENDRC ;  //虚拟设备发送红外码
extern NSString *const GW_OID_GET_TEM ;                //获取温度
extern NSString *const GW_OID_GETANDSET_TEMVALUE;      //获取设置温度阈值
extern NSString *const GW_OID_GETANDSET_TIMER;         //获取设置定时器 注：定时开空调
extern NSString *const GW_OID_CREATE_LOCAL_CODE;       //创建本地码库
extern NSString *const GW_OID_DELETE_LOCAL_CODE;       //删除本地码库
extern NSString *const GW_OID_HEARTBEAT;               //心跳 （与网关通信）
extern NSString *const GW_OID_LINK_CONTROL;            //联动控制（与网关通信）
extern NSString *const GW_OID_RcTimer ;           //获取定时时间

/** pragma mark 设备常量类 */

/*
 Serial number。SN 唯一标定一个消息对象。当连接云智易服务器时，发送新的消
 息，SN 必须与上次发送的消息 SN 不同，如果是重发，则消息 SN 相同;当 SN 值达到最大值 时则重新计数。当连接客户服务器时，SN 保留不用。
 */
extern NSString *const SN_KEY;

/*
 Class Identify。CID 唯一标定一个消息类。必须填写。
 */
extern NSString *const CID_KEY;

/*
 Session Identify。唯一标定用户登录到登出期间交互的消息序列。用户登录到登出期
 间的消息有相同的 SID。登录后到登出期间必须填写(GW:用户昵称)。"获取请求"与"获取 应答"不带此字段。
 */
extern NSString *const SID_KEY;

/*
 Name。消息类的名称。增加消息的可读性。可选填写。
 */
extern NSString *const NM_KEY;

/*
 Return Code。返回码。
 失败 RC=0 未知错误
 失败 RC=-1 参数错误
 失败 RC=-2 解密失败 (明文回复) 失败
 RC=-3 不存在该 OID
 失败 RC=-4 CID 不存在 失败
 RC=-5 PL 中不能为空
 失败 RC=-6 TEID 不能为空
 */
extern NSString *const RC_KEY;

/*
 PL 数据类型 String,JSON 的 key
 Payload。PL 对应的 Value 中承载业务信息。
 */
extern NSString *const PL_KEY;

/* 唯一标示用户 ID 码(GW:云端 APP ID 码)。"获取请求"与"获取应答"不带此字段。 */
extern NSString *const TEID_KEY;

/* 该数据是否加密 0 为不加密，1 为 AES128+BASE64 */
extern NSString *const ENCRYPT_KEY;

/* 操作id */
extern NSString *const OID_KEY;





@end
