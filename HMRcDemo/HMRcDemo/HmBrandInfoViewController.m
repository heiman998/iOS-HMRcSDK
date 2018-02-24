//
//  HmBrandInfoViewController.m
//  HMRcDemo
//
//  Created by 研发ios工程师 on 2018/2/7.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "HmBrandInfoViewController.h"

@interface HmBrandInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (nonatomic, assign)NSInteger  devId;
@property (nonatomic, strong)NSString * region;
@property (nonatomic, strong)NSMutableArray * brandNameArr;
@property (nonatomic, strong)NSMutableArray * brandIdArr;
@property (nonatomic, strong)NSMutableArray * brandNameCNArr;
@end

@implementation HmBrandInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}
- (void)configureWithData:(id)data{
    self.region = data[@"region"];
    self.devId = [data[@"devId"] intValue];
    self.brandNameArr = [NSMutableArray array];
    self.brandIdArr = [NSMutableArray array];
    self.brandNameCNArr = [NSMutableArray array];
    UIView *view = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD * hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    [HmRcHttpRequest remotecGetSupportBrandByRegion:self.region rcInfo:[[NSUserDefaults standardUserDefaults] objectForKey:@"HM_MacAndPakey_Info"] deviceId:self.devId subRegion:nil brandx1:nil brandx2:nil response:^(NSInteger resultCode, NSString *resultDescription, NSDictionary *resultDict) {
       
        [resultDict[@"brandName"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self.brandNameArr addObject:obj];
            [self.brandIdArr  addObject:key];
        }];
        [resultDict[@"brandNameCN"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self.brandNameCNArr addObject:obj];
        }];        
        [self.tableView reloadData];
        [hud hideAnimated:YES];
    }];
}
#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.brandIdArr.count > 0) {
        return self.brandIdArr.count;
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
    if ([self.brandNameCNArr[indexPath.row] isEqual:[NSNull null]]) {
        cell.textLabel.text =  [NSString stringWithFormat:@"%@",self.brandNameArr[indexPath.row]];
    }else{
        cell.textLabel.text =  [NSString stringWithFormat:@"%@/%@",self.brandNameCNArr[indexPath.row],self.brandNameArr[indexPath.row]];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic =@{
                          @"devId"  :@(self.devId),
                          @"region" : self.region,
                          @"brandId": self.brandIdArr[indexPath.row]
                          };
    [self performSegueWithIdentifier:@"CodeList" sender:dic];
}

@end
