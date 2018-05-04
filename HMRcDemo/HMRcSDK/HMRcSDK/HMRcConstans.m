//
//  HMRcConstans.m
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/1/30.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "HMRcConstans.h"

@implementation HMRcConstans


#pragma mark--------- 红外遥控转发器协议OID分配

//NSString *const GW_OID_ZIGBEE_ALL_ENABLE_KEY = @"2.1.1.7";       //获取基本信息
NSString *const GW_OID_BASEINFO_KEY = @"2.1.1.1";   //获取基本信息
NSString *const GW_OID_AESKEY = @"2.1.1.1.1";  //获取秘钥     注：公钥加密私钥
NSString *const GW_OID_TIMEZONE_KEY = @"2.1.1.1.2"; //设置/获取时区
NSString *const GW_OID_SETANDGET_DEVICENAME = @"2.1.1.254"; //获取/设置设备名称
NSString *const GW_OID_OTA_UPDATE = @"2.1.1.6.x"; //固件升级
NSString *const GW_OID_LEARN = @"2.1.1.255.3.1";    //红外学习功能
NSString *const GW_OID_VIRTUAL_DEVICE_SENDRC = @"2.1.1.255.3.2";  //虚拟设备发送红外码
NSString *const GW_OID_GET_TEM = @"2.1.1.255.3.3";                //获取温度
NSString *const GW_OID_GETANDSET_TEMVALUE = @"2.1.1.255.3.31";    //获取设置温度阈值

NSString *const GW_OID_CREATE_LOCAL_CODE = @"2.1.1.255.3.5";      //创建本地码库
NSString *const GW_OID_DELETE_LOCAL_CODE = @"2.1.1.255.3.6";      //删除本地码库
NSString *const GW_OID_HEARTBEAT = @"2.1.1.255.3.7";              //心跳 （与网关通信）
NSString *const GW_OID_LINK_CONTROL = @"2.1.1.255.3.8";         //联动控制（与网关通信）
NSString *const GW_OID_RcTimer = @"2.1.1.255.30.OD";           //获取定时时间
NSString *const GW_OID_GETANDSET_TIMER = @"2.1.1.255.3.30";       //获取设置定时器 注：定时开空调

#pragma mark--------- 消息模型的基类成员定义

/*
 Serial number。SN 唯一标定一个消息对象。当连接云智易服务器时，发送新的消
 息，SN 必须与上次发送的消息 SN 不同，如果是重发，则消息 SN 相同;当 SN 值达到最大值 时则重新计数。当连接客户服务器时，SN 保留不用。
 */
NSString *const SN_KEY = @"SN";

/*
 Class Identify。CID 唯一标定一个消息类。必须填写。
 */
NSString *const CID_KEY = @"CID";

/*
 Session Identify。唯一标定用户登录到登出期间交互的消息序列。用户登录到登出期
 间的消息有相同的 SID。登录后到登出期间必须填写(GW:用户昵称)。"获取请求"与"获取 应答"不带此字段。
 */
NSString *const SID_KEY = @"SID";

/*
 Name。消息类的名称。增加消息的可读性。可选填写。
 */
NSString *const NM_KEY = @"NM";

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
NSString *const RC_KEY = @"RC";

/*
 PL 数据类型 String,JSON 的 key
 Payload。PL 对应的 Value 中承载业务信息。
 */
NSString *const PL_KEY = @"PL";

/* 唯一标示用户 ID 码(GW:云端 APP ID 码)。"获取请求"与"获取应答"不带此字段。 */
NSString *const TEID_KEY = @"TEID";

/* 该数据是否加密 0 为不加密，1 为 AES128+BASE64 */
NSString *const ENCRYPT_KEY = @"ENCRYPT";

/* 操作id */
NSString *const OID_KEY = @"OID";



@end
