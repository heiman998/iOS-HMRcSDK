//
//  HmAreaInfoController.m
//  HMRcDemo
//
//  Created by 研发ios工程师 on 2018/2/6.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "HmAreaInfoController.h"

@interface HmAreaInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *arrCore;

@end

@implementation HmAreaInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrCore = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    NSDictionary * rcInfo = [NSDictionary dictionary];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"wifi_devMac"]) {
        rcInfo = @{RcCurrentMacAddress:[[NSUserDefaults standardUserDefaults]objectForKey:@"wifi_devMac"]};
    }else{
        NSLog(@"--------不能获取码库----------------需要获取mac地址--------------------");
    }
    UIView *view = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"获取pa_key.....";
    hud.label.textColor = [UIColor blackColor];
    
     NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [HmRcHttpRequest remotecGetPaKeyByRcInfo:rcInfo response:^(NSInteger resultCode, NSString *resultDescription, NSDictionary *resultDict) {
            if (resultCode == 1) {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * dic = @{
                                   RcCurrentMacAddress: [[NSUserDefaults standardUserDefaults]objectForKey:@"wifi_devMac"],
                                   RcCurrentPaKey: resultDict[@"pa_key"][@"0"]
                                   };
            [defaults setObject:dic  forKey:@"HM_MacAndPakey_Info"];
            [defaults synchronize];
             hud.label.text = @"获取区域列表.....";
                dispatch_semaphore_signal(sema);
            }else{
              hud.label.text = @"获取pa_key失败.....";
              [hud hideAnimated:YES afterDelay:2];
            }
        }];
         dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }];
   
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
       
        [HmRcHttpRequest remotecGetSupportedRegionWithRcInfo:[[NSUserDefaults standardUserDefaults] objectForKey:@"HM_MacAndPakey_Info"] response:^(NSInteger resultCode, NSString *resultDescription, NSDictionary *resultDict) {
            if (resultCode == 1) {
                [resultDict[@"region"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [self.arrCore addObject:obj];
                }];
                [self.tableView reloadData];
                [hud hideAnimated:YES];
            }else{
                hud.label.text = @"获取区域列表失败.....";
                [hud hideAnimated:YES afterDelay:2];
            }
        }];
    }];
    [operation2 addDependency:operation1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation1, operation2] waitUntilFinished:NO];
}


#pragma mark Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrCore.count;
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
    cell.textLabel.text = self.arrCore[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [self performSegueWithIdentifier:@"DeviceTypeInfo" sender:self.arrCore[indexPath.row]];
}
    


@end
