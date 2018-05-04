//
//  HmSmartLink.h
//  HmSmartLink
//
//  Created by haimen_ios_imac on 2017/6/14.
//  Copyright © 2017年 深圳海曼科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HmLinkModel;

/**
 Smart Link error block
 
 @param error error
 */
typedef void(^SmartLinkError)(NSError *error);

/**
 Stop smart link block

 @param error error
 @param isSuccess success for stop smart link
 */
typedef void(^SmartLinkStop)(NSError *error, BOOL isSuccess);

/**
 Smart Link progress
 
 @param progress value for progress, float value
 */
typedef void(^SmartLinkProgress)(CGFloat progress);

/**
 Smart link single device success block

 @param device device for success
 */
typedef void(^SmartLinkSingleDeviceBlock)(HmLinkModel *device);

/**
 Smart link multi device block

 @param devices success devices array
 */
typedef void(^SmartLinkMultiDeviceBlock)(NSMutableArray *devices);

@interface HmSmartLink : NSObject

/**
 single instance method

 @return instance object
 */
+ (instancetype)sharedSmartLink;

/**
 Smart link TimeInterval，default 120 seconds
 */
@property (nonatomic, assign) NSTimeInterval smartInterval;

/**
 waitting for device start，default 10 seconds
 */
@property (nonatomic, assign) NSTimeInterval waitDeviceInterval;

/**
 Smart link single device, default is YES
 */
@property (nonatomic, assign, getter=isSmartSingleDevice) BOOL smartSingleDevice;

/**
 Smart link main method

 @param pass password for current WAN net
 @param progressBlock progress block
 @param errorBlock error block
 @param singleBlock smart link single device block
 @param multiBlock smart link multi device block
 */
- (void)startWithPassword:(NSString *)pass
                 progress:(SmartLinkProgress)progressBlock
                    error:(SmartLinkError)errorBlock
      singleDeviceSuccess:(SmartLinkSingleDeviceBlock)singleBlock
       multiDeviceSuccess:(SmartLinkMultiDeviceBlock)multiBlock;

/**
 Stop smart link method for hand

 @param stopBlock stop block
 */
- (void)stopSmartLinkResponse:(SmartLinkStop)stopBlock;

@end
