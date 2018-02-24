//
//  HmSetNetViewController.m
//  HMRcDemo
//
//  Created by 研发ios工程师 on 2018/2/9.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "HmSetNetViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HmSmartLinkManager.h"
#import "MBProgressHUD.h"

@interface HmSetNetViewController ()

@property (weak, nonatomic) IBOutlet UITextField *WiFiName;
@property (weak, nonatomic) IBOutlet UITextField *WiFiPassWord;
@property (weak, nonatomic) IBOutlet UITextField *MacName;

@end

@implementation HmSetNetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.WiFiName.text = [self getWifiName];
    if(self.WiFiName.text){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.WiFiPassWord.text = [defaults objectForKey:@"WiFi_PassWord"];
    }
    NSString * macName = [[NSUserDefaults standardUserDefaults]objectForKey:@"wifi_devMac"];
    if (macName) {
        self.MacName.text = [NSString  stringWithFormat:@"旧mac地址:%@", macName];
    }
}


- (IBAction)setHost:(UIButton *)sender {
  
    NSInteger  deviceType = 0;
    if (sender.tag == 1) {
        deviceType  = HM_DEVICE_TYPE_WIFI_HS1GW;
    }else if (sender.tag == 2){
        deviceType = HM_DEVICE_TYPE_WIFI_INFRA_RED;
    }else{
        deviceType = HM_DEVICE_TYPE_WIFI_METERING_PLUGIN;
    }
    UIView *view = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在入网.....";
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.5f];
    hud.label.textColor = [UIColor blackColor];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[HmSmartLinkManager sharedManager] startWifiNetInWithDevType:deviceType wifiPassword:self.WiFiPassWord.text resultResponse:^(BOOL success, id responseObj) {
            NSLog(@"入网--%d---%@--",success,responseObj);
            if (success) {
                NSString * macName = [NSString stringWithFormat:@"%@",responseObj[@"devMac"]];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:macName  forKey:@"wifi_devMac"];
                [defaults synchronize]; dispatch_async(dispatch_get_main_queue(), ^{
                    self.MacName.text = [NSString  stringWithFormat:@"新mac地址:%@", macName];
                    [hud hideAnimated: YES];
                });
            }
        } outResponse:^(BOOL success, id responseObj) {
            NSLog(@"超时--%d---%@--",success,responseObj);
dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated: YES];
            });
        }];
    });
}




#pragma mark 获取当前 wifi_IP
- (NSString *)getWifiName
{
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {return nil;}
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSString * passWord = self.WiFiPassWord.text;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:passWord  forKey:@"WiFi_PassWord"];
    [defaults synchronize];
    [self.WiFiName resignFirstResponder];
    [self.WiFiPassWord resignFirstResponder];
    
}

@end
