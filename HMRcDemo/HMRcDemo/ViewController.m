//
//  ViewController.m
//  HMRcDemo
//
//  Created by 研发ios工程师 on 2018/2/1.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "ViewController.h"
#import "HMRCCommandManager.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray * commandsArr;

@property (nonatomic, strong)HMRcModel * rcModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = false;
}

- (NSArray *)commandsArr{
    if (!_commandsArr) {
        _commandsArr = @[@"设备进入入网模式",@"进入HTTP获取码库界面",@"获取设备密钥",@"获取基本信息",@"获取温度",@"获取定时器",@"设置时区",@"设置设备名称",@"发送红外码库",@"进入红外学习模式",@"发送ECHO",@"删除ECHO子设备",@"设置RC定时器时间",@"设置温度报警阈值"];
    }
    return _commandsArr;
}

- (HMRcModel *)rcModel{
    if (!_rcModel) {
        _rcModel = [[HMRcModel alloc]init];
        _rcModel.acckey = @"bd17df6d548211e7";
//        _rcModel.aeskey = [[NSUserDefaults standardUserDefaults] objectForKey:@"demo_Aeskey"];
//        测试
        _rcModel.aeskey = @"kkfhashfkahfa1";
    }
    return _rcModel;
}


#pragma mark Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commandsArr.count;
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
    cell.textLabel.text = self.commandsArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
   
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blueColor];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
     return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    switch (indexPath.row) {
        case 2:
            NSLog(@"-----获取设备密钥------");
            [[HMRCCommandManager sharedManager] getRcAeckeyWithCallBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
            break;
        case 3:
            NSLog(@"------获取基本信息-----");
            [[HMRCCommandManager sharedManager] getDeviceInfoWithHmRcModel:self.rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
            break;
        case 4:
            NSLog(@"------获取温度-----");
            [[HMRCCommandManager sharedManager] getRcTemperatureWithRcModel:self.rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
            break;
        case 5:
            NSLog(@"------获取定时器-----");
            [[HMRCCommandManager sharedManager] getRcTimerWithRcModel:self.rcModel odId:@"111" callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
            break;
        case 6:
            NSLog(@"------设置时区-----");
            [[HMRCCommandManager sharedManager] setRcTimeZone:@"-3.30" RcModel:self.rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
            break;
        case 7:
            NSLog(@"------设置设备名称-----");
            [[HMRCCommandManager sharedManager] setRcDeviceName:@"红外转发卡"  hmRcModel:self.rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
            break;
        case 8:{
            HMSendCodeModel * sendModel = [[HMSendCodeModel alloc]init];
            sendModel.code = @"1234567da";
            sendModel.OD = @"ssfasfasfa";
            sendModel.zip = 2;
            sendModel.OF = 1;
            NSLog(@"------发送红外码库-----");
            [[HMRCCommandManager sharedManager] setFictitiousDeviceRcCodeWitHmRcModel:self.rcModel HmSendCodeModel:sendModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
        }
            break;
        case 9:
            NSLog(@"------进入红外学习模式-----");
            [[HMRCCommandManager sharedManager] statLearnRcActionWithRcModel:self.rcModel odId:@"111" callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
            break;
        case 10:{
            NSLog(@"------(发送echo)-----");
            HMSendCodeModel * sendModel0 = [[HMSendCodeModel alloc]init];
            sendModel0.code = @"1234567da";
            sendModel0.OD = @"ssfasfasfa";
            sendModel0.zip = 2;
            sendModel0.OF = 1;
            HMSendCodeModel * sendModel1 = [[HMSendCodeModel alloc]init];
            sendModel1.code = @"1234567da";
            sendModel1.OD = @"ssfasfasfa";
            sendModel1.zip = 2;
            sendModel1.OF = 1;
            NSArray * arr = @[sendModel0,sendModel1];
            [[HMRCCommandManager sharedManager] createLocalCodeWithRcModel:self.rcModel localCodes:arr callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
        }
             break;
        case 11:
            NSLog(@"------删除echo子设备-----");
            [[HMRCCommandManager sharedManager] deleteLocalCodeWithRcModel:self.rcModel OD:@"111" callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
            break;
        case 12:{
            NSLog(@"------设置RC定时器时间-----");
            HMRCTimer * timer = [[HMRCTimer alloc]init];
            timer.smonth = 1;
            timer.sday = 1;
            timer.shour = 12;
            timer.sminutes = 30;
            timer.emonth = 1;
            timer.eday = 2;
            timer.ehour = 13;
            timer.eminutes = 40;
            timer.wf = 1;
            timer.codeS = @"111aaa";
            timer.codeE = @"222bbb";
            [[HMRCCommandManager sharedManager]setRcTimerWithRcModel:self.rcModel odId:@"111" hmRcTimer:timer callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
        }
            break;
        case 13:{
            NSLog(@"------设置报警阈值-----");
            HMTempAlarmModel * model = [[HMTempAlarmModel alloc]init];
            model.t_ckup = 0.;
            model.t_cklow = 0.1;
            model.t_ckvalid_up = 1;
            model.t_ckvalid_low = 1;
            [[HMRCCommandManager sharedManager] setRcTemperatureLimitValueWithRcModel:self.rcModel HmTempAlarmModel:model callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,(long)sn,(long)errorCode);
            }];
        }
            break;
        case 1:
            NSLog(@"------进入HTTP获取码库界面-----");
            [self performSegueWithIdentifier:@"AreaInfo" sender:nil];
            break;
        case 0:
            NSLog(@"------进入入网模式-----");
            [self performSegueWithIdentifier:@"peiwang" sender:nil];
            break;
        default:
            break;
    }
//    如果设备有消息回来 获取到私钥
//    [[HMRCCommandManager sharedManager] baseReplyWithRcModel:self.rcModel backData:nil callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:successInfo forKey:@"demo_Aeskey"];
//        [defaults synchronize];
//    }];
}



@end
