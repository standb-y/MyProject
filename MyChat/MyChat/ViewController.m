//
//  ViewController.m
//  MyChat
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "EaseMob.h"
#import "MyChatDefine.h"

#define Swidth [UIScreen mainScreen].bounds.size.width
#define Sheight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s",__func__);
    
//    //判断是否已经登录
//    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
//    
//    if (isAutoLogin) {
//        [self gotoChatViewController];
//        return;
//    }

    
    self.title = @"login";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupLogin];
}

//- (void)gotoChatViewController
//{
//    
//    //1.会话页面
//    ChatViewController *chatVC = [[ChatViewController alloc] init];
//    chatVC.title = @"MyChat";
//    UINavigationController *chatNavi = [[UINavigationController alloc] initWithRootViewController:chatVC];
//    chatVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"MyChat" image:nil tag:1];
//    chatVC.view.backgroundColor = [UIColor orangeColor];
//
//    //2.通讯录页面
//    ContactViewController *contactVC = [[ContactViewController alloc] init];
//    contactVC.title = @"contacts";
//    UINavigationController *contactNavi = [[UINavigationController alloc] initWithRootViewController:contactVC];
//    contactVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Contacts" image:nil tag:2];
//    
//    
//    //3.我页面
//    MeViewController *meVC = [[MeViewController alloc] init];
//    meVC.title = @"Me";
//    UINavigationController *meNavi = [[UINavigationController alloc] initWithRootViewController:meVC];
//    meVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:nil tag:3];
//    
//    //tab bar controller
//    UITabBarController *tabController = [[UITabBarController alloc] init];
//    tabController.viewControllers = @[chatNavi,contactNavi,meNavi];
////    [self addChildViewController:tabController];
//    
//    //present tab controller 页面
//    [self presentViewController:tabController animated:YES completion:nil];
////    [self.navigationController pushViewController:tabController animated:YES];
//    
//}



- (void)setupLogin
{
    _userName =  [[UITextField alloc] initWithFrame:CGRectMake(30, 100, Swidth-60, 30)];
    _password = [[UITextField alloc] initWithFrame:CGRectMake(30, 150, Swidth-60, 30)];
    [self.view addSubview:_userName];
    [self.view addSubview:_password];
    
    _userName.font = [UIFont fontWithName:@"ArialMT"size:18];
    _userName.placeholder = @"123.";
    [_userName setBorderStyle:UITextBorderStyleBezel];
    _userName.backgroundColor = [UIColor grayColor];
    
    _password.font = [UIFont fontWithName:@"ArialMT"size:18];
    _password.placeholder = @"123.";
    [_password setBorderStyle:UITextBorderStyleBezel];
    _password.backgroundColor = [UIColor grayColor];
    
    UIButton *btn_register = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, 50, 40)];
    UIButton *btn_login = [[UIButton alloc] initWithFrame:CGRectMake(250, 200, 50, 40)];
    
    
    [btn_login setBackgroundColor:[UIColor orangeColor]];
    [btn_login setTitle:@"登录" forState:UIControlStateNormal];
    [btn_login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn_register setBackgroundColor:[UIColor orangeColor]];
    [btn_register setTitle:@"注册" forState:UIControlStateNormal];
    [btn_register setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:btn_register];
    [self.view addSubview:btn_login];
    
    
    [btn_register addTarget:self action:@selector(userRegister) forControlEvents:UIControlEventTouchUpInside];
    [btn_login addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
}

-(void)userRegister{
    BOOL ret = [self isEmpty];
    if (!ret) {
        
        //异步注册账号
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_userName.text
                                                             password:_password.text
                                                       withCompletion:
         ^(NSString *username, NSString *password, EMError *error) {
             
             if (!error) {
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"注册成功，请登陆"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
             }else{
                 switch (error.errorCode) {
                     case EMErrorServerNotReachable:
                         TTAlertNoTitle(@"连接服务器失败");
                         break;
                     case EMErrorServerDuplicatedAccount:
                         TTAlertNoTitle(@"该用户已经注册过了");
                         break;
                     case EMErrorNetworkNotConnected:
                         TTAlertNoTitle(@"没有网络连接");
                         break;
                     case EMErrorServerTimeout:
                         TTAlertNoTitle(@"超时");
                         break;
                     default:
                         TTAlertNoTitle(@"其他错误,反正一大堆拉");
                         break;
                 }
             }
         } onQueue:nil];
    }
    
}

-(void)userLogin{
    BOOL ret = [self isEmpty];
    if (!ret) {
        
        
        //异步登陆账号
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_userName.text
                                                            password:_password.text
                                                          completion:
         ^(NSDictionary *loginInfo, EMError *error) {
             
             if (loginInfo && !error) {
                 //设置是否自动登录
                 [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
                 
                 // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
//                 [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                 //获取数据库中数据
                 [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                 
                 //获取群组列表
                 [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                 
#warning 开始跳转,然后开始聊天
                 NSLog(@"登录成功");
                 //TTAlertNoTitle(@"登录成功");
                 
                 
                 //发送自动登陆状态通知
                              [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                 
             }
             else
             {
                 switch (error.errorCode)
                 {
                     case EMErrorNotFound:
                         TTAlertNoTitle(error.description);
                         break;
                     case EMErrorNetworkNotConnected:
                         TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                         break;
                     case EMErrorServerNotReachable:
                         TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                         break;
                     case EMErrorServerAuthenticationFailure:
                         TTAlertNoTitle(error.description);
                         break;
                     case EMErrorServerTimeout:
                         TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                         break;
                     default:
                         TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                         break;
                 }
             }
         } onQueue:nil];
    }
    
}


void TTAlertNoTitle(NSString* message) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *username = _userName.text;
    NSString *pas = _password.text;
    if (username.length == 0 || pas.length == 0) {
        ret = YES;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"输入不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    return ret;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
