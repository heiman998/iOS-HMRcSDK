//
//  HMRcCommandsModel.h
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/2/6.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRcCommandsModel : NSObject

@end

//设备的基本信息
@interface HmRcDeviceBaseInfo : NSObject
/**
 设备名字
 */
@property (nonatomic, strong)NSString * name;
/**
 设备本身的mac地址
 */
@property (nonatomic, strong)NSString * WM;
/**
 保留。。
 */
@property (nonatomic, strong)NSString * FD;
/**
 设备硬件版本
 */
@property (nonatomic, strong)NSString * WHV;
/**
 设备固件版本
 */
@property (nonatomic, strong)NSString * WSV;
/**
 时区
 */
@property (nonatomic, strong)NSString * TZ;
/**
 设备类型
 */
@property (nonatomic, strong)NSString * TY;
/**
 协议版本号
 */
@property (nonatomic, strong)NSString * PV;
/**
 2表示允许更新，否则不允许更新
 */
@property (nonatomic, strong)NSString * CF;
/**
 1升级成功，0升级失败
 */
@property (nonatomic, strong)NSString * RT;

@end

//码库模型
@interface HMSendCodeModel : NSObject
/**
 具体码值
 */
@property (nonatomic, strong)NSString * code;
/**
 虚拟设备ID
 */
@property (nonatomic, strong)NSString * OD;
/**
 OF : 开关状态 开为1 关为0 其他为2
 */
@property (nonatomic, assign)NSInteger OF;
/**
 zip : 压缩方式 0  不压缩
 1  压缩1算法 目前不适用
 2  压缩2算法 学习到的码压缩为2
 3  目前网络获取采用3
 */
@property (nonatomic, assign)NSInteger zip;

/**
 int 学习成功标志，0为不成功  1为成功。成功后返回code不成功返回。包括码库的创建和删除成功与否
 */
@property (nonatomic, assign)NSInteger SC;

@end


@interface HMTempModel : NSObject

/**
 app获取温度 数值范围：根据硬件端定
 */
@property (nonatomic, strong)NSString * TP;

@end

//设置温度报警阀值
@interface HMTempAlarmModel : NSObject
/**
 温度报警上限值，单位℃，注：该值被放大100倍（R/W）
 */
@property (nonatomic, assign)NSInteger  t_ckup;
/**
 温度报警下限值，单位℃，注：该值被放大100倍（R/W）
 */
@property (nonatomic, assign)NSInteger  t_cklow;
/**
 高温使能标志，1使能报警阀值，0禁能报警阀值（R/W）
 */
@property (nonatomic, assign)NSInteger  t_ckvalid_up;
/**
 低温使能标志，1使能报警阀值，0禁能报警阀值（R/W）
 */
@property (nonatomic, assign)NSInteger  t_ckvalid_low;

/**
 0为不成功  1为成功。成功后返回code不成功返回。默认0 (设置成功/失败)
 */
@property (nonatomic, assign)NSInteger SC;
@end


