//
//  ConversationViewController.h
//  MyChat
//
//  Created by qianfeng on 15/11/12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMChatManagerDefs.h"

@interface ConversationViewController : UITableViewController

@property (strong, nonatomic, readonly) NSString *chatter;


- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type;

- (void)refreshDataSource;

@end
