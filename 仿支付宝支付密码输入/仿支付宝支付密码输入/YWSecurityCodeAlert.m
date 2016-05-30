//
//  CMTransferMoneyConfirmAlert.h
//  CMTransferMoneyConfirmAlert
//
//  Created by yanyw on 15/12/9.
//  Copyright © 2016年 yanyw. All rights reserved.
//

#import "YWSecurityCodeAlert.h"


#define TITLE_HEIGHT 50
#define PAYMENT_WIDTH [UIScreen mainScreen].bounds.size.width-80
#define PWD_COUNT 6
#define DOT_WIDTH 12
#define KEYBOARD_HEIGHT 216
#define KEY_VIEW_DISTANCE 35
#define ALERT_HEIGHT 230


@interface YWSecurityCodeAlert ()<UITextFieldDelegate>
{
    NSMutableArray *_pwdIndicatorArr;
}
// 控件
@property (nonatomic, strong) UIView *paymentAlert, *inputView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel, *line, *detailLabel, *amountLabel;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIWindow *showWindow;

// 属性
@property (nonatomic, copy) NSString *titleStr, *detail; ///< 标题 、 详细
@property (nonatomic, assign) CGFloat amount;  ///< 金额
@property (nonatomic,copy) void (^completionBlock)(NSString *inputPwd); ///< 输入完成回调
@property (nonatomic, assign) BOOL isShow;     ///< 是否显示密码

@end

@implementation YWSecurityCodeAlert


- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.view.frame = [UIScreen mainScreen].bounds;
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6f];
        
        [self drawSubViews];
    }
    return self;
}

// 子控件绘制
- (void)drawSubViews {
    
    if (!_paymentAlert) {
        
    // 块
        _paymentAlert = [[UIView alloc]initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height-KEYBOARD_HEIGHT-KEY_VIEW_DISTANCE-ALERT_HEIGHT -35, [UIScreen mainScreen].bounds.size.width-80, ALERT_HEIGHT)];
        if ([UIScreen mainScreen].bounds.size.height == 576) { // 5s

            [_paymentAlert setFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height-KEYBOARD_HEIGHT-KEY_VIEW_DISTANCE-ALERT_HEIGHT + 15, [UIScreen mainScreen].bounds.size.width-80, ALERT_HEIGHT - 20)];
            
        } else if ([UIScreen mainScreen].bounds.size.height == 480) {  // 4s
        
            [_paymentAlert setFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height-KEYBOARD_HEIGHT-KEY_VIEW_DISTANCE-ALERT_HEIGHT + 35, [UIScreen mainScreen].bounds.size.width-80, ALERT_HEIGHT - 20)];
            
        }
        _paymentAlert.layer.cornerRadius = 5.f;
        _paymentAlert.layer.masksToBounds = YES;
        _paymentAlert.backgroundColor = [UIColor colorWithWhite:1. alpha:.95];
        [self.view addSubview:_paymentAlert];
        
    // 标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PAYMENT_WIDTH, TITLE_HEIGHT)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [_paymentAlert addSubview:_titleLabel];
        
    // 关闭按钮
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setFrame:CGRectMake(5, 0, TITLE_HEIGHT, TITLE_HEIGHT)];
        [_closeBtn setTitle:@"╳" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_paymentAlert addSubview:_closeBtn];
    // 横线
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, TITLE_HEIGHT, PAYMENT_WIDTH, .5f)];
        _line.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:212.0f/255.0f blue:212.0f/255.0f alpha:1.0];
        [_paymentAlert addSubview:_line];
        
    // 详细
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_line.frame) + 15, PAYMENT_WIDTH-30, 20)];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        [_paymentAlert addSubview:_detailLabel];
        
    // 金额
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_detailLabel.frame) + 18, PAYMENT_WIDTH-30, 26)];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.textColor = [UIColor blackColor];
        _amountLabel.font = [UIFont systemFontOfSize:40];
        [_paymentAlert addSubview:_amountLabel];
        
    // 输入模块
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(15, _paymentAlert.frame.size.height-(PAYMENT_WIDTH-30)/6-15, PAYMENT_WIDTH-30, (PAYMENT_WIDTH-30)/6)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.layer.borderWidth = 1.f;
        _inputView.layer.borderColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0].CGColor;
        [_paymentAlert addSubview:_inputView];
        
        _pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(2, 2, self.view.frame.size.width-4, self.view.frame.size.height-4)];
        _pwdTextField.hidden = YES;
        _pwdTextField.delegate = self;
        _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_inputView addSubview:_pwdTextField];
        
        CGFloat width = _inputView.bounds.size.width / PWD_COUNT;
        
        _pwdIndicatorArr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < PWD_COUNT; i ++) {
            
            UILabel *dot = [[UILabel alloc] initWithFrame:CGRectMake((width - DOT_WIDTH)/2 + i*width, (_inputView.bounds.size.height-DOT_WIDTH)/2, DOT_WIDTH, DOT_WIDTH)];
            dot.layer.cornerRadius = DOT_WIDTH/2.;
            dot.clipsToBounds = YES;
            dot.hidden = YES;
            [_inputView addSubview:dot];
            [_pwdIndicatorArr addObject:dot];
            
                if (i == PWD_COUNT-1) {
                continue;
            }
        // 输入框竖线
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, .5f, _inputView.bounds.size.height)];
            line.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:212.0f/255.0f blue:212.0f/255.0f alpha:1.0];
            [_inputView addSubview:line];
            
            
        }
    }
    
}

+ (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg money:(NSString *)money isShowPWD:(BOOL)isShow completionHandler:(void (^)(NSString *))completionBlock {

    [[[self alloc] init] showAlertWithTitle:title msg:msg money:money isShowPWD:isShow completionHandler:completionBlock];
}

- (void)showAlertWithTitle:(NSString*)title msg:(NSString*)msg money:(NSString*)money isShowPWD:(BOOL)isShow  completionHandler:(void(^)(NSString *inputPwd))completionBlock {

    _isShow = isShow;
    _titleLabel.text = title;
    _detailLabel.text = msg;
    _amountLabel.text = [NSString stringWithFormat:@"￥%.2f ",[money floatValue]];
    _completionBlock = completionBlock;

    UIWindow *newWindow = [[UIWindow alloc] initWithFrame:self.view.bounds];
    newWindow.rootViewController = self;
    [newWindow makeKeyAndVisible];
    self.showWindow = newWindow;
    
    _paymentAlert.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    _paymentAlert.alpha = 0;

    [UIView animateWithDuration:.3f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_pwdTextField becomeFirstResponder];
        _paymentAlert.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _paymentAlert.alpha = 1.0;
        
    } completion:nil];
    
}

- (void)dismiss {
    
    [_pwdTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        _paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        _paymentAlert.alpha = 0;
        self.showWindow.alpha = 0;
        
    } completion:^(BOOL finished) {

        [self.showWindow removeFromSuperview];
        [self.showWindow resignKeyWindow];
        self.showWindow = nil;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= PWD_COUNT && string.length) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }
    
    NSString *totalString;
    if (string.length <= 0) {
        totalString = [textField.text substringToIndex:textField.text.length-1];
    } else {
        totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }

    [self setDotWithCount:totalString.length totalString:totalString];

    if (totalString.length == 6) {
        if (_completionBlock) {
            _completionBlock(totalString);
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:.3f];
    }
    
    return YES;
}

- (void)setDotWithCount:(NSInteger)count totalString:(NSString *)str {
    
    for (UILabel *dot in _pwdIndicatorArr) {
        dot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        if (_isShow) {

            ((UILabel*)[_pwdIndicatorArr objectAtIndex:i]).backgroundColor = [UIColor whiteColor];
            ((UILabel*)[_pwdIndicatorArr objectAtIndex:i]).hidden = NO;
            NSString *strSub = [str substringFromIndex:i];
            strSub = [strSub substringToIndex:1];
            ((UILabel*)[_pwdIndicatorArr objectAtIndex:i]).text = strSub;
        }else {

            ((UILabel*)[_pwdIndicatorArr objectAtIndex:i]).backgroundColor = [UIColor blackColor];
            ((UILabel*)[_pwdIndicatorArr objectAtIndex:i]).hidden = NO;

        }
    }
}


@end
