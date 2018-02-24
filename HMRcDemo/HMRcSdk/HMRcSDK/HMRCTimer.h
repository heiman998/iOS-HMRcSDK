//
//  HMRCTimer.h
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/2/3.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRCTimer : NSObject

@property (nonatomic, assign)NSInteger wf; //使能位BIT7；WFu,bit0-bit6为周一至周日bit7 定时器使能定时器单次功能与周期功能是二选一，bit0-bit6都是0为单次，否则为周期，周期月、日无效

/**
 开始月日时分
 */
@property (nonatomic, assign)NSInteger  smonth;
@property (nonatomic, assign)NSInteger  sday;
@property (nonatomic, assign)NSInteger  shour;
@property (nonatomic, assign)NSInteger  sminutes;

/**
 结束月日时分
 */
@property (nonatomic, assign)NSInteger  emonth;
@property (nonatomic, assign)NSInteger  eday;
@property (nonatomic, assign)NSInteger  ehour;
@property (nonatomic, assign)NSInteger  eminutes;

/**
 设置定时器时 0为不成功  1为成功。成功后返回code不成功返回。默认0 (设置成功/失败)
 */
@property (nonatomic, assign)NSInteger SC;

/**
 开始码库
 */
@property (nonatomic, strong)NSString  * codeS;

/**
 结束码库
 */
@property (nonatomic, strong)NSString  * codeE;

@end
