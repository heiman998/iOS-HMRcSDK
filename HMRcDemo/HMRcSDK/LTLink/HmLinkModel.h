//
//  HmLinkModel.h
//  HmSmartLink
//
//  Created by haimen_ios_imac on 2017/6/14.
//  Copyright © 2017年 深圳海曼科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HmLinkModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *dIp;


- (instancetype)initWithMac:(NSString *)mac deviceIp:(NSString *)dIp deviceName:(NSString *)name;

- (instancetype)initWithMac:(NSString *)mac deviceIp:(NSString *)dIp;

@end
