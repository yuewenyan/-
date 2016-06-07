//
//  ViewController.m
//  仿支付宝支付密码输入
//
//  Created by yanyuewen on 16/5/30.
//  Copyright © 2016年 yanyuewen. All rights reserved.
//

#import "ViewController.h"
#import "YWSecurityCodeAlert.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 70, 200, 100)];
    [btn1 addTarget:self action:@selector(test1) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"密码显示弹框" forState:UIControlStateNormal];
    [btn1 setTitle:@"密码显示弹框" forState:UIControlStateHighlighted];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.view addSubview:btn1];

    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 200, 100)];
    [btn2 addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"密码隐藏弹框" forState:UIControlStateNormal];
    [btn2 setTitle:@"密码隐藏弹框" forState:UIControlStateHighlighted];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.view addSubview:btn2];
}

- (void)test1 {

    [YWSecurityCodeAlert showAlertWithTitle:@"密码输入" msg:@"你欠哥钱啊" money:@"100011.11" isShowPWD:NO completionHandler:^(NSString *inputPwd) {
        NSLog(@"%@",inputPwd);
    }];
}

- (void)test2 {

    [YWSecurityCodeAlert showAlertWithTitle:@"密码输入" msg:@"你欠哥钱啊" money:@"100011.11" isShowPWD:YES completionHandler:^(NSString *inputPwd) {
        NSLog(@"%@",inputPwd);
    }];
}


@end
