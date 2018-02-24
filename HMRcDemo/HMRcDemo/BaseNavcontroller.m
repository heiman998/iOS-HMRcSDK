//
//  BaseNavcontroller.m
//  MQTTHJ
//
//  Created by 研发ios工程师 on 2017/12/13.
//  Copyright © 2017年 研发ios工程师. All rights reserved.
//

#import "BaseNavcontroller.h"

@interface BaseNavcontroller ()

@end

@implementation BaseNavcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
    if (self.childViewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem.title = @"返回";
    }
}


@end
