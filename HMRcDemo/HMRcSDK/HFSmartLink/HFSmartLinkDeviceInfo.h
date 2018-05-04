//
//  HFSmartLinkDeviceInfo.h
//  SmartlinkLib
//
//  Created by wangmeng on 15/3/17.
//  Copyright (c) 2015年 HF. All rights reserved.
//  汉枫SmratLink SDK 主要用于旧版本网关，以及空气质量程序中
//

#import <Foundation/Foundation.h>

@interface HFSmartLinkDeviceInfo : NSObject
@property (nonatomic,strong) NSString * ip;
@property (nonatomic,strong) NSString * mac;
@end
