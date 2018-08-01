//
//  ChatViewController.m
//  Droop
//
//  Created by Smart Pro on 2/9/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"

@interface ChatViewController () <ASTableDataSource, ASTableDelegate, MXRMessageCellFactoryDataSource, MXRMessageContentNodeDelegate>

@property (strong, nonatomic) NSDictionary *chatterInfo;
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) AppDelegate *app;

@end

@implementation ChatViewController

- (instancetype)initWithPerson:(NSDictionary *)personInfo {
    MXRMessengerInputToolbar* toolbar = [[MXRMessengerInputToolbar alloc] initWithFont:[UIFont systemFontOfSize:16.0f] placeholder:@"Type a message" tintColor:[UIColor mxr_fbMessengerBlue]];
    self = [super initWithToolbar:toolbar];
    if (self) {
        [self.toolbar.defaultSendButton addTarget:self action:@selector(tapSend:) forControlEvents:ASControlNodeEventTouchUpInside];
        
        // delegate must be self for interactive keyboard, datasource can be whatever
        self.node.tableNode.delegate = self;
        self.node.tableNode.dataSource = self;
        [self customizeCellFactory];
        
        self.chatterInfo = personInfo;
    }
    
    return self;
}

- (void)customizeCellFactory {
    MXRMessageCellLayoutConfiguration* layoutConfigForMe = [MXRMessageCellLayoutConfiguration rightToLeft];
    MXRMessageCellLayoutConfiguration* layoutConfigForOthers = [MXRMessageCellLayoutConfiguration leftToRight];
    
    MXRMessageAvatarConfiguration* avatarConfigForMe = nil;
    MXRMessageAvatarConfiguration* avatarConfigForOthers = [[MXRMessageAvatarConfiguration alloc] init];
    avatarConfigForOthers.size = CGSizeMake(42, 42);
    avatarConfigForOthers.cornerRadius = 21.f;
    
    MXRMessageTextConfiguration* textConfigForMe = [[MXRMessageTextConfiguration alloc] initWithFont:[UIFont fontWithName:@"Raleway-Medium" size:18.f] textColor:[UIColor whiteColor] backgroundColor:[UIColor mxr_fbMessengerBlue]];
    MXRMessageTextConfiguration* textConfigForOthers = [[MXRMessageTextConfiguration alloc] initWithFont:[UIFont fontWithName:@"Raleway-Medium" size:18.f] textColor:[UIColor blackColor] backgroundColor:[UIColor mxr_bubbleLightGrayColor]];
    
    MXRMessageCellConfiguration* cellConfigForMe = [[MXRMessageCellConfiguration alloc] initWithLayoutConfig:layoutConfigForMe avatarConfig:avatarConfigForMe textConfig:textConfigForMe imageConfig:nil mediaCollectionConfig:nil];
    MXRMessageCellConfiguration* cellConfigForOthers = [[MXRMessageCellConfiguration alloc] initWithLayoutConfig:layoutConfigForOthers avatarConfig:avatarConfigForOthers textConfig:textConfigForOthers imageConfig:nil mediaCollectionConfig:nil];
    
    self.cellFactory = [[MXRMessageCellFactory alloc] initWithCellConfigForMe:cellConfigForMe cellConfigForOthers:cellConfigForOthers];
    self.cellFactory.dataSource = self;
    self.cellFactory.contentNodeDelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self customizeTopBar];
    //[self getMessages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessages) name:@"MSGSRELOAD" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getMessages];
}

- (void)customizeTopBar
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    topView.layer.borderWidth = 1.f;
    [self.view addSubview:topView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 245) / 2.f, 25, 245, 21)];
    titleLbl.text = self.chatterInfo[@"user_name"];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = [UIFont fontWithName:@"Raleway-Bold" size:17.f];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLbl];

    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, 24, 12, 21)];
    backImg.image = [UIImage imageNamed:@"black_back"];
    [topView addSubview:backImg];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 53, 64);
    [backBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UIImageView *clearImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 41, 21, 30, 30)];
    clearImg.image = [UIImage imageNamed:@"clearchatic.png"];
    [topView addSubview:clearImg];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(self.view.frame.size.width - 46, 0, 46, 64);
    [clearBtn addTarget:self action:@selector(onClear:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:clearBtn];
}

- (void)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClear:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you really want to clear this chat? You won't be able to access it again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Clear", @"Cancel", nil];
    [alert show];
    alert = nil;
}

- (CGFloat)calculateTopInset {
    return 64.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.view setUserInteractionEnabled:NO];
        [self clearChatAPI];
    }
}

- (void)getMessages {
    NSDictionary *params = @{@"API": @"getmessages.php", @"requestBody": [NSString stringWithFormat:@"user_id=%@&friend_id=%@", self.app.userData[@"user_id"], self.chatterInfo[@"user_id"]]};
    
    [self.app makeAPICall:params completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if (result.count > 0) {
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                self.messages = [[[result[@"data"] reverseObjectEnumerator] allObjects] mutableCopy];
            }else{
                self.messages = nil;
            }
            [self markRead];
        }else{
            [self failed];
            self.messages = nil;
        }
        [self.node.tableNode reloadData];
    }];
}

- (void)markRead {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"markRead.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@&sender_id=%@", self.app.userData[@"user_id"], self.chatterInfo[@"user_id"]] forKey:@"requestBody"];
    
    [self.app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if (result.count > 0) {
            
        } else {
            
        }
    }];
}

- (void)clearChatAPI{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *isdeleted = [self.app.userData objectForKey:@"user_id"];
    if (![self.messages[0][@"MessageThread"][@"is_deleted"] isEqualToString:@"NO"]) {
        isdeleted = @"BOTH";
    }
    
    [dict setObject:@"clearchat.php" forKey:@"API"];
//    [dict setObject:[NSString stringWithFormat:@"user_id=%@&friend_id=%@&is_deleted=%@",[self.app.userData objectForKey:@"user_id"],self.title,isdeleted] forKey:@"requestBody"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@&friend_id=%@&is_deleted=%@",[self.app.userData objectForKey:@"user_id"],self.chatterInfo[@"user_id"],isdeleted] forKey:@"requestBody"];
    NSLog(@"pmh>>>%@",self.title);
    
    [self.app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self onBack:nil];
            }else{
                [self failed:@"Oops! Something went wrong, please try again. If problem persists, contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

- (void)failed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Oops! Seems like a connection issue, please check and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

- (void)failed:(NSString *)str {
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tapSend:(id)sender
{
    NSString* text = [self.toolbar clearText];
    if (text.length == 0) return;
    
    NSDictionary *message = @{@"MessageThread": @{@"message_sender": self.app.userData[@"user_id"], @"message_receiver": self.chatterInfo[@"user_id"], @"message_content": text, @"is_deleted": @"NO"}};
    // message.text = text;
    // message.senderID = 0;
    // message.timestamp = [NSDate date].timeIntervalSince1970;
    if (self.messages == nil) {
        self.messages = [[NSMutableArray alloc] init];
    }
    [self.messages insertObject:message atIndex:0];
    
    [self.cellFactory updateTableNode:self.node.tableNode animated:YES withInsertions:@[[NSIndexPath indexPathForRow:0 inSection:0]] deletions:nil reloads:nil completion:nil];
    [self sendMessageAPI:text];
}

- (void)sendMessageAPI:(NSString *)messageText {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"send_message.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"message_sender=%@&message_receiver=%@&message_content=%@", self.app.userData[@"user_id"], self.chatterInfo[@"user_id"], messageText] forKey:@"requestBody"];
    
    [self.app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if (result.count > 0) {
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                // [self getMessages];
            }else{
                // [self failedSend:@"Oops! Message not sent this time, try again."];
            }
        }else{
            // [self failedSend:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

- (void)failedSend:(NSString *)str {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert  = nil;
}

#pragma mark - MXMessageCellFactoryDataSource

- (BOOL)cellFactory:(MXRMessageCellFactory *)cellFactory isMessageFromMeAtRow:(NSInteger)row {
    return [self.messages[row][@"MessageThread"][@"message_sender"] isEqualToString:self.app.userData[@"user_id"]];
}

- (NSURL *)cellFactory:(MXRMessageCellFactory *)cellFactory avatarURLAtRow:(NSInteger)row {
    return [self cellFactory:cellFactory isMessageFromMeAtRow:row] ? nil : [NSURL URLWithString:self.chatterInfo[@"user_pic"]];
}

- (NSTimeInterval)cellFactory:(MXRMessageCellFactory *)cellFactory timeIntervalSince1970AtRow:(NSInteger)row {
    // return self.messages[row].timestamp;
    return 0;
}

#pragma mark - ASTable

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *message = self.messages[indexPath.row][@"MessageThread"][@"message_content"];
    return [self.cellFactory cellNodeBlockWithText:message tableNode:tableNode row:indexPath.row];
}

#pragma mark - MXRMessageContentNodeDelegate

- (void)messageContentNode:(MXRMessageContentNode *)node didSingleTap:(id)sender {
    if (![node.supernode isKindOfClass:[MXRMessageCellNode class]]) return;
    MXRMessageCellNode* cellNode = (MXRMessageCellNode*)node.supernode;
    if ([node isKindOfClass:[MXRMessageImageNode class]]) {
        // present a media viewer
        NSLog(@"Single tapped an image");
        return;
    } else if ([node isKindOfClass:[MXRMessageTextNode class]]) {
        NSLog(@"Single tapped text");
        [self.cellFactory toggleDateHeaderNodeVisibilityForCellNode:cellNode];
    }
}

@end
