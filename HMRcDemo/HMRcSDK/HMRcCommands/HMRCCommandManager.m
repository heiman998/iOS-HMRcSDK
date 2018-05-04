//
//  HMRCCommandManager.m
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/2/1.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "HMRCCommandManager.h"
#import "Enum.h"
#import "HMRcConstans.h"
#import "HmEncrypt.h"
#import "HmUtils.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CID_TYPE) {
    
    mibGetRequest  = 30021,    //获取请求
    mibGetResponse = 30022,    //获取应答
    mibSetRequest  = 30011,    //设置请求
    mibSetResponse = 30012,    //设置应答
    mibUpload      = 40000,    //数据上报
};
//用户名
NSString * userName(void){
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"HM_Rc_userName"];
}
//用户id
NSString *  userId(void) {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"HM_Rc_userId"];
}

static long SN = 100000;

@implementation HMRCCommandManager

static HMRCCommandManager *_mgr = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mgr = [[HMRCCommandManager alloc] init];
    });
    return _mgr;
}
+ (void)releaseManager
{
    if (_mgr) _mgr = nil;
}
#pragma mark ---------设备的发送指令
/**
 获取AES密钥
 */
- (void)getRcAeckeyWithCallBack:(RcCallBack)callBack{
    NSInteger   cid =  mibGetRequest;
    NSInteger   encrypt = 0;
    NSDictionary * pl = @{
                          OID_KEY:@[GW_OID_AESKEY]
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:nil callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}

/**
 获取设备的基本信息
 */
- (void)getDeviceInfoWithHmRcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack{
    
    NSInteger   cid =   mibGetRequest;
    NSInteger   encrypt = 1;
    NSDictionary * pl = @{
                          OID_KEY:@[GW_OID_BASEINFO_KEY]
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}


/**
 设置时区
 
 @param timeZone 时区
 */
- (void)setRcTimeZone:(NSString *)timeZone RcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack{
   
    if ([HmUtils isEmptyString:timeZone]) {
        callBack(nil,SN,RC_PARAMETER_ERROR);
        return;
    }
    NSInteger   cid =  mibSetRequest;
    NSInteger   encrypt = 1;
    NSDictionary * pl = @{
                          GW_OID_TIMEZONE_KEY:@{
                                  @"TZ":timeZone
                                  }
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}


/**
 获取红外设备名字
 */
- (void)getRcDeviceNameWithRcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack{
    
    NSInteger   cid =  mibGetRequest;
    NSInteger   encrypt = 1;
    NSDictionary * pl = @{
                          OID_KEY:GW_OID_SETANDGET_DEVICENAME
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}


/**
 设置红外设备名字
 */
- (void)setRcDeviceName:(NSString *)deviceName hmRcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack{
    if ([HmUtils isEmptyString:deviceName]) {
        callBack(nil,SN,RC_PARAMETER_ERROR);
        return;
    }
    NSInteger   cid =  mibSetRequest;
    NSInteger   encrypt = 1;
    NSDictionary * pl = @{
                          GW_OID_SETANDGET_DEVICENAME:@{
                                  @"name":deviceName
                                  }
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
       callBack(successInfo,sn,errorCode);
    }];
}

/**
 设备固件更新
 
 @param  deviceType 固件类型 1：wifi固件 2：ZigBee协调器固件 3：ZigBee子设备固件 4:声音升级)
                   设备类型，当升级设备类型为zigbee子设备时有效
 */
- (void)updateRcFirmware:(NSInteger )deviceType RcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack{
 
    if (deviceType != 1 && deviceType != 2 && deviceType != 3 && deviceType != 4 ) {
        callBack(nil,SN,RC_PARAMETER_ERROR);return;
    }
    NSString * deType = [NSString stringWithFormat:@"%ld",(long)deviceType];
    NSString * oid = [GW_OID_OTA_UPDATE stringByReplacingOccurrencesOfString:@"x" withString:deType];
    NSInteger   cid =  mibSetRequest;
    NSInteger   encrypt = 1;
    NSDictionary * pl = @{
                          oid:@{
                                  @"CF" : @2,
                                  @"TV" : @(deviceType)
                                  }
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}

/**
 红外学习功能
 */
- (void)statLearnRcActionWithRcModel:(HMRcModel *)rcModel odId:(NSString *)OD callBack:(RcCallBack)callBack{

    NSInteger   cid =  mibSetRequest;
    NSInteger   encrypt = 1;
    NSDictionary * pl = @{
                          GW_OID_LEARN  :@{
                                  @"OD" : OD
                                  }
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
       callBack(successInfo,sn,errorCode);
    }];
}

/**
 获取定时时间指令

 @param rcModel 密钥
 @param OD 虚拟设备id
 @param callBack 回调信息
 */
- (void)getRcTimerWithRcModel:(HMRcModel *)rcModel odId:(NSString *)OD callBack:(RcCallBack)callBack{
   
    NSInteger   cid =  mibGetRequest;
    NSInteger   encrypt = 1;
//    NSString *const GW_OID_RcTimer = @"2.1.1.255.30.OD";           //获取定时时间
    NSString * oid = [GW_OID_RcTimer stringByReplacingOccurrencesOfString:@"OD" withString:OD];
    NSDictionary * pl = @{
                          OID_KEY :oid
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}

/**
 app设置定时时间指令

 @param rcModel 密钥
 @param OD 虚拟设备id
 @param rcTimer 定时器对象
 @param callBack 信息回调
 */
- (void)setRcTimerWithRcModel:(HMRcModel *)rcModel odId:(NSString *)OD hmRcTimer:(HMRCTimer *)rcTimer callBack:(RcCallBack)callBack{
    
    NSInteger   cid =  mibSetRequest;
    NSInteger   encrypt = 1;
    NSDictionary * dic = @{
              @"TS":@[@(rcTimer.smonth),@(rcTimer.sday),@(rcTimer.shour),@(rcTimer.sminutes)],
              @"TE":@[@(rcTimer.emonth),@(rcTimer.eday),@(rcTimer.ehour),@(rcTimer.eminutes)],
              @"WF":@(rcTimer.wf),
              @"OD":OD,
              @"CODES":rcTimer.codeS,
              @"CODEE":rcTimer.codeE
            };
    NSDictionary * pl = @{
                GW_OID_GETANDSET_TIMER :dic
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
       callBack(successInfo,sn,errorCode);
    }];
}

/**
 虚拟设备发送红外码库

 @param rcModel  密钥
 @param sModel    红外码值HMSendCodeModel模型
 @param callBack 回调消息码
 */
- (void)setFictitiousDeviceRcCodeWitHmRcModel:(HMRcModel *)rcModel
                            HmSendCodeModel:(HMSendCodeModel *)sModel
                                     callBack:(RcCallBack)callBack{
    
    NSString * code = sModel.code;
    NSString * OD = sModel.OD;
    NSInteger zipNum = sModel.zip;
    NSInteger OF = 0;
    if ([HmUtils isEmptyString:code] || [HmUtils isEmptyString:OD]) {
        callBack(nil,SN,RC_PARAMETER_ERROR);return;
    }
    NSInteger   cid =  mibSetRequest;
    NSInteger zip = zipNum;
    if (zip < 0) zip = 3;
    NSInteger   encrypt = 1;
    NSDictionary * dic = @{@"OF": @(OF),
                           @"zip": @(zip),
                           @"code": code,
                           @"OD": OD};
    NSDictionary * pl = @{
                          GW_OID_VIRTUAL_DEVICE_SENDRC  :dic
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}


/**
 获取红外温度

 @param rcModel  密钥
 @param callBack 消息回调
 */
- (void)getRcTemperatureWithRcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack{
 
    NSInteger   cid =  mibGetRequest;
    NSInteger   encrypt = 1;
    NSDictionary * pl = @{
                         OID_KEY:@[GW_OID_GET_TEM]
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}

/**
 获取温度报警阈值
 
 @param rcModel  密钥
 @param callBack 消息回调
 */
- (void)getRcTemperatureLimitValueWithRcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack{

    NSInteger   cid =  mibGetRequest;
    NSInteger   encrypt = 1;
    NSDictionary * pl = @{
                          OID_KEY:@[GW_OID_GETANDSET_TEMVALUE]
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}


/**
 设置温度报警阈值

 @param rcModel  密钥
 @param tpAlarm  温度报警阈值
 @param callBack 信息回调
 */
- (void)setRcTemperatureLimitValueWithRcModel:(HMRcModel *)rcModel
                                         HmTempAlarmModel:(HMTempAlarmModel *)tpAlarm
                                     callBack:(RcCallBack)callBack{
    NSInteger ckUp  = tpAlarm.t_ckup;
    NSInteger ckLow = tpAlarm.t_cklow;
    NSInteger isUpEnable = tpAlarm.t_ckvalid_up;
    NSInteger isLowEnable = tpAlarm.t_ckvalid_low;

    NSInteger upEnableNum = 0;
    if (isUpEnable) upEnableNum = 1;
    NSInteger lowEnableNum = 0;
    if (isLowEnable) lowEnableNum = 1;
    NSInteger   cid =  mibSetRequest;
    NSInteger   encrypt = 1;
    NSDictionary *dict = @{@"t_ckup": @(ckUp),
                           @"t_cklow": @(ckLow),
                           @"t_ckvalid_up": @(upEnableNum),
                           @"t_ckvalid_low": @(lowEnableNum)
                           };
    NSDictionary * pl = @{
                          GW_OID_GETANDSET_TEMVALUE :dict
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}


/**
 创建本地码库

 @param rcModel       密钥
 @param localCodeList 红外码值列表
 @param callBack      回复信息
 */
- (void)createLocalCodeWithRcModel:(HMRcModel *)rcModel
                            localCodes:(NSArray <HMSendCodeModel *> *)localCodeList
                              callBack:(RcCallBack)callBack{

    if ([HmUtils isEmptyArray:localCodeList]) {
        callBack(nil,SN,RC_PARAMETER_ERROR);
        return;
    }
    NSMutableArray * muArr = [NSMutableArray array];
    for (int i = 0; i < localCodeList.count; i++) {
        HMSendCodeModel * model = localCodeList[i];
        NSDictionary * dic = @{
                               @"code":model.code,
                               @"OF"  :@(model.OF),
                               @"zip" :@(model.zip),
                               @"OD"  :model.OD
                                   };
        [muArr addObject:dic];
    }
    NSInteger   cid =  mibSetRequest;
    NSInteger   encrypt = 1;
    NSDictionary * pl = @{
                          GW_OID_CREATE_LOCAL_CODE:muArr
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}

/**
 删除本地码库
 
 @param rcModel  密钥
 @param od       虚拟设备id
 @param callBack 回复信息
 */
- (void)deleteLocalCodeWithRcModel:(HMRcModel *)rcModel
                                OD:(NSString *)od
                        callBack:(RcCallBack)callBack{

    if ([HmUtils isEmptyString:od]) {
        callBack(nil,SN,RC_PARAMETER_ERROR);
        return;
    }
    NSInteger   cid =  mibSetRequest;
    NSInteger   encrypt = 1;
    NSDictionary * pl = @{
                          GW_OID_DELETE_LOCAL_CODE:@{@"OD": od}
                          };
    [self baseSendWithCID:cid PL:pl ENCRYPT:encrypt hmRcModel:rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
        callBack(successInfo,sn,errorCode);
    }];
}


/**
 发送消息的格式
 
 @param cid      CID唯一标定一个消息类
 @param pl       PL对应的Value中承载业务信息
 @param encrypt  该数据是否加密
 @param rcModel  密钥/公钥
 */
- (void)baseSendWithCID:(NSInteger)cid PL:(NSDictionary *)pl ENCRYPT:(NSInteger)encrypt hmRcModel:(HMRcModel *)rcModel callBack:(RcCallBack)callBack{
    if ([HmUtils isEmptyString:userId()] || [HmUtils isEmptyString:userName()]) {
        callBack(nil,SN,RC_NO_INIT);
        return;
    }
    if (encrypt == 1 && [HmUtils isEmptyString:rcModel.aeskey]){
        callBack(nil,SN, RC_CODEKEY_NIL);
        return;
    }
    NSString * key = [NSString string];
    NSString * str = [NSString string];
    NSDictionary * dic = @{
                           CID_KEY      : @(cid),
                           PL_KEY       : pl,
                           ENCRYPT_KEY  : @(encrypt),
                           SID_KEY      : userName(),
                           SN_KEY       : [NSNumber numberWithInteger:( ++ SN )] ,
                           TEID_KEY     : userId()
                           };
    if (encrypt == 1) {
        key = rcModel.aeskey;
        str = [HmEncrypt hmEncrypt:key jsonData:dic];
    }else{
        str = [self dictionaryToJson:dic];
    }
    if (SN >= 999999) SN = 100000;
    if (![HmUtils isEmptyString:str]) {
        callBack(str,SN,RC_SUCCESS);
    }else{
        callBack(nil,SN,RC_ENCRYPTION_ERROR);
    }
}
#pragma mark ----------设备回复/主动上报的信息
/**
 设备回复或主动上报的信息

 @param rcModel 密钥
 @param data 回复或上报的数据信息
 @param callBack 回调的信息
 */
- (void)baseReplyWithRcModel:(HMRcModel *)rcModel backData:(NSData *)data callBack:(RcCallBack)callBack{
    
    //解密成字典处理
    NSDictionary * dicData = [NSDictionary dictionary];
    if (![HmUtils isEmptyString:rcModel.acckey] && [HmUtils isEmptyString:rcModel.aeskey]) {
        dicData = [HmEncrypt hmDecryptWithPrivateKey:rcModel.acckey payData:data];
    }else if (![HmUtils isEmptyString:rcModel.aeskey]){
        dicData = [HmEncrypt hmDecryptWithPrivateKey:rcModel.aeskey payData:data];
    }
    if (dicData == nil) {
        callBack(nil,SN,RC_DECRYPTION_ERROR);
        return;
    }
    int cid = [dicData[CID_KEY] intValue];
    
    NSDictionary * plDic = (NSDictionary *)dicData[PL_KEY];
    int sn = [dicData[SN_KEY] intValue];
    if ([HmUtils isEmptyString:rcModel.aeskey]) {
        callBack(nil,sn,RC_CODEKEY_NIL);
        return;
    }
    int rc = [dicData[RC_KEY] intValue];
    if (rc < 0) {
        callBack(nil, sn, rc);
        return;
    }
    if (cid != mibGetResponse && cid != mibSetResponse && cid != mibUpload ) {
        return ;
    }else{
        switch (cid) {
                //                获取应答 30022
            case mibGetResponse:{
                //获取AES密钥
                if ([[plDic allKeys] containsObject: GW_OID_AESKEY]) {
                    NSString * aeskey = plDic[GW_OID_AESKEY][@"key"];
                    HMRcModel * reModel = [[HMRcModel alloc]init];
                    rcModel.aeskey = aeskey;
                    callBack(reModel,sn,RC_SUCCESS);
                }
                //获取设备基本信息
                else if ([[plDic allKeys] containsObject: GW_OID_BASEINFO_KEY]) {
                    NSDictionary * deviceInfo = [plDic objectForKey:GW_OID_BASEINFO_KEY];
                    HmRcDeviceBaseInfo * baseInfo = [[HmRcDeviceBaseInfo alloc]init];
                    baseInfo.WM  = deviceInfo[@"WM"];
                    baseInfo.FD  = deviceInfo[@"FD"];
                    baseInfo.WHV = deviceInfo[@"WHV"];
                    baseInfo.WSV = deviceInfo[@"WSV"];
                    baseInfo.TZ  = deviceInfo[@"TZ"];
                    baseInfo.TY  = deviceInfo[@"TY"];
                    baseInfo.TY  = deviceInfo[@"PV"];
                    callBack(baseInfo ,sn ,RC_SUCCESS);
                }
                //app获取温度阈值
                else if ([[plDic allKeys] containsObject: GW_OID_GETANDSET_TEMVALUE]){
                    NSDictionary * dic = plDic[GW_OID_GETANDSET_TEMVALUE];
                    HMTempAlarmModel * tpAlarm = [[HMTempAlarmModel alloc]init];
                    tpAlarm.t_ckup  = (long)dic[@"t_ckup"];
                    tpAlarm.t_cklow = (long)dic[@"t_cklow"];
                    tpAlarm.t_ckvalid_up  = (long)dic[@"t_ckvalid_up"];
                    tpAlarm.t_ckvalid_low = (long)dic[@"t_ckvalid_low"];
                    callBack(tpAlarm,sn, RC_SUCCESS);
                }
                //app获取定时 时间指令
                else if ([[plDic allKeys] containsObject: GW_OID_RcTimer]){
                    NSDictionary * dic0 = plDic[GW_OID_RcTimer];
                    NSDictionary * dic1 = dic0[@"SE"];
                    NSArray * ts = (NSArray *)dic1[@"TS"];
                    NSArray * te = (NSArray *)dic1[@"TE"];
                    NSInteger wf = (long)dic1[@"WF"];
                    HMRCTimer * timer = [[HMRCTimer alloc]init];
                    timer.wf = wf;
                    timer.smonth = (long)ts[0];
                    timer.sday   = (long)ts[1];
                    timer.shour  = (long)ts[2];
                    timer.sminutes  = (long)ts[3];
                    timer.emonth = (long)te[0];
                    timer.eday   = (long)te[1];
                    timer.ehour  = (long)te[2];
                    timer.eminutes  = (long)te[3];
                    callBack(timer,sn,RC_SUCCESS);
                }
                //获取红外设备名字
                else if ([[plDic allKeys] containsObject: GW_OID_SETANDGET_DEVICENAME]) {
                    NSDictionary * devcieNameDic = plDic[GW_OID_SETANDGET_DEVICENAME];
                     HmRcDeviceBaseInfo * baseInfo = [[HmRcDeviceBaseInfo alloc]init];
                    baseInfo.name = devcieNameDic[@"name"];
                    callBack(baseInfo ,sn, RC_SUCCESS);
                }else{
                    callBack(nil ,sn,RC_UNKNOWN_ERROR);
                }
            }
                break;
                //                设置应答 30012
            case mibSetResponse:{
                //设置时区
                if ([[plDic allKeys] containsObject: GW_OID_TIMEZONE_KEY]) {
                    NSDictionary * timeZoneDic = plDic[GW_OID_TIMEZONE_KEY];
                    HmRcDeviceBaseInfo * baseInfo = [[HmRcDeviceBaseInfo alloc]init];
                    baseInfo.TZ = timeZoneDic[@"TZ"];
                    callBack(baseInfo ,sn, RC_SUCCESS);
                }
                //设置红外设备名字
                else if ([[plDic allKeys] containsObject: GW_OID_SETANDGET_DEVICENAME]) {
                    NSDictionary * devcieNameDic = plDic[GW_OID_SETANDGET_DEVICENAME];
                    HmRcDeviceBaseInfo * baseInfo = [[HmRcDeviceBaseInfo alloc]init];
                    baseInfo.name = devcieNameDic[@"name"];
                    callBack(baseInfo ,sn , RC_SUCCESS);
                }
                //设备固件更新
                else if ([[plDic allKeys] containsObject:[self replace:1]] || [[plDic allKeys] containsObject: [self replace:2]] || [[plDic allKeys] containsObject: [self replace:3]] || [[plDic allKeys] containsObject: [self replace:4]]) {
                    NSDictionary * devcieNameDic = [NSDictionary dictionary];
                    if ([self replace:1]) {
                        devcieNameDic = plDic[[self replace:1]];
                    }else if ([self replace:2]){
                        devcieNameDic = plDic[[self replace:2]];
                    }else if ([self replace:3]){
                        devcieNameDic = plDic[[self replace:3]];
                    }else if ([self replace:4]){
                        devcieNameDic = plDic[[self replace:4]];
                    }
                    HmRcDeviceBaseInfo * baseInfo = [[HmRcDeviceBaseInfo alloc]init];
                    baseInfo.CF = devcieNameDic[@"CF"];
                    baseInfo.TY = devcieNameDic[@"TY"];
                    callBack(baseInfo ,sn, RC_SUCCESS);
                }
                //红外学习功能
                else if ([[plDic allKeys] containsObject: GW_OID_LEARN]){
                    NSDictionary * dic = plDic[GW_OID_LEARN];
                    HMSendCodeModel * sendCodeModel = [[HMSendCodeModel alloc]init];
                    sendCodeModel.SC = (long)dic[@"SC"];
                    sendCodeModel.OD = dic[@"OD"];
                    sendCodeModel.zip = (long)dic[@"zip"];
                    sendCodeModel.code = dic[@"code"];
                    callBack(sendCodeModel,sn, RC_SUCCESS);
                }
                //虚拟设备发送红外码库
                else if ([[plDic allKeys] containsObject: GW_OID_VIRTUAL_DEVICE_SENDRC]){
                    NSDictionary * dic = plDic[GW_OID_VIRTUAL_DEVICE_SENDRC];
                    HMSendCodeModel * sendCodeModel = [[HMSendCodeModel alloc]init];
                    sendCodeModel.SC = (long)dic[@"SC"];
                    sendCodeModel.OD = dic[@"OD"];
                    callBack(sendCodeModel,sn, RC_SUCCESS);
                }
                //app获取温度
                else if ([[plDic allKeys] containsObject: GW_OID_GET_TEM]){
                    NSDictionary * dic = plDic[ GW_OID_GET_TEM];
                    HMTempModel * temp = [[HMTempModel alloc]init];
                    temp.TP= dic[@"TP"];
                    callBack(temp,sn, RC_SUCCESS);
                }
                //app设置温度阈值
                else if ([[plDic allKeys] containsObject: GW_OID_GETANDSET_TEMVALUE]){
                    NSDictionary * dic = plDic[ GW_OID_GETANDSET_TEMVALUE];
                    HMTempAlarmModel * temp = [[HMTempAlarmModel alloc]init];
                    temp.SC= (long)dic[@"SC"];
                    callBack(temp,sn, RC_SUCCESS);
                }
                //app设置定时时间指令
                else if ([[plDic allKeys] containsObject: GW_OID_GETANDSET_TEMVALUE]){
                    NSDictionary * dic = plDic[ GW_OID_GETANDSET_TEMVALUE];
                     HMRCTimer * timer = [[HMRCTimer alloc]init];
                    timer.SC= (long)dic[@"SC"];
                    callBack(timer,sn, RC_SUCCESS);
                }
                //创建码库成功与否
                else if ([[plDic allKeys] containsObject: GW_OID_CREATE_LOCAL_CODE ]){
                    NSDictionary * dic = plDic[GW_OID_CREATE_LOCAL_CODE ];
                    HMSendCodeModel * codeModel = [[HMSendCodeModel alloc]init];
                    codeModel.SC= (long)dic[@"SC"];
                    callBack(codeModel ,sn, RC_SUCCESS);
                }
                //删除码库成功与否
                else if ([[plDic allKeys] containsObject:GW_OID_DELETE_LOCAL_CODE]){
                    NSDictionary * dic = plDic[GW_OID_DELETE_LOCAL_CODE];
                    HMSendCodeModel * codeModel = [[HMSendCodeModel alloc]init];
                    codeModel.SC= (long)dic[@"SC"];
                    callBack(codeModel ,sn, RC_SUCCESS);
                }
                else{
                     callBack(nil ,sn,RC_UNKNOWN_ERROR);
                }
            }
                break;
               //数据主动上报
            case mibUpload :{
                if ([[plDic allKeys] containsObject:[self replace:1]] || [[plDic allKeys] containsObject: [self replace:2]] || [[plDic allKeys] containsObject: [self replace:3]] || [[plDic allKeys] containsObject: [self replace:4]]) {
                    NSDictionary * devcieNameDic = [NSDictionary dictionary];
                    if ([self replace:1]) {
                        devcieNameDic = plDic[[self replace:1]];
                    }else if ([self replace:2]){
                        devcieNameDic = plDic[[self replace:2]];
                    }else if ([self replace:3]){
                        devcieNameDic = plDic[[self replace:3]];
                    }else if ([self replace:4]){
                        devcieNameDic = plDic[[self replace:4]];
                    }
                    HmRcDeviceBaseInfo * baseInfo = [[HmRcDeviceBaseInfo alloc]init];
                    baseInfo.RT = devcieNameDic[@"RT"];
                    baseInfo.TY = devcieNameDic[@"TY"];
                    callBack(baseInfo ,sn, RC_SUCCESS);
                }
            }
                break;
            default:
                break;
        }
    }
}

//各类型固件升级的 OID
-(NSString *)replace:(NSInteger)dType{
    NSString * deType = [NSString stringWithFormat:@"%ld",(long)dType];
    NSString * oid = [GW_OID_OTA_UPDATE stringByReplacingOccurrencesOfString:@"x" withString:deType];
    return oid;
}
//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
