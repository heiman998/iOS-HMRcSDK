//
//  HmCodeListViewController.m
//  HMRcDemo
//
//  Created by 研发ios工程师 on 2018/2/7.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "HmCodeListViewController.h"

@interface HmCodeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)NSInteger  devId;
@property (nonatomic, strong)NSString * region;
@property (nonatomic, assign)NSInteger brandId;
@property (nonatomic, strong)NSMutableArray * codeNum;

@end

@implementation HmCodeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)configureWithData:(id)data{
    
    self.devId = [data[@"devId"] intValue];
    self.region = data[@"region"];
    self.brandId = [data[@"brandId"] intValue];
    self.codeNum = [NSMutableArray array];
    UIView *view = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD * hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    [HmRcHttpRequest remotecGetCodeListBrandFullByRegion:self.region rcInfo:[[NSUserDefaults standardUserDefaults] objectForKey:@"HM_MacAndPakey_Info"]  deviceId:self.devId brandId:self.brandId response:^(NSInteger resultCode, NSString *resultDescription, NSDictionary *resultDict) {
        [resultDict[@"codeNum"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.codeNum addObject:[NSNumber numberWithInteger:[obj intValue]]];
        }];
        [hud hideAnimated:YES];
        [self.tableView reloadData];
    }];
}
#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.codeNum.count;
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
    cell.textLabel.text =  [NSString stringWithFormat:@"%@",self.codeNum[indexPath.row]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic =@{
                          @"devId"  : @(self.devId),
                          @"region" : self.region,
                          @"brandId": @(self.brandId),
                          @"codeNum": self.codeNum[indexPath.row]
                          };
    [self performSegueWithIdentifier:@"GetCodes" sender:dic];
}

@end
