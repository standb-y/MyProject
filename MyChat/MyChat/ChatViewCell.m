//
//  ChatViewCell.m
//  MyChat
//
//  Created by qianfeng on 15/11/12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ChatViewCell.h"

@implementation ChatViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        label.backgroundColor = [UIColor redColor];
        self.leftLabel = label;
        //注 把label视图驾到contentView里
        [self.contentView addSubview:self.leftLabel];
        
        UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(300, 0, 60, 30)];
        l2.backgroundColor = [UIColor grayColor];
        self.rightLabel = l2;
        [self.contentView addSubview:self.rightLabel];

    }
    
    return self;
}

- (void)setMessage:(EMMessage *)message
{
    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    NSString *login = [userInfo objectForKey:@"username"];
    NSString *sender = (message.messageType == eMessageTypeChat) ? message.from : message.groupSenderName;
    BOOL isSender = [login isEqualToString:sender] ? YES : NO;
    
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    
    if (isSender) {
        self.rightLabel.text = ((EMTextMessageBody *)messageBody).text;
        
        self.leftLabel.hidden = YES;
        self.rightLabel.hidden = NO;
    }else{
        self.leftLabel.text = ((EMTextMessageBody *)messageBody).text;
        
        self.leftLabel.hidden = NO;
        self.rightLabel.hidden = YES;
    }
    
}

@end
