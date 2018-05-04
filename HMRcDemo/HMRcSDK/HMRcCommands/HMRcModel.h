//
//  HMRcModel.h
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/2/1.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enum.h"

@interface HMRcModel : NSObject

/**
 公钥
 */
@property (nonatomic, copy)   NSString * acckey;
/**
 私钥
 */
@property (nonatomic, copy)   NSString * aeskey;


@end
