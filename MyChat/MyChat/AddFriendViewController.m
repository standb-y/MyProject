//
//  AddFriendViewController.m
//  MyChat
//
//  Created by qianfeng on 15/11/12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "AddFriendViewController.h"
#import "EaseMob.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onOk:(id)sender {
    
    EMError *err = nil;
    BOOL ret = [[[EaseMob sharedInstance] chatManager] addBuddy:self.name.text message:self.message.text error:&err];
    
    if (!ret) {
        NSLog(@"好友申请发送失败");
    }else{
        NSLog(@"好友申请发送成功");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
