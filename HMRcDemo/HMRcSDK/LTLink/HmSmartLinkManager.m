//
//  HmSmartLinkManager.m
//  CustomProject
//
//  Created by haimen_ios_imac on 2018/2/8.
//  Copyright © 2018年 深圳海曼科技有限公司. All rights reserved.
//

#import "HmSmartLinkManager.h"
#import "ESPTouchTask.h"
#import "HmLinkModel.h"
#import "HmSmartLink.h"
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>

static NSTimeInterval INTERVAL = 1.0f;
static NSTimeInterval CURRENT_INTERVAL = 0.0f;

static HmSmartLinkManager *_mgr = nil;

NSString *const NET_IN_CODE_KEY = @"netInCode";
NSString *const NET_IN_DEVICE_MAC = @"devMac";

@interface HmSmartLinkManager ()<ESPTouchDelegate>
{
    ESPTouchTask        *_gasEspTouchTask;//wifi气感配网
    NSCondition         *_gasCondition;
    ESPTouchResult      *_gasRusult;    //wifi气感配网成功回调结果
    
    NSTimer             *_outTimer;
}

@property (nonatomic, assign) HM_DEVICE_TYPE netInDevType;

@property (nonatomic, copy) HmNetInBlock resultResponse;
@property (nonatomic, copy) HmNetInBlock outResponse;

@end

@implementation HmSmartLinkManager

- (instancetype)init
{
    if (self = [super init]) {
        _outTimerInterval = 120.0f;
    }
    return self;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mgr = [[HmSmartLinkManager alloc] init];
    });
    return _mgr;
}

- (void)startOutTimer
{
    [self stopOutTimer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _outTimer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(monitorOutTimer) userInfo:nil repeats:YES];
    });
}

- (void)stopOutTimer
{
    CURRENT_INTERVAL = 0.0f;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_outTimer) {
            [_outTimer invalidate];
            _outTimer = nil;
        }
    });
}

- (void)monitorOutTimer
{
    CURRENT_INTERVAL += 1.0f;
    if (CURRENT_INTERVAL > _outTimerInterval) {
        [self stopOutTimer];
        [self stopWifiNetInResponse:nil];
        
        if (self.outResponse) {
            self.outResponse(NO, @{NET_IN_CODE_KEY: @(NETIN_OUTTIME_CODE)});
        }
    }
}

//- WifiNetInTypeHeiman: 最新固件
//- WifiNetInTypeHanFeng: 汉枫配网模块
//- WifiNetInTypeEspTouch: WIFI 气感  红外配网固件
- (void)startWifiNetInWithDevType:(HM_DEVICE_TYPE)devType
                     wifiPassword:(NSString *)wifiPass
                    resultResponse:(HmNetInBlock)resultBlock
                      outResponse:(HmNetInBlock)outBlock
{
    if (![wifiPass isKindOfClass:[NSString class]] ||
        !wifiPass ||
        wifiPass.length == 0) {
        
        if (resultBlock) resultBlock(NO, @{NET_IN_CODE_KEY: @(PASSWORD_ERROR_CODE)});
        return;
    }
    if (![self getDeviceSSID] || [self getDeviceSSID].length == 0) {
        
        if (resultBlock) resultBlock(NO, @{NET_IN_CODE_KEY: @(WIFI_DISCONNECT_CODE)});
        return;
    };
    
    _netInDevType = devType;
    self.outResponse = outBlock;
    self.resultResponse = resultBlock;
    //选择配网方式
    if (_netInDevType == HM_DEVICE_TYPE_WIFI_AIR ||
        _netInDevType == HM_DEVICE_TYPE_WIFI_METERING_PLUGIN) {
        
        [self configWifiForHanFengModuleWithSsidPassword:wifiPass];
        
    } else if (_netInDevType == HM_DEVICE_TYPE_WIFI_GAS ||
               _netInDevType == HM_DEVICE_TYPE_WIFI_INFRA_RED) {
        
        [self startConfigWifiSsid:[self getDeviceSSID]
                            bssid:[self getDeviceBssid]
                             pass:wifiPass
                      isSsidHiden:NO];
        
    } else if (_netInDevType == HM_DEVICE_TYPE_WIFI_HS1GW) {
        
        [self configWifiForNewModuleWithSsidPass:wifiPass];
    }
}

- (void)stopWifiNetInResponse:(void(^)(BOOL success))responseBlock
{
    if (_netInDevType == HM_DEVICE_TYPE_WIFI_AIR ||
        _netInDevType == HM_DEVICE_TYPE_WIFI_METERING_PLUGIN) {
        
        [[HFSmartLink shareInstence] stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
            
            if (responseBlock) responseBlock(isOk);
        }];
        
    } else if (_netInDevType == HM_DEVICE_TYPE_WIFI_GAS ||
               _netInDevType == HM_DEVICE_TYPE_WIFI_INFRA_RED) {
        
        [self interruptConfigWifi];
        if (responseBlock) responseBlock(YES);
        
    } else if (_netInDevType == HM_DEVICE_TYPE_WIFI_HS1GW) {
        
        [[HmSmartLink sharedSmartLink] stopSmartLinkResponse:^(NSError *error, BOOL isSuccess) {
            if (responseBlock) responseBlock(isSuccess);
        }];
    }
}

- (void)setOutTimerInterval:(NSTimeInterval)outTimerInterval
{
    _outTimerInterval = outTimerInterval;
    if (_outTimerInterval < 60.0f) {
        _outTimerInterval = 60.0f;
    }
}

#pragma mark 设备配网
//新模块配网方式
- (void)configWifiForNewModuleWithSsidPass:(NSString *)password
{
    [[HmSmartLink sharedSmartLink] startWithPassword:password progress:^(CGFloat progress) {
        
        //console(@"新模块配网方式进度: %lf", progress);
    } error:^(NSError *error) {
        
        //console(@"%@", [error localizedDescription]);
    } singleDeviceSuccess:^(HmLinkModel *device) {
        
        if (!device) return ;
        
        if (device.mac) {
            if (self.resultResponse) {
                self.resultResponse(YES, @{NET_IN_CODE_KEY: @(NETIN_SUCCESS_CODE), NET_IN_DEVICE_MAC: device.mac});
            }
        }
        
        //_successLinkModel = device;
//        [CCPreferenceManager setWifiPassword:password wifiName:[me getSSID]];
        NSLog(@"singleDeviceSuccess %@", device);
//        [me performSelectorOnMainThread:@selector(generateConfigAnimationView)
//                             withObject:nil
//                          waitUntilDone:NO];
        
    } multiDeviceSuccess:^(NSMutableArray *devices) {
        
        NSLog(@"multiDeviceSuccess %@", devices);
    }];
}

//汉枫配网
- (void)configWifiForHanFengModuleWithSsidPassword:(NSString *)pass
{
//    if (_netInType != WifiNetInTypeHanFeng) return;
//    WS(me);
    [HFSmartLink shareInstence].isConfigOneDevice = YES;
    [HFSmartLink shareInstence].waitTimers = _outTimerInterval;
    [[HFSmartLink shareInstence] startWithSSID:[self getDeviceSSID] Key:pass withV3x:true processblock: ^(NSInteger pro) {
        
      NSLog(@"progress %ld", (long)pro);
        
    } successBlock:^(HFSmartLinkDeviceInfo *dev) {
        
        
        if (dev.mac) {
            if (self.resultResponse) {
                self.resultResponse(YES, @{NET_IN_CODE_KEY: @(NETIN_SUCCESS_CODE), NET_IN_DEVICE_MAC: dev.mac});
            }
        }
//          _startConfigButton.selected = false;
//          if (!dev) return ;
//          _HFdevive = dev;
//
//      [CCPreferenceManager setWifiPassword:pass wifiName:[me getSSID]];
//      console(@"singleDeviceSuccess %@", dev);
//      [me performSelectorOnMainThread:@selector(generateConfigAnimationView)
//                           withObject:nil
//                        waitUntilDone:NO];
//      [me stopConfigWifiForHanFengModule];
        
    } failBlock:^(NSString *failmsg) {
//          _startConfigButton.selected = false;
//          console(@"%@", failmsg);
        
    }  endBlock:^(NSDictionary *deviceDic) {
        
//          _startConfigButton.selected = false;
//          NSLog(@"pro:--->    %@",deviceDic);
        
    }];
}

#pragma mark ====== WIFI气感，红外固件配网 ======
-(void)startConfigWifiSsid:(NSString *)ssid
                     bssid:(NSString *)_bssid
                      pass:(NSString *)_pass
               isSsidHiden:(BOOL)_isSsidHiden
{
    _gasCondition = [[NSCondition alloc] init];
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [_gasCondition lock];
        _gasEspTouchTask = [[ESPTouchTask alloc] initWithApSsid:ssid andApBssid:_bssid andApPwd:_pass andIsSsidHiden:_isSsidHiden];
        [_gasEspTouchTask setEsptouchDelegate:self];
        [_gasCondition unlock];
        
        ///执行
        [_gasEspTouchTask executeForResult];
    });
}

///wifi气感 中断配网
- (void)interruptConfigWifi
{
    [_gasCondition lock];
    if (_gasEspTouchTask != nil)
    {
        [_gasEspTouchTask interrupt];
    }
    [_gasCondition unlock];
}

#pragma mark - ESPTouchDelegate
-(void)onEsptouchResultAddedWithResult:(ESPTouchResult *) result
{
    [self interruptConfigWifi];
    NSLog(@"onEsptouchResultAddedWithResult bssid: %@", result.bssid);
    _gasRusult = [[ESPTouchResult alloc] init];
    _gasRusult = result;
    
    if (_gasRusult.bssid.uppercaseString) {
        if (self.resultResponse) {
            self.resultResponse(YES, @{NET_IN_CODE_KEY: @(NETIN_SUCCESS_CODE), NET_IN_DEVICE_MAC: _gasRusult.bssid.uppercaseString});
        }
    }
}

#pragma mark ====== PRIVATE ======
- (NSString *)getDeviceSSID
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"];
    return ssid;
}

-(NSString *)getDeviceBssid
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    
    NSDictionary *SSIDInfo = nil;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    NSString *bssid = [SSIDInfo objectForKey:@"BSSID"];
    return bssid;
}

@end
