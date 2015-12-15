//
//  CreateConversationViewController.h
//  MyChat
//
//  Created by qianfeng on 15/11/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"

@interface CreateConversationViewController : UIViewController

@property (nonatomic,copy) NSString *name;
@property (nonatomic) EMConversationType conversationType;
@end
