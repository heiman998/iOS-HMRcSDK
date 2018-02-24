//
//  HmDeviceTypeViewController.m
//  HMRcDemo
//
//  Created by 研发ios工程师 on 2018/2/7.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "HmDeviceTypeViewController.h"

@interface HmDeviceTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray * arrCore;
@property (nonatomic, strong)NSMutableArray * cnCore;
@property (nonatomic, strong)NSString *  region;
@property (nonatomic, strong)NSMutableArray * deviceIdCore;

@end

@implementation HmDeviceTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)configureWithData:(id)data{
    self.region = data;
    self.arrCore = [NSMutableArray array];
    self.cnCore = [NSMutableArray array];
    self.deviceIdCore = [NSMutableArray array];
    UIView *view = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD * hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"emmmm......";
    hud.label.textColor = [UIColor blackColor];

    [HmRcHttpRequest remotecGetSupportedDeviceByRegion:self.region rcInfo:[[NSUserDefaults standardUserDefaults] objectForKey:@"HM_MacAndPakey_Info"] response:^(NSInteger resultCode, NSString *resultDescription, NSDictionary *resultDict) {
        if (resultCode == 1) {
            [resultDict[@"deviceName15"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [self.arrCore addObject:obj];
                [self.deviceIdCore addObject:key];
            }];
            [resultDict[@"deviceNameCN"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [self.cnCore addObject:obj];
            }];
        }
        [self.tableView reloadData];
        [hud hideAnimated:YES];
    }];
}
#pragma mark Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if (self.arrCore.count > 0) {
          return self.arrCore.count;
    }else{
        return 0;
    }
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
    if ([self.cnCore[indexPath.row] isEqual:[NSNull null]]) {
        cell.textLabel.text =  [NSString stringWithFormat:@"%@",self.arrCore[indexPath.row]];
    }else{
         cell.textLabel.text =  [NSString stringWithFormat:@"%@/%@",self.cnCore[indexPath.row],self.arrCore[indexPath.row]];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic =@{
                          @"devId"  : self.deviceIdCore[indexPath.row],
                          @"region" : self.region
                          };
    [self performSegueWithIdentifier:@"BrandInfo" sender:dic];
}

@end
