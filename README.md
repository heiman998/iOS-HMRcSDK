
# **海曼红外转发器 iOS SDK集成文档**



- [简介](#Introduction)
		- [平台简介](#Platform_Introduction)
		- [APP SDK简介](#sdk_Introduction)
		- [集成流程](#Integration_Processes)
- [二、轻松集成](#integrated)
    - [集成准备](#ready)
    - [Setp1 下载SDK](#setp1)

    - [Setp3 初始化SDK](#setp3)
    - [Setp4 设备入网](#setp4)
    - [Setp5 获取码库](#setp5)
    - [Setp6 指令解析](#setp6)

- [三、API文档](#api) 
- [四、术语表](#Glossary)
- [五、更新历史](#history)
## 一、<a name="Introduction">简介</a>

- [平台简介](#Platform_Introduction)
- [APP SDK简介](#sdk_Introduction)
- [集成流程](#Integration_Processes)



### 1.1、<a name="sdk_Introduction">APP SDK 简介</a>

**为简化开发者的APP开发，海曼科技提供了APP开发套件和相关的支持服务：**

- 提供APP的SDK和开发文档，适应iOS平台
- 提供APP端通用业务功能块的实例源代码，极大简化开发人员开发工作
- 主要用于获取红外转发器设备的码库

**APP开发套件包含以下主要功能：**

- 智能配网功能
- 指令解析
- 获取码库



##二、<a name="integrated">轻松集成</a>


- [集成准备](#ready)
- [Setp1 下载SDK](#setp1)
- [Setp2 开发环境配置](#setp2)
- [Setp3 初始化SDK](#setp3)
- [Setp4 设备入网](#setp5)
- [Setp5 获取码库](#setp6) 
- [Setp6 指令解析](#setp6)



### 2.1  <a name="setp1" >Setp 1 下载SDK工具包</a>

1. SDK下载地址 
2. 解压下载的SDK，目录结构如下  

- 注：《透传DEMO源码》是一个使用海曼APP SDK的示例测试程序，实现了设备透传控制功能，开发者可以直接使用透传Demo进行测试体验，也可以结合本文档，参考其中Demo代码实现开发自己的APP。 
- 注iOS ：为了简化Http接口调用，iOS透传SDK中提供了HMHttpManage类源码供开发者使用，此文档中涉及到iOS Http接口的调用都以HMHttpManage类为例说明需要pod第三方AFNetworking，以下会有操作详解。


### 2.2 <a name="setp2" >Setp 2 开发环境配置</a>

**IOS**

1. 打开Xcode... 创建一个新的工程；  
2. 通过[CocoaPods](https://www.jianshu.com/p/fe6beb7c312d) , pod 'AFNetworking' 和 pod  'MQTTClient' 的最新版本即可， 详细可见地址：[AFNetworking](https://github.com/AFNetworking/AFNetworking)  
3. 在新建项目中集成 HmMqttSDK ，可将SDK中的.h文件添加到pch文件中统一管理






### 2.3 <a name="setp3" >Setp 3 初始化SDK</a>


1. 关于初始化SDK : 解析指令时，我们需要获取用户的用户id和用户name，来输出化sdk。

	**iOS代码范例**

	```
	 //举例：初始化HMRcSdk
    [HMRcSDK startHmRcSDKWithUserName:@"HJ" andUserId:@"110"];
	  	  
	```

### 2.4 <a name="setp4" >Setp 4 网关设备入网</a>



**IOS调用示例**  
 	为了简化Http接口调用和优化HTTP通信,我们采用第三方库AFNetworking，使用时需要pod‘AFNetworking’ ，iOS透传SDK中提供了HMHttpManage类源码供开发者使用， 此文档中涉及到iOS Http接口的调用都以HMHttpManage类为例说明。
   

```
//    单例  设备类型枚举（可参考HmSmartLinkManager.h） 当前wifi密码
    [[HmSmartLinkManager sharedManager] startWifiNetInWithDevType:deviceType wifiPassword: password resultResponse:^(BOOL success, id responseObj) {
        NSLog(@"结果--%d---%@--",success,responseObj);
    } outResponse:^(BOOL success, id responseObj) {
        NSLog(@"进程--%d---%@--",success,responseObj);
    }];

```

### 2.5 <a name="setp5" >Setp 5 获取码库</a>

为了简化Http接口调用和优化HTTP通信,我们采用第三方库AFNetworking，使用时需要pod‘AFNetworking’ ，iOS透传SDK中提供了 HmRcHttpRequest类源码供开发者使用， 此文档中涉及到iOS Http接口的调用都以 HmRcHttpRequest类为例说明。

	**IOS 调用示例**

	```
	//第一步：获取pa_key  
	  NSDictionary * rcInfo = @{RcCurrentMacAddress:@“macName”};）
	    注： 1. rcInfo 是包含mac地址的字典  
	        2. RcCurrentMacAddress为约定的mac地址的key 不可变
	     
    [HmRcHttpRequest remotecGetPaKeyByRcInfo:rcInfo response:^(NSInteger resultCode, NSString *resultDescription, NSDictionary *resultDict) {
            if (resultCode == 1) {
     //获取到pa_key之后与mac地址重新组成rcInfo的字典 以便后面使用
     注： 1. RcCurrentPaKey 是约定的包含pa_key的字典   不可变
             NSDictionary * dic = @{
                                   RcCurrentMacAddress:@“macName” ,
                                   RcCurrentPaKey: resultDict[@"pa_key"][@"0"]
                                   };
            }else{
            }
        }];
        //然后依次获取：地区-->类型-->品牌-->型号-->码库 (可见demo)
	```

### 2.6 <a name="setp6" >Setp 6 指令解析</a>

1.根据协议，在将数据进行加密解密，获取密钥是明文，回来的数据需要公钥解密获得密钥，其他指令解析需要密钥进行加密解密。

	**IOS 调用示例**
	<!--指令加密解析-->
	        NSLog(@"-----获取设备密钥------");
           [[HMRCCommandManager sharedManager] getRcAeckey callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,sn,errorCode);
            }];
      
            
            NSLog(@"------获取基本信息-----");
            注：需要私钥等 具体参数可见API文档和demo
            
            [[HMRCCommandManager sharedManager] getDeviceInfoWithHmRcModel:self.rcModel callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
                NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,sn,errorCode);
            }];
    <!--指令解密解析-->
          
      //   1 如果设备有消息回来 获取到私钥 用公钥解密
               self.rcModel.acckey = @"xxxxxxxxx";
               self.rcModel.aeskey = nil;
    //     2  如果设备有非获取私钥指令消息回来 用私钥解密
    //         self.rcModel.aeskey = @"xxxxxxxxx";
      
     注： -同一个接口解析指令 data：需要解析的data数据
           [[HMRCCommandManager sharedManager] baseReplyWithRcModel:self.rcModel backData:data callBack:^(id successInfo, NSInteger sn, NSInteger errorCode) {
            NSLog(@"successInfo :%@,sn:%ld,errorCode:%ld",successInfo,sn,errorCode);
    }];
            
 

 

## 三、<a name="api">API文档</a>


**IOS：**

具体参考[SDK接口说明]()

## 四、<a name="Glossary">术语表</a>


> | 术语 | 解释 |
> |-------------|-------------|
> |产品|即企业要开发、生产、销售的一款设备，对应到企业管理后台的产品管理|
> |设备|设备是产品的实体，这里特指直接接入云智易平台的智能设备，如网关，插座，灯泡|
> |子设备|间接接入海曼平台的设备，如通过网关接入的温度传感器|
> |APP用户|指在APP端通过Http接口注册和登录的终端用户账号|



## 五、<a name="history">更新历史</a>

**IOS**


2018-02-9：发布初步版本协议以及SDK




