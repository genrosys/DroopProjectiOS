//
//  msgsScr.m
//  Droop
//
//  Created by Himanshu Sharma on 03/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "msgsScr.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>
#import <AFImageDownloader.h>

@interface msgsScr ()

@end

@implementation msgsScr

@synthesize msgsTbl,msgTxtField,msgSendHolder,sendMsgB,sendMsgArr,indicatorSendMsg,roundsendmsgback;
@synthesize friendImgV,friendNameLbl;
@synthesize chatBackBtn;
@synthesize mainIndicator;
@synthesize friendViewProBtn;
@synthesize clearChatBtn;
NSMutableDictionary *friendDict;
NSMutableArray *chatsArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    roundsendmsgback.layer.cornerRadius = roundsendmsgback.frame.size.height/2;
    roundsendmsgback.layer.borderColor = [UIColor lightGrayColor].CGColor;
    roundsendmsgback.layer.borderWidth = 1;
    roundsendmsgback.layer.masksToBounds = YES;
    
    [self getMessages];
    
    friendImgV.layer.cornerRadius = friendImgV.frame.size.height/2;
    friendImgV.layer.masksToBounds = YES;

    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(terminateKeyboard:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChat) name:@"MSGSRELOAD" object:nil];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadChat{
    if(friendDict.count>0){
        [self getMessages];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(friendDict.count>0){
        [self getMessages];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    CGRect frame = msgSendHolder.frame;
    frame.origin.y = self.view.frame.size.height-msgSendHolder.frame.size.height;
    msgSendHolder.frame = frame;
    
    CGRect f = msgsTbl.frame;
    f.size.height = msgSendHolder.frame.origin.y-64;
    msgsTbl.frame = f;
    
    return YES;
}

-(void)terminateKeyboard:(UIGestureRecognizer *)gesture{
    if(gesture.state==UIGestureRecognizerStateEnded){
        [self.view endEditing:YES];
        if(msgTxtField.text.length==0){
            msgTxtField.text = @"Write Message Here...";
            msgTxtField.textColor = [UIColor darkGrayColor];
        }
        CGRect frame = msgSendHolder.frame;
        frame.origin.y = self.view.frame.size.height-msgSendHolder.frame.size.height;
        msgSendHolder.frame = frame;
        
        CGRect f = msgsTbl.frame;
        f.size.height = msgSendHolder.frame.origin.y-64;
        msgsTbl.frame = f;
    }
}

- (void)updateUser {
    friendNameLbl.text = friendDict[@"user_name"];
    [friendImgV setImageWithURL:[NSURL URLWithString:friendDict[@"user_pic"]]];
    
    [self reloadTable];
}

-(void)markRead{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"markRead.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@&sender_id=%@",[app.userData objectForKey:@"user_id"],[friendDict objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            
        }else{
            
        }
    }];
}

-(void)reloadTable{
    [self.view setUserInteractionEnabled:YES];
    
    [indicatorSendMsg setHidden:YES];
    [sendMsgArr setHidden:NO];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:[chatsArr count] - 1 inSection:0];
        [msgsTbl scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    [msgsTbl reloadData];
    [CATransaction commit];
    
    [self.view endEditing:YES];
    msgTxtField.text = @"Write Message Here...";
    CGRect frame = msgSendHolder.frame;
    frame.origin.y = self.view.frame.size.height - msgSendHolder.frame.size.height;
    msgSendHolder.frame = frame;
    
    CGRect f = msgsTbl.frame;
    f.size.height = msgSendHolder.frame.origin.y-64;
    msgsTbl.frame = f;
    [mainIndicator setHidden:YES];
}

-(void)getMessages{

    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getmessages.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@&friend_id=%@",[app.userData objectForKey:@"user_id"],self.title] forKey:@"requestBody"];
    NSString* mycheck = [NSString stringWithFormat:@"pmh>>>user_id=%@&friend_id=%@",[app.userData objectForKey:@"user_id"],self.title];
    NSLog(@"pmh>>>%@",mycheck);
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                friendDict = [result objectForKey:@"userD"];
                chatsArr = [result objectForKey:@"data"];
                [self updateUser];
            }else{
                friendDict = [result objectForKey:@"userD"];
                chatsArr = [[NSMutableArray alloc]init];
                [self updateUser];
            }
            [self markRead];
        }else{
            [self failed];
        }
    }];
}

-(void)failed{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:@"Oops! Seems like a connection issue, please check and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(int)returnSizeofLabel:(NSString *)str width:(int)width{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    UIFont *labelFont = [UIFont fontWithName:@"Raleway-Regular" size:19];
    CGRect expectedLabelSize = [str boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: labelFont} context:nil];
    return expectedLabelSize.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height =42+[self returnSizeofLabel:[[[chatsArr objectAtIndex:indexPath.row]objectForKey:@"MessageThread"]objectForKey:@"message_content"] width:self.view.frame.size.width-74];
    return height;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *completeMsg = @"";
    if(textView.text.length>0){
        if(text.length>0){
            completeMsg = [NSString stringWithFormat:@"%@%@",textView.text,text];
        }else{
            completeMsg = [textView.text substringToIndex:textView.text.length-1];
        }
    }else{
        if(text.length>0){
            completeMsg = text;
        }
    }
    
    if(completeMsg.length>0){
        int height = [self returnSizeofLabel:completeMsg width:msgTxtField.frame.size.width];
        if(height>100){
            height = 100;
        }else if(height<30){
            height = 30;
        }
        
        CGRect frame = msgSendHolder.frame;
        frame.size.height = height+17;
        frame.origin.y = self.view.frame.size.height-216-frame.size.height;
        msgSendHolder.frame = frame;
        
        CGRect rFrame = roundsendmsgback.frame;
        rFrame.size.height = height+7;
        
        roundsendmsgback.frame = rFrame;
        
        CGRect tFrame = msgTxtField.frame;
        tFrame.size.height = height;
        msgTxtField.frame = tFrame;
    }else{
        int height = 30;
        
        CGRect frame = msgSendHolder.frame;
        frame.size.height = height+17;
        frame.origin.y = self.view.frame.size.height-216-frame.size.height;
        msgSendHolder.frame = frame;
        
        CGRect rFrame = roundsendmsgback.frame;
        rFrame.size.height = height+7;
        
        roundsendmsgback.frame = rFrame;
        
        CGRect tFrame = msgTxtField.frame;
        tFrame.size.height = height;
        msgTxtField.frame = tFrame;
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *sender = chatsArr[indexPath.row][@"MessageThread"][@"message_sender"];
    
    UITableViewCell *cell;
    if([sender isEqualToString:app.userData[@"user_id"]]){
        //Me
        cell = [tableView dequeueReusableCellWithIdentifier:@"MeCell"];
    }else{
        //You
        cell = [tableView dequeueReusableCellWithIdentifier:@"YouCell"];
    }
    
    UIView *msgBackView = (UIView *)[cell viewWithTag:100];
    UILabel *msgLbl = (UILabel *)[msgBackView viewWithTag:101];
    UIImageView *imgV = (UIImageView *)[cell viewWithTag:999];
    
    if([sender isEqualToString:app.userData[@"user_id"]]){
        [imgV setImageWithURL:[NSURL URLWithString:app.userData[@"user_pic"]]];
    }else{
        [imgV setImageWithURL:[NSURL URLWithString:friendDict[@"user_pic"]]];
    }
    
    NSString *msg = chatsArr[indexPath.row][@"MessageThread"][@"message_content"];
    int height = [self returnSizeofLabel:msg width:self.view.frame.size.width-74];
    CGRect frame = msgBackView.frame;
    frame.size.height = height+22;
    msgBackView.frame = frame;
    
    CGRect f = msgLbl.frame;
    f.size.height = height;
    msgLbl.frame = f;
    msgLbl.text = msg;
    
    return cell;
}

-(void)failedSend:(NSString *)str{
    [self.view setUserInteractionEnabled:YES];
    [indicatorSendMsg setHidden:YES];
    [sendMsgArr setHidden:NO];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert  = nil;
}

-(void)sendMessageAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"send_message.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"message_sender=%@&message_receiver=%@&message_content=%@",[app.userData objectForKey:@"user_id"],self.title,msgTxtField.text] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self getMessages];
            }else{
                [self failedSend:@"Oops! Message not sent this time, try again."];
            }
        }else{
            [self failedSend:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==chatBackBtn){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(sender==sendMsgB){
        if(msgTxtField.text.length==0){
            return;
        }
        [self.view setUserInteractionEnabled:NO];
        [indicatorSendMsg setHidden:NO];
        [sendMsgArr setHidden:YES];
        [self sendMessageAPI];
        
    }else if(sender==friendViewProBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"OTHERUSER"];
        view.title = @"OTHER";
        app.proUserID = [friendDict objectForKey:@"user_id"];
        [self presentViewController:view animated:YES completion:nil];
    }else if(sender==clearChatBtn){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you really want to clear this chat? You won't be able to access it again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Clear", @"Cancel", nil];
        [alert show];
        alert = nil;
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==0){
        [self.view setUserInteractionEnabled:NO];
        [self clearChatAPI];
    }
}
-(void)clearChatAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *isdeleted = [app.userData objectForKey:@"user_id"];
    if(![[[[chatsArr objectAtIndex:0 ]objectForKey:@"MessageThread"] objectForKey:@"is_deleted"] isEqualToString:@"NO"]){
        isdeleted = @"BOTH";
    }
    
    [dict setObject:@"clearchat.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@&friend_id=%@&is_deleted=%@",[app.userData objectForKey:@"user_id"],self.title,isdeleted] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status  = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self clearedSuccess];
            }else{
                [self failed:@"Oops! Something went wrong, please try again. If problem persists, contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)clearedSuccess{
    [self buttonPressed:chatBackBtn];
}

-(void)failed:(NSString *)str{
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert= nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return chatsArr.count;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGRect frame = msgSendHolder.frame;
    frame.origin.y = self.view.frame.size.height-216-msgSendHolder.frame.size.height;
    msgSendHolder.frame = frame;
    CGRect f = msgsTbl.frame;
    f.size.height = msgSendHolder.frame.origin.y-64;
    msgsTbl.frame = f;
    
    if([textView.text isEqualToString:@"Write Message Here..."]){
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
