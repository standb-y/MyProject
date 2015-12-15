//
//  ChatViewCell.h
//  MyChat
//
//  Created by qianfeng on 15/11/12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"

@interface ChatViewCell : UITableViewCell

@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UILabel *rightLabel;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic) EMMessage *message;

@end
