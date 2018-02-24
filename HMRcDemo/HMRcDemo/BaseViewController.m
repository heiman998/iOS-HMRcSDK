//
//  BaseViewController.m
//  MQTTHJ
//
//  Created by huMac on 2017/12/13.
//  Copyright © 2017年 研发ios工程师. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property(copy, nonatomic)void (^lastBackBlock)(id data); 
@property(copy, nonatomic)void (^backBlock)(id data);

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIWindow*)window{
    return [UIApplication sharedApplication].keyWindow;
}

- (void)configureWithData:(id)data{
    NSLog(@"%@ 初始化...", NSStringFromClass([self class]));
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender completion:(void (^)(id data))completion{
    self.lastBackBlock = ^ void (id data) {
        if (completion!=nil) {
            completion(data);
        }
    };
    [self performSegueWithIdentifier:identifier sender:sender];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion sender:(id)sender backAction:(void (^)(id data))backAction{
    ((BaseViewController*)viewControllerToPresent).backBlock = ^ void (id data) {
        if (backAction!=nil) {
            backAction(data);
        }
    };
    [self presentViewController:viewControllerToPresent animated:flag completion:^{
        [viewControllerToPresent view];
        [viewControllerToPresent performSelector:@selector(configureWithData:) withObject:sender];
        if (completion) {
            completion();
        }
    }];
}

- (void)navPushViewController:(UIViewController *)viewControllerToPush animated:(BOOL)animated sender:(id)sender completion:(void (^)(id data))completion{
    ((BaseViewController*)viewControllerToPush).backBlock = ^ void (id data) {
        if (completion!=nil) {
            completion(data);
        }
    };
    [viewControllerToPush view];
    [viewControllerToPush performSelector:@selector(configureWithData:) withObject:sender];
    [self.navigationController pushViewController:viewControllerToPush animated:animated];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *ctl = [segue destinationViewController];
    if ([ctl respondsToSelector:@selector(configureWithData:)] && [ctl view]) {
        ((BaseViewController*)ctl).backBlock = self.lastBackBlock;
        self.lastBackBlock = nil;
        [ctl performSelector:@selector(configureWithData:) withObject:sender];
    }
}

- (void)completeWithData:(id)data{
    if (self.backBlock != nil) {
        self.backBlock(data);
    }
}


@end
