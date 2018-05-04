//
//  HmRcHttpRequest.m
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/1/31.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "HmRcHttpRequest.h"
#import "AFNetworking.h"
#import "GTMBase64.h"
#import "AES256Encryption.h"
#pragma mark ====== RESPONSE CODE KEY ======
NSInteger const RemotecCode_success             = 1;
NSInteger const RemotecCode_invalidLogin        = -701;
NSInteger const RemotecCode_accountSuspended    = -702;
NSInteger const RemotecCode_accountExpired      = -703;
NSInteger const RemotecCode_notAllowedFunctionCall  = -704;
NSInteger const RemotecCode_parametersError         = -705;
NSInteger const RemotecCode_paKeyMissing            = -706;
NSInteger const RemotecCode_paKeyIsNotAllowed       = -707;
NSInteger const RemotecCode_serverBusy              = -801;
NSInteger const RemotecCode_invalidFunctionCall     = -999;

#pragma mark url
NSString *const remotec_url_string = @"https://212.remoteble.com/c1/call.php";
//@"https://166.remoteble.com/c1/call.php";

#pragma mark http method key
NSString *const RC_HTTP_POST = @"POST";
NSString *const RC_HTTP_GET = @"GET";
NSString *const RC_HTTP_PUT = @"PUT";
NSString *const RC_HTTP_DELETE = @"DELETE";

#pragma mark ====== Params VALUE ======
NSString *const remotec_user_pwd        = @"heiman212";
NSString *const remotec_project_code    = @"Heiman_212";
NSString *const remotec_customer_code   = @"Heiman";
NSString *const remotec_aes_256_cbc     = @"aes-256-cbc";
NSString *const remotec_prefix          = @"HEIMAN___212___0_HM_";

//固定密码 ：user_pwd = "heiman212"
//project_code = "Heiman_212"
//customer_code = "Heiman"
//固定字段增加："auth_cipher", "aes-256-cbc"
//前20位秘钥：    HEIMAN___212___0_HM_

#pragma mark region key
NSString *const remotec_region_US       = @"US";
NSString *const remotec_region_EU       = @"EU";
NSString *const remotec_region_ASIA     = @"ASIA";
NSString *const remotec_region_JP       = @"JP";
NSString *const remotec_region_GLOBAL   = @"GLOBAL";

#pragma mark deviceId key
NSString *const remotec_deviceId_AC = @"0";
NSString *const remotec_deviceId_TV = @"1";
NSString *const remotec_deviceId_DVD = @"5";
NSString *const remotec_deviceId_AUD = @"6";
NSString *const remotec_deviceId_CD = @"7";
NSString *const remotec_deviceId_STREAMING = @"11";

#pragma mark param key
NSString *const param_function_id   = @"function_id";
NSString *const param_user_email    = @"user_email";
NSString *const param_user_pwd      = @"user_pwd";
NSString *const param_auth_cipher   = @"auth_cipher";

NSString *const param_user_fullname = @"user_fullname";
NSString *const param_user_company  = @"user_company";
NSString *const param_user_region   = @"user_region";
NSString *const param_user_hwid     = @"user_hwid";

NSString *const param_auth_code     = @"auth_code";
NSString *const param_User_new_pwd  = @"User_new_pwd";

//the imei number of phone
NSString *const param_imei = @"imei";
//Provided by remoteable
NSString *const param_pa_key = @"pa_key";
NSString *const param_project_code = @"project_code";
NSString *const param_customer_code = @"customer_code";
//the regional area of IR code
NSString *const param_region = @"region";
NSString *const param_subRegion = @"subRegion";
//ID number of equipment device category
NSString *const param_deviceId = @"deviceId";
NSString *const param_brandx1 = @"brandx1";
NSString *const param_brandx2 = @"brandx2";
NSString *const param_brandId = @"brandId";
//It is code set number in code library, this number contains a set of function key and corresponding IR data equivalent as a single remote.
NSString *const param_codeNum = @"codeNum";
NSString *const param_keyId = @"keyId";
NSString *const param_s0 = @"s0";
NSString *const param_s1 = @"s1";
NSString *const param_s2 = @"s2";
NSString *const param_s3 = @"s3";
NSString *const param_devModelNum = @"devModelNum";
NSString *const param_remoteModelNum = @"remoteModelNum";
NSString *const param_start = @"start";
NSString *const param_limit = @"limit";
NSString *const param_id_type = @"id_type";
NSString *const param_id_value = @"id_value";

NSString *const param_stPower = @"stPower";
NSString *const param_stMode = @"stMode";
NSString *const param_stTemp = @"stTemp";
NSString *const param_stFan = @"stFan";
NSString *const param_stSwing = @"stSwing";

NSString *const response_result_code = @"result_code";
NSString *const response_result_des = @"result_des";
NSString *const response_result_data = @"result_data";

#pragma mark ====== 设置RC MAC及PAKEY字典值 ======
NSString *const RcCurrentMacAddress = @"RcCurrentMacAddress";
NSString *const RcCurrentPaKey = @"RcCurrentPaKey";
NSString *const remotec_pa_key = @"pa_key";

@interface HmRcHttpRequest ()
/**
 RC红外扩展字典对象
 */
@property (nonatomic, strong) NSDictionary *rcEntityInfoDictionary;

@end

@implementation HmRcHttpRequest

- (instancetype)initWithCallBack:(RcHttpRequestCallBackBlock)callBackBlock
{
    if (self = [super init]) {
        self.callBackBlock = callBackBlock;
    }
    return self;
}

- (AFHTTPSessionManager *)getAfnManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    return manager;
}

- (void)request:(NSString *)url
params:(NSDictionary *)params
requestMethod:(NSString *)method
{
    AFHTTPSessionManager *manager = [self getAfnManager];
    NSString *urlString = nil;
    if ([url rangeOfString:@"http"].location != NSNotFound) {
        urlString = url;
    } else {
        urlString = url;
    }
    
    //    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    //    NSString *str = [[NSString alloc] initWithData:data
    //                                          encoding:NSUTF8StringEncoding];
    //    NSString *postLength = [NSString stringWithFormat:@"%lu", [str length]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:urlString parameters:params error:nil];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!responseObject) return;
        
        id responseValue = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (responseValue && [responseValue isKindOfClass:[NSDictionary class]]) {
            
            NSInteger resultCode = [[responseValue objectForKey:response_result_code] integerValue];
            NSString *resultDescription = [responseValue objectForKey:response_result_des];
            NSDictionary *resultData = [responseValue objectForKey:response_result_data];
            if (self.callBackBlock) self.callBackBlock(resultCode, resultDescription, resultData);
        }
    }];
    [task resume];
}

+ (void)remotecGetPaKeyByRcInfo:(NSDictionary *)rcInfo response:(RcHttpRequestCallBackBlock)responseBlock
{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSDictionary *dict = [req getPaProjectCustomerDict:NO];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params setObject:@(909) forKey:param_function_id];
    [params addEntriesFromDictionary:dict];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}

+ (void)remotecGetSupportedRegionWithRcInfo:(NSDictionary *)rcInfo response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSDictionary *dict = [req getPaProjectCustomerDict:YES];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params setObject:@(1) forKey:param_function_id];
    [params addEntriesFromDictionary:dict];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}

+ (void)remotecGetSupportedDeviceByRegion:(NSString *)region
                                   rcInfo:(NSDictionary *)rcInfo
                                 response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(2) forKey:param_function_id];
    if (region) [params setObject:region forKey:param_region];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}

//获取选定地区，选定产品ID常用品牌
+ (void)remotecGetBrandMajorByRegion:(NSString *)region
                              rcInfo:(NSDictionary *)rcInfo
                            deviceId:(NSInteger)devId
                            response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(4) forKey:param_function_id];
    [params setObject:@(devId) forKey:param_deviceId];
    if (region) [params setObject:region forKey:param_region];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}


+ (void)remotecGetSupportBrandByRegion:(NSString *)region
                                rcInfo:(NSDictionary *)rcInfo
                              deviceId:(NSInteger)devId
                             subRegion:(NSString *)subRegion
                               brandx1:(NSString *)brandx1
                               brandx2:(NSString *)brandx2
                              response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(3) forKey:param_function_id];
    [params setObject:@(devId) forKey:param_deviceId];
    if (region) [params setObject:region forKey:param_region];
    if (subRegion) [params setObject:subRegion forKey:param_subRegion];
    if (brandx1) [params setObject:brandx1 forKey:param_brandx1];
    if (brandx2) [params setObject:brandx2 forKey:param_brandx2];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}

//To get the full code list of selected device category and brand, this is full codelist for Remoteble code library..
//为了获得所选设备类别和品牌的完整代码列表，这是可移动代码库的完整代码。
+ (void)remotecGetCodeListBrandFullByRegion:(NSString *)region
                                     rcInfo:(NSDictionary *)rcInfo
                                   deviceId:(NSInteger)devId
                                    brandId:(NSInteger)brandId
                                   response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(5) forKey:param_function_id];
    [params setObject:@(devId) forKey:param_deviceId];
    if (region) [params setObject:region forKey:param_region];
    [params setObject:@(brandId) forKey:param_brandId];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}

//To get the code list of selected device category and brand for quick search, this is codelist for consolidated code from Remotec code library, it is used for Quick Search Setup.
//为快速搜索获得所选设备类别和品牌的代码列表，这是来自Remotec代码库的统一代码的代码库，用于快速搜索设置。
+ (void)remotecGetCodeListBrandQuickByRegion:(NSString *)region
                                     rcInfo:(NSDictionary *)rcInfo
                                   deviceId:(NSInteger)devId
                                    brandId:(NSInteger)brandId
                                   response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(6) forKey:param_function_id];
    if (region) [params setObject:region forKey:param_region];
    [params setObject:@(devId) forKey:param_deviceId];
    [params setObject:@(brandId) forKey:param_brandId];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}


//To get the supported key list for a selected code.
//获取所选代码的支持键列表。
+ (void)remotecGetSupportedKeyByRegion:(NSString *)region
                                rcInfo:(NSDictionary *)rcInfo
                              deviceId:(NSInteger)devId
                               codeNum:(NSInteger)codeNum
                              response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(7) forKey:param_function_id];
    if (region) [params setObject:region forKey:param_region];
    [params setObject:@(devId) forKey:param_deviceId];
    [params setObject:@(codeNum) forKey:param_codeNum];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}


//To get master key support in all devices. This is the maximum list of function keys, new key maybe added to the end of list of reserved location in future update, but it should be backward compatible.
//在所有设备中获得主键支持。这是功能键的最大列表，新键可能会在以后的更新中添加到预留位置列表的末尾，但是它应该是向后兼容的。

+ (void)remotecGetMasterKeyForDeviceId:(NSInteger)devId
                                rcInfo:(NSDictionary *)rcInfo
                              response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(8) forKey:param_function_id];
    [params setObject:@(devId) forKey:param_deviceId];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}


//To get the code list with higher accuracy by inputting selected device category, brand, key ID and also input IR signal.
////通过输入选定的设备类别、品牌、密钥ID和输入红外信号，获得更高精度的代码列表。
+ (void)remotecGetCodeListSignatureByRegion:(NSString *)region
                                     rcInfo:(NSDictionary *)rcInfo
                                   deviceId:(NSInteger)devId
                                    brandId:(NSInteger)brandId
                                      keyId:(NSInteger)keyId
                                         s0:(NSInteger)s0
                                         s1:(NSInteger)s1
                                         s2:(NSInteger)s2
                                         s3:(NSString *)s3
                                   response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(10) forKey:param_function_id];
    if (region) [params setObject:region forKey:param_region];
    [params setObject:@(devId) forKey:param_deviceId];
    [params setObject:@(brandId) forKey:param_brandId];
    [params setObject:@(keyId) forKey:param_keyId];
    
    [params setObject:@(s0) forKey:param_s0];
    [params setObject:@(s1) forKey:param_s1];
    [params setObject:@(s2) forKey:param_s2];
    if (s3) [params setObject:s3 forKey:param_s3];
    
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}

//Get code number information from inputting the model number of equipment device or the model number of the remote control.
//从输入设备设备型号或远程控制的型号数量获得编码信息。
+ (void)remotecGetCodeListBrandModelByRegion:(NSString *)region
                                      rcInfo:(NSDictionary *)rcInfo
                                    deviceId:(NSInteger)devId
                                     brandId:(NSInteger)brandId
                                 devModelNum:(NSString *)devModelNum
                              remoteModelNum:(NSString *)remoteModelNum
                                     brandx1:(NSString *)brandx1
                                     brandx2:(NSString *)brandx2
                                       start:(NSInteger)start
                                       limit:(NSInteger)limit
                                    response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(11) forKey:param_function_id];
    [params setObject:region forKey:param_region];
    [params setObject:@(devId) forKey:param_deviceId];
    [params setObject:@(brandId) forKey:param_brandId];
    if (devModelNum) [params setObject:devModelNum forKey:param_devModelNum];
    if (remoteModelNum) [params setObject:remoteModelNum forKey:param_remoteModelNum];
    if (brandx1) [params setObject:brandx1 forKey:param_brandx1];
    if (brandx2) [params setObject:brandx2 forKey:param_brandx2];
    if (start > 0 || limit > 0) {
        [params setObject:@(start) forKey:param_start];
        [params setObject:@(limit) forKey:param_limit];
    }
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}

//To get brand information such as brand id and brand name according to the input PNP ID.
//This function ID is for AV device only
+ (void)remotecGetBrandIdByIdType:(NSString *)id_type
                           rcInfo:(NSDictionary *)rcInfo
                          idValue:(NSString *)id_value
                         response:(RcHttpRequestCallBackBlock)responseBlock{
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(12) forKey:param_function_id];
    if (id_type) [params setObject:id_type forKey:param_id_type];
    if (id_value) [params setObject:id_value forKey:param_id_value];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}

//To get the subregion of the target device ID, this list helps user to choose a short list of brand after functionID 3.
+ (void)remotectGetsubRegionForRegion:(NSString *)region
                               rcInfo:(NSDictionary *)rcInfo
                             deviceId:(NSInteger)devId
                             response:(RcHttpRequestCallBackBlock)responseBlock{
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(13) forKey:param_function_id];
    if (region) [params setObject:region forKey:param_region];
    [params setObject:@(devId) forKey:param_deviceId];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}


+ (void)remotecGetModelNumForRegion:(NSString *)region
                              rcInfo:(NSDictionary *)rcInfo
                            deviceId:(NSInteger)devId
                             brandId:(NSInteger)brandId
                            response:(RcHttpRequestCallBackBlock)responseBlock{
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(14) forKey:param_function_id];
    if (region) [params setObject:region forKey:param_region];
    [params setObject:@(devId) forKey:param_deviceId];
    [params setObject:@(brandId) forKey:param_brandId];
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}

//Get an IR data of a key for selected code. For data protection, there are some access controls for this command, when it detects abnormal access, such as batch data dump, robot behavior etc., a user account maybe locked by the system.
+ (void)remotecGetIrDataKeyDeviceType:(RemotecDeviceType)dType
                               region:(NSString *)region
                               rcInfo:(NSDictionary *)rcInfo
                             deviceId:(NSInteger)devId
                              codeNum:(NSInteger)codeNum
                                keyId:(NSInteger)keyId
                              stPower:(NSString *)stPower
                               stMode:(NSString *)stMode
                               stTemp:(NSInteger)stTemp
                                stFan:(NSString *)stFan
                              stSwing:(NSString *)stSwing
                             response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(501) forKey:param_function_id];
    if (region) [params setObject:region forKey:param_region];
    [params setObject:@(devId) forKey:param_deviceId];
    [params setObject:@(codeNum) forKey:param_codeNum];
    [params setObject:@(keyId) forKey:param_keyId];
    
    if (dType == RemotecDeviceTypeAC) {
        
        if (stPower) [params setObject:stPower forKey:param_stPower];
        if (stMode) [params setObject:stMode forKey:param_stMode];
        [params setObject:@(stTemp) forKey:param_stTemp];
        if (stFan) [params setObject:stFan forKey:param_stFan];
        if (stSwing) [params setObject:stSwing forKey:param_stSwing];
    }
    
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}

//Get full IR data of all keys for selected code. For data protection, there are some access controls for this command, when it detects abnormal access, such as batch data dump, robot behavior etc., a user account maybe locked by the system.
////获取所选代码的所有键的完整IR数据。对于数据保护，当它检测到异常访问时(比如批量数据转储、机器人行为等)，就会对该命令进行一些访问控制，这可能是系统锁定的用户帐户。
+ (void)remotecGetIrDataCodeByRegion:(NSString *)region
                              rcInfo:(NSDictionary *)rcInfo
                            deviceId:(NSInteger)devId
                             codeNum:(NSInteger)codeNum
                            response:(RcHttpRequestCallBackBlock)responseBlock{
    if ([rcInfo isKindOfClass:[NSNull class]])return;
    if (region.length == 0) return;
    HmRcHttpRequest *req = [[HmRcHttpRequest alloc] initWithCallBack:responseBlock];
    req.rcEntityInfoDictionary = [rcInfo copy];
    NSMutableDictionary *params = [@{} mutableCopy];
    [params addEntriesFromDictionary:[req getPaProjectCustomerDict:YES]];
    [params setObject:@(502) forKey:param_function_id];
    if (region) [params setObject:region forKey:param_region];
    [params setObject:@(devId) forKey:param_deviceId];
    [params setObject:@(codeNum) forKey:param_codeNum];
    
    [req request:remotec_url_string
          params:[params copy]
   requestMethod:RC_HTTP_POST];
}


#pragma mark 获取PA，ProjectCode，CustomerCode字典
- (NSDictionary *)getPaProjectCustomerDict:(BOOL)isPaKey
{
    NSMutableDictionary *params = [@{} mutableCopy];
    NSDictionary *userDict = [self encryptUserAccount];
    //user account
    if ([userDict objectForKey:REMOTEC_ENCRYPT_ACCOUNT] &&
        [userDict objectForKey:REMOTEC_ENCRYPT_PASSWORD]) {
        [params setObject:[userDict objectForKey:REMOTEC_ENCRYPT_ACCOUNT] forKey:param_user_email];
        [params setObject:[userDict objectForKey:REMOTEC_ENCRYPT_PASSWORD] forKey:param_user_pwd];
    } else {
        return @{};
    }
    //pa_key
    if (isPaKey && [_rcEntityInfoDictionary objectForKey:RcCurrentPaKey]) {
        
        [params setObject:[_rcEntityInfoDictionary objectForKey:RcCurrentPaKey] forKey:param_pa_key];
    }
    [params setObject:remotec_project_code forKey:param_project_code];
    [params setObject:remotec_customer_code forKey:param_customer_code];
    [params setObject:remotec_aes_256_cbc forKey:param_auth_cipher];
    
    return [params copy];
}

NSString *const REMOTEC_ENCRYPT_ACCOUNT = @"R_ACCOUNT";
NSString *const REMOTEC_ENCRYPT_PASSWORD = @"R_PASSWORD";
static NSString *const SuffixOfHeimanEmail = @"@heiman.com";

- (NSDictionary *)encryptUserAccount
{
    NSString *rcMac = [_rcEntityInfoDictionary objectForKey:RcCurrentMacAddress];
    if (!rcMac) return @{};
    NSString *account = [NSString stringWithFormat:@"%@%@", rcMac, SuffixOfHeimanEmail];
    //@"A020A62D2632@heiman.com";
    NSString *pass = remotec_user_pwd;
    NSArray *user = @[account, pass];
    NSDate *date = [NSDate date];
    NSMutableDictionary *encryptUserDict = [@{} mutableCopy];
    for (long i = 0; i < user.count; i ++) {
        NSString *encryStr = [self encryptUserInfo:[user objectAtIndex:i] date:date];
        if (!encryStr) continue;
        if (i == 0) {
            [encryptUserDict setObject:encryStr forKey:REMOTEC_ENCRYPT_ACCOUNT];
        } else {
            [encryptUserDict setObject:encryStr forKey:REMOTEC_ENCRYPT_PASSWORD];
        }
    }
    return [encryptUserDict copy];
}

- (NSString *)encryptUserInfo:(NSString *)info date:(NSDate *)date
{
    if (!info) return nil;
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    Byte bytes[16];
    for (int i = 0; i < 16; i ++) {
        bytes[i] = arc4random() % 256;
    }
    NSData *temp_ivd = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    NSData *ivd = [GTMBase64 encodeData:temp_ivd];
    NSString *iv = [[NSString alloc] initWithData:ivd encoding:NSUTF8StringEncoding];
    NSData *temp = [AES256Encryption AES256EncryptWithKey:[AES256Encryption getKey] data:data iv:bytes encryptOrDecrypt:kCCEncrypt];

    // The encrypted data(tempStr) append to iv
    NSString *tempStr= [[NSString alloc] initWithData:temp encoding:NSUTF8StringEncoding];
    tempStr = [NSString stringWithFormat:@"%@%@", iv, tempStr];
    return tempStr;
}



@end

