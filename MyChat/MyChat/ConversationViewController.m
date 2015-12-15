//
//  ConversationViewController.m
//  MyChat
//
//  Created by qianfeng on 15/11/12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ConversationViewController.h"
#import "EaseMob.h"
#import "ChatViewCell.h"

#define KPageCount 20

@interface ConversationViewController () <EMChatManagerDelegate,UITextFieldDelegate>
{
    dispatch_queue_t _messageQueue;
}

@property (nonatomic) UITextField * sendContext;

@property (nonatomic) BOOL isChatGroup;

@property (nonatomic) EMConversationType conversationType;

@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (strong,nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) EMConversation *conversation;//会话管理者

@property (strong,nonatomic) UITextField *textField;

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _sendContext = [[UITextField alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height - 100 , self.view.frame.size.width, 50)];
    _sendContext.borderStyle = UITextBorderStyleBezel;
    _sendContext.delegate = self;
    _sendContext.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_sendContext];
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self refreshDataSource];
    
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self send];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatter = chatter;
        _conversationType = type;
        _messages = [NSMutableArray array];

        
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter
                                                                    conversationType:type];
        [_conversation markAllMessagesAsRead:YES];
    }
    
    return self;
}

- (BOOL)isChatGroup
{
    return _conversationType != eConversationTypeChat;
}

#pragma mark - 发送信息
-(void) send{

    EMChatText *txtChat = [[EMChatText alloc] initWithText:_sendContext.text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:_chatter bodies:@[body]];
    message.messageType = eMessageTypeChat;
    
    
    EMError *error = nil;
    
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];

    [chatManager sendMessage:message progress:nil error:&error];
    
    [_messages addObject:message];
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    _textField.text = @"";
}

#pragma mark - EMChatManagerDelegate
/*!
 @method
 @brief 收到消息时的回调
 @param message      消息对象
 @discussion 当EMConversation对象的enableReceiveMessage属性为YES时, 会触发此回调
 针对有附件的消息, 此时附件还未被下载.
 附件下载过程中的进度回调请参考didFetchingMessageAttachments:progress:,
 下载完所有附件后, 回调didMessageAttachmentsStatusChanged:error:会被触发
 */
-(void)didReceiveMessage:(EMMessage *)message
{
    NSLog(@"%s",__func__);

    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self.messages addObject:message];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"chatCell";
    ChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[ChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.message = _messages[indexPath.row];
    return cell;
}

- (void)refreshDataSource
{
    // 获得内存中所有的会话.
    NSArray *arr = nil;
    arr = [_conversation loadAllMessages];
    
    [_messages addObjectsFromArray:arr];
    [self.tableView reloadData];
}



- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

@end
