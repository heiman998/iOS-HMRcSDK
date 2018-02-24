//
//  HmRcHttpRequest.h
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/1/31.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark ----------------------http 返回码--------------

extern NSInteger const RemotecCode_success;
extern NSInteger const RemotecCode_invalidLogin;
extern NSInteger const RemotecCode_accountSuspended;
extern NSInteger const RemotecCode_accountExpired;
extern NSInteger const RemotecCode_notAllowedFunctionCall;
extern NSInteger const RemotecCode_parametersError;
extern NSInteger const RemotecCode_paKeyMissing;
extern NSInteger const RemotecCode_paKeyIsNotAllowed;
extern NSInteger const RemotecCode_serverBusy;
extern NSInteger const RemotecCode_invalidFunctionCall;

#pragma mark ====== 红外设备赋 MAC 及 PA_KEY KEY ======
extern NSString *const RcCurrentMacAddress;
extern NSString *const RcCurrentPaKey;

extern NSString *const remotec_pa_key;

typedef void(^RcHttpRequestCallBackBlock)(NSInteger resultCode, NSString *resultDescription, NSDictionary *resultDict);

typedef NS_ENUM(NSInteger, RemotecDeviceType) {
    
    RemotecDeviceTypeAV, //AV device
    RemotecDeviceTypeAC //AC device
};
@interface HmRcHttpRequest : NSObject
/**
 回调block
 */
@property (nonatomic, copy)  RcHttpRequestCallBackBlock callBackBlock;
/**
 {
 "pa_key" =     {
 0 = 67TFUWQ8YW;
 };
 }
 Remotec 909 function: Request paKey for RC entity
 @param rcInfo  rc MAC by rcInfo
 @param responseBlock callBack block
 */
+ (void)remotecGetPaKeyByRcInfo:(NSDictionary *)rcInfo
                       response:(RcHttpRequestCallBackBlock)responseBlock;
/**
 To get the available regions of code library supported. IR Code library is consolidated for each of region market, host needs to know how many region it supported for preparing appropriate user interface for code selection.
 获得支持的代码库的可用区域。对于每个区域市场的IR代码库都是统一的，主机需要知道它支持多少区域来为代码选择准备合适的用户界面。
 @param responseBlock callBack block
 {
 "result_code": 1,
 "result_des": "Request Processed", "result_data": {
 "region": {
 "0": "GLOBAL"
 } }
 }
 */

+ (void)remotecGetSupportedRegionWithRcInfo:(NSDictionary *)rcInfo response:(RcHttpRequestCallBackBlock)responseBlock ;

/**
 To get the available device category of code library supported.
 @param region the region of supported
 @param responseBlock callBack block
 deviceName15 List<String> Suggested name of device category (max. 15 characters)
 deviceName30 List<String> Suggested name of device category (max. 30 characters)
 Comment List<String> Additional description
 deviceNameCN Suggested name of device category (in Chinese)
 */
+ (void)remotecGetSupportedDeviceByRegion:(NSString *)region
                                   rcInfo:(NSDictionary *)rcInfo
                                 response:(RcHttpRequestCallBackBlock)responseBlock;

/**
 To get the major brand list, this list help user to choose a short list of major brand or common brand in a quick way instead of browse the brand list from A to Z.

 @param region supported region
 @param devId device id
 @param responseBlock callBack block
 brandName List<String> Brand name in English
 brandNameCN List<String> Brand name in Chinese
 brandNameZH List<String> Brand name in Traditional Chinese
 */

+ (void)remotecGetSupportBrandByRegion:(NSString *)region
                                rcInfo:(NSDictionary *)rcInfo
                              deviceId:(NSInteger)devId
                             subRegion:(NSString *)subRegion
                               brandx1:(NSString *)brandx1
                               brandx2:(NSString *)brandx2
                              response:(RcHttpRequestCallBackBlock)responseBlock;

/**
 To get the full code list of selected device category and brand, this is full codelist for Remoteble code library..

 @param region supported region
 @param devId device id
 @param brandId brand id
 @param responseBlock callBack block
 */
+ (void)remotecGetCodeListBrandFullByRegion:(NSString *)region
                                     rcInfo:(NSDictionary *)rcInfo
                                   deviceId:(NSInteger)devId
                                    brandId:(NSInteger)brandId
                                   response:(RcHttpRequestCallBackBlock)responseBlock;

/**
 To get the full code list of selected device category and brand, this is full codelist for Remoteble code library..

 @param region supported region
 @param devId device id
 @param brandId brand id
 @param responseBlock callBack block
 */
+ (void)remotecGetCodeListBrandQuickByRegion:(NSString *)region
                                     rcInfo:(NSDictionary *)rcInfo
                                   deviceId:(NSInteger)devId
                                    brandId:(NSInteger)brandId
                                   response:(RcHttpRequestCallBackBlock)responseBlock;
/**
 To get the supported key list for a selected code.

 @param region suported region
 @param devId device id
 @param codeNum Code set number of IR code
 @param responseBlock callBack block
 */
+ (void)remotecGetSupportedKeyByRegion:(NSString *)region
                                rcInfo:(NSDictionary *)rcInfo
                              deviceId:(NSInteger)devId
                               codeNum:(NSInteger)codeNum
                              response:(RcHttpRequestCallBackBlock)responseBlock;
/**
 To get master key support in all devices. This is the maximum list of function keys, new key maybe added to the end of list of reserved location in future update, but it should be backward compatible.
 
 @param devId Equipment device ID number
 @param responseBlock callBack block
 */
+ (void)remotecGetMasterKeyForDeviceId:(NSInteger)devId
                                rcInfo:(NSDictionary *)rcInfo
                              response:(RcHttpRequestCallBackBlock)responseBlock;

/**
 To get brand information such as brand id and brand name according to the input PNP ID.
 This function ID is for AV device only
 
 @param id_type Fixed constant on this field
 @param id_value PNP Vendor IDs consist of 3 characters, each character being an uppercase letter (A-Z).
 @param responseBlock callBack block
 */
+ (void)remotecGetBrandIdByIdType:(NSString *)id_type
                           rcInfo:(NSDictionary *)rcInfo
                          idValue:(NSString *)id_value
                         response:(RcHttpRequestCallBackBlock)responseBlock;


/**
 To get the subregion of the target device ID, this list helps user to choose a short list of brand after functionID 3.

 @param region Region of the IR code library
 @param devId Equipment device ID number
 @param responseBlock callBack block
 */
+ (void)remotectGetsubRegionForRegion:(NSString *)region
                               rcInfo:(NSDictionary *)rcInfo
                             deviceId:(NSInteger)devId
                             response:(RcHttpRequestCallBackBlock)responseBlock;

/**
 To get the device model nunber list. This list help user to choose a short list of model number in a quick way instead of browse the code number list

 @param region Region of the IR code library
 @param devId Equipment device ID number
 @param brandId Equipment brand name ID number
 @param responseBlock callBack block
 */
+ (void)remotecGetModelNumForRegion:(NSString *)region
                             rcInfo:(NSDictionary *)rcInfo
                           deviceId:(NSInteger)devId
                            brandId:(NSInteger)brandId
                           response:(RcHttpRequestCallBackBlock)responseBlock;


/**
 Get full IR data of all keys for selected code. For data protection, there are some access controls for this command, when it detects abnormal access, such as batch data dump, robot behavior etc., a user account maybe locked by the system.

 @param region Region of the IR code library
 @param devId Equipment device ID number
 @param codeNum Code set number of IR code
 @param responseBlock callBack block
 */
+ (void)remotecGetIrDataCodeByRegion:(NSString *)region
                              rcInfo:(NSDictionary *)rcInfo
                            deviceId:(NSInteger)devId
                             codeNum:(NSInteger)codeNum
                            response:(RcHttpRequestCallBackBlock)responseBlock;




@end
