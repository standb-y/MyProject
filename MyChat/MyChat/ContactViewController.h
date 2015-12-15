//
//  ContactViewController.h
//  MyChat
//
//  Created by qianfeng on 15/11/12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UITableViewController

//好友个数变化时，重新获取数据
- (void)reloadDataSource;

@end
