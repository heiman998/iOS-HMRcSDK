//
//  HMRcSDK.m
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/2/1.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "HMRcSDK.h"
#import "HmUtils.h"

@implementation HMRcSDK

+ (BOOL)startHmRcSDKWithUserName:(NSString *)userName andUserId:(NSString *)userId{
    
    if ([HmUtils isEmptyString:userName] || [HmUtils isEmptyString:userId]) {
        return NO;
    }else{
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userName forKey:@"HM_Rc_userName"];
        [defaults setObject:userId forKey:@"HM_Rc_userId"];
        [defaults synchronize];
        return YES;
    }
}

@end
