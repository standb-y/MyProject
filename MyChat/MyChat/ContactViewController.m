//
//  ContactViewController.m
//  MyChat
//
//  Created by qianfeng on 15/11/12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ContactViewController.h"
#import "AddFriendViewController.h"
#import "EaseMob.h"
#import "CreateConversationViewController.h"

@interface ContactViewController () <EMChatManagerDelegate>

@property (nonatomic,strong) NSMutableArray *usernames;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)] ;
    

    _usernames = [NSMutableArray array];
    
    [self reloadDataSource];

}

- (void)onAdd
{
    AddFriendViewController *vc = [[AddFriendViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 更新好友列表
- (void)reloadDataSource
{
    [_usernames removeAllObjects];
    
    //获取好友列表
    NSArray *buddys = [[EaseMob sharedInstance].chatManager buddyList];
    
    //循环取得 EMBuddy 对象
    for (EMBuddy *buddy in buddys) {
        //屏蔽发送了好友申请, 但未通过对方接受的用户
        if (!buddy.isPendingApproval) {
            [_usernames addObject:buddy.username];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _usernames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = _usernames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreateConversationViewController *vc = [[CreateConversationViewController alloc] init];
    
    vc.name = _usernames[indexPath.row];
    vc.conversationType = eConversationTypeChat;
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}




@end
