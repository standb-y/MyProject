//
//  MainViewController.m
//  MyChat
//
//  Created by qianfeng on 15/11/12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MainViewController.h"
#import "EaseMob.h"
#import "ChatViewController.h"
#import "ContactViewController.h"
#import "MeViewController.h"


@interface MainViewController () <EMChatManagerDelegate>
{
    ChatViewController *_chatVC;
    ContactViewController *_contactVC;
    MeViewController *_meVC;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerDelegate];
    
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(void)registerDelegate
{
    [self unregisterDelegate];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];

}

-(void)unregisterDelegate
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];

}

- (void)setupSubviews
{
    //1.会话页面
    _chatVC = [[ChatViewController alloc] init];
    _chatVC.title = @"MyChat";
    UINavigationController *chatNavi = [[UINavigationController alloc] initWithRootViewController:_chatVC];
    _chatVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"MyChat" image:nil tag:1];
    _chatVC.view.backgroundColor = [UIColor orangeColor];
    
    //2.通讯录页面
    _contactVC = [[ContactViewController alloc] init];
    _contactVC.title = @"contacts";
    UINavigationController *contactNavi = [[UINavigationController alloc] initWithRootViewController:_contactVC];
    _contactVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Contacts" image:nil tag:2];
    
    
    //3.我页面
    _meVC = [[MeViewController alloc] init];
    _meVC.title = @"Me";
    UINavigationController *meNavi = [[UINavigationController alloc] initWithRootViewController:_meVC];
    _meVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:nil tag:3];
    
   
    self.viewControllers = @[chatNavi,contactNavi,meNavi];

}
#pragma mark - EMChatManagerDelegate 好友变化
//当收到好友请求时, 会调用这个方法
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    //接受好友请求
    [[[EaseMob sharedInstance] chatManager] acceptBuddyRequest:username error:nil];
}

//接受好友请求后, SDK会自动回调好友列表更新的方法, 更新好友列表
- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd
{
    [_contactVC reloadDataSource];
}

- (void)didAcceptedByBuddy:(NSString *)username
{
    [_contactVC reloadDataSource];
}

- (void)didAcceptBuddySucceed:(NSString *)username
{
    [_contactVC reloadDataSource];
}

#pragma mark - EMChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
//    [self setupUnreadMessageCount];
    [_chatVC refreshDataSource];
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    
  
}

- (void)dealloc
{
    [self unregisterDelegate];
}

@end
