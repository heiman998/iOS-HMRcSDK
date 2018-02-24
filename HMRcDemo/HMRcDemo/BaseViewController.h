//
//  BaseViewController.h
//  MQTTHJ
//
//  Created by huMac on 2017/12/13.
//  Copyright © 2017年 研发ios工程师. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "HmRcHttpRequest.h"

@interface BaseViewController : UIViewController


@property(nonatomic,readonly)UIWindow *window;

-(void)configureWithData:(id)data;
-(void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender completion:(void (^)(id data))completion;
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion sender:(id)sender backAction:(void (^)(id data))backAction;
-(void)navPushViewController:(UIViewController *)viewControllerToPush animated:(BOOL)animated sender:(id)sender completion:(void (^)(id data))completion;
-(void)completeWithData:(id)data;

@end
