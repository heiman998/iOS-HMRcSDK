//
//  HmSmartLink.m
//  HmSmartLink
//
//  Created by haimen_ios_imac on 2017/6/14.
//  Copyright © 2017年 深圳海曼科技有限公司. All rights reserved.
//

#import "HmSmartLink.h"
#import "LTLink.h"
#import "GCDAsyncUdpSocket.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HmLinkModel.h"

static HmSmartLink *_smartLink = nil;
@interface HmSmartLink ()
<
    GCDAsyncUdpSocketDelegate
>
@property (nonatomic, strong) NSMutableArray *successDeviceArray;

@property (nonatomic, copy) SmartLinkError errorBlock;

@property (nonatomic, copy) SmartLinkStop stopBlock;

@property (nonatomic, copy) SmartLinkProgress currentProgress;

@property (nonatomic, copy) SmartLinkSingleDeviceBlock linkSingleDevice;

@property (nonatomic, copy) SmartLinkMultiDeviceBlock linkMultiDevice;

@end

@implementation HmSmartLink
{
    LTLink *_linkManager;
    GCDAsyncUdpSocket *_udpSocket;
    
    uint16_t localPort;
    NSTimeInterval progressNumber;
    NSTimer *_progressTimer;
}

+ (instancetype)sharedSmartLink
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _smartLink = [[HmSmartLink alloc] init];
    });
    return _smartLink;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        localPort = 8001;
        _smartInterval = 120.0f;
        _waitDeviceInterval = 0.0f;
        _smartSingleDevice = YES;
    }
    return self;
}

- (BOOL)startSmartLink
{
    _linkManager = [[LTLink alloc] init];
    [_linkManager startGuidance];
    
    dispatch_queue_t globalqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:globalqueue];
    
    _successDeviceArray = [NSMutableArray array];
    
    NSError *error = nil;
    [_udpSocket bindToPort:localPort error:&error];
    if (error) {
        NSLog(@"bindToPort %@", [error localizedDescription]);
    }
    
    [_udpSocket enableBroadcast:YES error:&error];
    if (error) {
        NSLog(@"enableBroadcast %@", [error localizedDescription]);
    }
    
    [_udpSocket beginReceiving:&error];
    if (error) {
        NSLog(@"beginReceiving %@", [error localizedDescription]);
    }
    
    if (error) {
        if (self.errorBlock) {
            self.errorBlock(error);
        }
        return NO;
    }
    return YES;
}

- (void)startWithPassword:(NSString *)pass
                 progress:(SmartLinkProgress)progressBlock
                    error:(SmartLinkError)errorBlock
      singleDeviceSuccess:(SmartLinkSingleDeviceBlock)singleBlock
       multiDeviceSuccess:(SmartLinkMultiDeviceBlock)multiBlock
{
    self.linkSingleDevice = singleBlock;
    self.currentProgress = progressBlock;
    self.errorBlock = errorBlock;
    self.linkMultiDevice = multiBlock;
    
    if (![self startSmartLink]) {
        return;
    }
    
    [self startProgressTimer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_waitDeviceInterval * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *ssid = [self getDeviceSSID];
        [_linkManager startLinkWithSSID:ssid password:pass secureKey:nil];
    });
}

#pragma mark 定时器
- (void)startProgressTimer
{
    if (_progressTimer) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
    
    progressNumber = 0.0f;
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(progress:) userInfo:nil repeats:YES];
}

- (void)progress:(id)sender
{
    progressNumber ++;
    
    if (self.currentProgress) {
        self.currentProgress(progressNumber/_smartInterval);
    }
    
    //NSLog(@"%lf", progressNumber);
    if (progressNumber == _smartInterval)
        [self stopProgressTimer];
}

- (void)stopProgressTimer
{
    if (_progressTimer) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    } 
    //[self stopSmartLinkResponse:nil];
}

- (void)stopSmartLinkResponse:(SmartLinkStop)stopBlock
{
    self.stopBlock = stopBlock;
    [self stopProgressTimer];
    
    if (self.currentProgress) {
        self.currentProgress(_smartInterval/_smartInterval);
    }
    
    if (_udpSocket) {
        [_udpSocket close];
        _udpSocket = nil;
    }
    
    if (_linkManager) {
        [_linkManager stopLink];
        _linkManager = nil;
    }
    
    if (_successDeviceArray) {
        [_successDeviceArray removeAllObjects];
        _successDeviceArray = nil;
    }
}

#pragma mark UDP 代理方法
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSLog(@"%s", __func__);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error
{
    
    NSLog(@"%s", __func__);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    
    NSLog(@"%s", __func__);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error
{
    
    NSLog(@"%s", __func__);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext
{ 
    NSLog(@"%s", __func__);
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (![self regexString:msg] || !_successDeviceArray) return;
    
    NSInteger len = [msg length];
    NSString *josnStr = [msg substringWithRange:NSMakeRange(1, len-2)];
    NSData *jsonData = [josnStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    NSString *name = dict[@"device"][@"deviceName"];
    NSString *mac = dict[@"device"][@"macAddress"];
    NSString *dIp = dict[@"device"][@"deviceIP"];
    BOOL isSave = NO;
    for (HmLinkModel *successDevice in self.successDeviceArray) {
        if ([successDevice.mac isEqualToString:mac]) {
            isSave = YES;
            break;
        }
    }
    
    HmLinkModel *device = [[HmLinkModel alloc] initWithMac:mac deviceIp:dIp deviceName:name];
    if (isSave) {
        return;
    } else {
        [_successDeviceArray addObject:device];
    }
    
    if (self.smartSingleDevice) {
        if (self.linkSingleDevice) {
            self.linkSingleDevice([_successDeviceArray firstObject]);
        }
    } else {
        if (self.linkMultiDevice) {
            self.linkMultiDevice(_successDeviceArray);
        }
    }
    
    if (self.currentProgress) {
        self.currentProgress(progressNumber/(CGFloat)_smartInterval);
    }
    
    if (self.smartSingleDevice) {
        if (self.successDeviceArray.count == 1) {
            [self stopProgressTimer];
            [self stopSmartLinkResponse:nil];
        }
    }
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error
{
    NSLog(@"%s", __func__);
    BOOL stopSuccess = YES;
    if (error) {
        stopSuccess = NO;
        [self stopProgressTimer];
        
        if (self.errorBlock) {
            self.errorBlock(error);
        }
    }
    
    if (self.stopBlock) {
        self.stopBlock(error, stopSuccess);
    }
}

#pragma mark 获取设备SSID
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
//判断是否以前缀 @"^" 开头，以 @"&" 结尾
- (BOOL)regexString:(NSString *)regexStr
{
    if ([regexStr hasPrefix:@"^"] && [regexStr hasSuffix:@"&"]) {
        return YES;
    }
    return NO;
}


@end
