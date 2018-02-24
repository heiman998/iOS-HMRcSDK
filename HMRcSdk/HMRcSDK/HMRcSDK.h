//
//  HMRcSDK.h
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/2/1.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRcSDK : NSObject

/**
 初始化SDK
 
 @param userName 用户名
 @param userId   用户ID
 @return         初始化 成功：YES/ 失败：NO
 */
+ (BOOL)startHmRcSDKWithUserName:(NSString *)userName andUserId:(NSString *)userId;


@end
