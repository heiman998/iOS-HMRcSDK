//
//  Enum.h
//  HMRcSDK
//
//  Created by 研发ios工程师 on 2018/1/30.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#ifndef Enum_h
#define Enum_h

#pragma mark ----------------------------编解码错误码---------------------------------------

typedef NS_ENUM(NSInteger, RC) {
    
    RC_SUCCESS = 200,                                   //成功
    RC_UNKNOWN_ERROR = 0,                               //未知错误
    RC_PARAMETER_ERROR = -1,                            //参数错误
    RC_CODEKEY_NIL = -2,                                //密钥为空
    RC_THE_OID_DOES_NOT_EXIST = -3,                     //不存在该OID
    RC_CID_DOES_NOT_EXIST = -4,                         //CID不存在
    RC_PL_CANNOT_BE_EMPTY = -5,                         //PL中不能为空
    RC_TEID_CANNOT_BE_EMPTY = -6,                       //TEID不能为空
    RC_NO_INIT = -7,                                    //SDK未初始化
    RC_ERROR_SDK = -8,                                  //SDK内部错误
    RC_ENCRYPTION_ERROR = -9,                           //加密失败
    RC_DECRYPTION_ERROR = -10,                          //解密失败
  
};

#endif /* Enum_h */

