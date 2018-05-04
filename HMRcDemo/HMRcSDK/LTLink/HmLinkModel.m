//
//  HmLinkModel.m
//  HmSmartLink
//
//  Created by haimen_ios_imac on 2017/6/14.
//  Copyright © 2017年 深圳海曼科技有限公司. All rights reserved.
//

#import "HmLinkModel.h"

@implementation HmLinkModel

- (instancetype)initWithMac:(NSString *)mac deviceIp:(NSString *)dIp deviceName:(NSString *)name
{
    if (self = [super init]) {
        
        _name = name;
        _mac = mac;
        _dIp = dIp;
    }
    return self;
}

- (instancetype)initWithMac:(NSString *)mac deviceIp:(NSString *)dIp
{
    
    if (self = [super init]) {
        
        _mac = mac;
        _dIp = dIp;
    }
    return self;
}


- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"device mac: %@ name: %@ ip: %@", _mac, _name, _dIp];
    return desc;
}

@end
