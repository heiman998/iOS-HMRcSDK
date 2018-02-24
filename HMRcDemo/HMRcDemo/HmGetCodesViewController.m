//
//  HmGetCodesViewController.m
//  HMRcDemo
//
//  Created by 研发ios工程师 on 2018/2/8.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "HmGetCodesViewController.h"

@interface HmGetCodesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)NSInteger  devId;
@property (nonatomic, strong)NSString * region;
@property (nonatomic, assign)NSInteger brandId;
@property (nonatomic, assign)NSInteger codeNum;
@end

@implementation HmGetCodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)configureWithData:(id)data{
    self.devId = [data[@"devId"] intValue];
    self.region = data[@"region"];
    self.brandId = [data[@"brandId"] intValue];
    self.codeNum = [data[@"codeNum"] intValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"获取所有按键";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"获取单个码库";
    }else if (indexPath.row == 2){
         cell.textLabel.text = @"获取所有码库";
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.textLabel.textColor = [UIColor redColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIView *view = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    if (indexPath.row == 0) {
//        所有按键
        [HmRcHttpRequest remotecGetMasterKeyForDeviceId:self.devId rcInfo:[[NSUserDefaults standardUserDefaults] objectForKey:@"HM_MacAndPakey_Info"]  response:^(NSInteger resultCode, NSString *resultDescription, NSDictionary *resultDict) {
            NSLog(@"resultDict::::::::::%@",resultDict);
            [hud hideAnimated:YES];
        }];
    }else if (indexPath.row == 1){
//        单个码库
        [HmRcHttpRequest remotecGetSupportedKeyByRegion:self.region rcInfo:[[NSUserDefaults standardUserDefaults] objectForKey:@"HM_MacAndPakey_Info"] deviceId:self.devId codeNum:self.codeNum response:^(NSInteger resultCode, NSString *resultDescription, NSDictionary *resultDict) {
            NSLog(@"resultDict::::::::::%@",resultDict);
            [hud hideAnimated:YES];
        }];
    }else if (indexPath.row == 2){
//        所有码库
        [HmRcHttpRequest remotecGetIrDataCodeByRegion:self.region rcInfo:[[NSUserDefaults standardUserDefaults] objectForKey:@"HM_MacAndPakey_Info"]  deviceId:self.devId codeNum:self.codeNum response:^(NSInteger resultCode, NSString *resultDescription, NSDictionary *resultDict) {
            NSLog(@"resultDict::::::::::%@",resultDict);
            [hud hideAnimated:YES];
        }];
    }
}

@end
