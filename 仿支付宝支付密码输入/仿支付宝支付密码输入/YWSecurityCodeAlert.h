//
//  CMTransferMoneyConfirmAlert.h
//  CMTransferMoneyConfirmAlert
//
//  Created by yanyw on 15/12/9.
//  Copyright © 2016年 yanyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWSecurityCodeAlert : UIViewController


/*
 *  title    标题
 *  msg      信息
 *  money    金额
 *  completionBlock  回调
 */
+ (void)showAlertWithTitle:(NSString*)title msg:(NSString*)msg money:(NSString*)money isShowPWD:(BOOL)isShow completionHandler:(void(^)(NSString *inputPwd))completionBlock;


@end
