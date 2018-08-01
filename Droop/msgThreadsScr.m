//
//  msgThreadsScr.m
//  Droop
//
//  Created by Himanshu Sharma on 03/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "msgThreadsScr.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>
#import "ChatViewController.h"

@interface msgThreadsScr ()

@end

@implementation msgThreadsScr

@synthesize threadTbl,threadHomeBtn,threadPostBtn,threadprofileBtn,threadDiscoverScr;
@synthesize mSearchTxt;
@synthesize msgThreadBackBtn;
@synthesize msgThreadNotificationIndicator;

NSMutableArray *threadsArr;
NSMutableArray *searchThreadsArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadThreads) name:@"CHATTHREADRELOAD" object:nil];
    [self getNotificationsCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refetchNotification) name:@"MSGTHREADNOTIFYCOUNT" object:nil];
    msgThreadNotificationIndicator.layer.cornerRadius = msgThreadNotificationIndicator.frame.size.height/2;
    msgThreadNotificationIndicator.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refetchNotification{
    [self getNotificationsCount];
}

-(void)getNotificationsCount{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getNotifications.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                NSMutableArray *arr = [result objectForKey:@"data"];
                int counter = 0;
                for(int i =0;i<arr.count;i++){
                    NSString *isunread = [[arr objectAtIndex:i] objectForKey:@"isunread"];
                    if([isunread isEqualToString:@"YES"]){
                        counter = counter+1;
                    }
                }
                if(counter>0){
                    [self notificationfound];
                }else{
                    [self nonotifications];
                }
            }else{
                [self nonotifications];
            }
        }else{
            
        }
    }];
}

-(void)notificationfound{
    [msgThreadNotificationIndicator setHidden:NO];
}

-(void)nonotifications{
    [msgThreadNotificationIndicator setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    threadsArr = [[NSMutableArray alloc]init];
    [self getThreads];
}

-(void)reloadThreads{
    [self getThreads];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.text.length>0){
        searchThreadsArr = [[NSMutableArray alloc]init];
        for(int i =0;i<threadsArr.count;i++){
            NSString *uNa = [[[threadsArr objectAtIndex:i] objectForKey:@"UserDetails"] objectForKey:@"user_name"];
            NSString *uContent = [[[threadsArr objectAtIndex:i] objectForKey:@"MessageThread"] objectForKey:@"message_content"];
            
            NSRange range = [uNa rangeOfString:mSearchTxt.text options:NSCaseInsensitiveSearch];
            NSRange r1 =[uContent rangeOfString:mSearchTxt.text options:NSCaseInsensitiveSearch];
            if(range.length>0 || r1.length>0){
                [searchThreadsArr addObject:[threadsArr objectAtIndex:i]];
            }
        }
        mSearchTxt.tag=1;
        [threadTbl reloadData];
    }else{
        mSearchTxt.tag=0;
        [threadTbl reloadData];
    }
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==threadHomeBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.window.rootViewController = view;
    }else if(sender==threadprofileBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"PROFILE"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if(![msgThreadNotificationIndicator isHidden]){
            view.title = @"YES";
        }else{
            view.title = @"NO";
        }
        //app.window.rootViewController =  view;
        [self presentViewController:view animated:NO completion:nil];
    }else if(sender==threadPostBtn){
//        UIStoryboard *story = self.storyboard;
//        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ADDPOST"];
//        [self presentViewController:view animated:YES completion:nil];
        
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"FinaliseDual"];
        [self presentViewController:view animated:YES completion:nil];
    }else if(sender==threadDiscoverScr){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"DISCOVER"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.window.rootViewController =  view;
    }else if(sender==msgThreadBackBtn){
        if([self.title isEqualToString:@"HOME"]){
            [self buttonPressed:threadHomeBtn];
        }else if([self.title isEqualToString:@"DISCOVER"]){
            [self buttonPressed:threadDiscoverScr];
        }else if([self.title isEqualToString:@"PROFILE"]){
            [self buttonPressed:threadprofileBtn];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(mSearchTxt.tag==0){
        return threadsArr.count;
    }else{
        return searchThreadsArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*if(mSearchTxt.tag==0){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"CHATSCR"];
        view.title = [[[threadsArr objectAtIndex:indexPath.row] objectForKey:@"UserDetails"] objectForKey:@"user_id"];
        [self presentViewController:view animated:NO completion:nil];
    }else{
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"CHATSCR"];
        view.title = [[[searchThreadsArr objectAtIndex:indexPath.row] objectForKey:@"UserDetails"] objectForKey:@"user_id"];
        [self presentViewController:view animated:NO completion:nil];
    }*/
    
    NSDictionary *chatterInfo;
    if (mSearchTxt.tag == 0) {
        //chatterInfo = threadsArr[indexPath.row][@"UserDetails"];
        chatterInfo = threadsArr[indexPath.row][@"Opposite"];
    } else {
        //chatterInfo = searchThreadsArr[indexPath.row][@"UserDetails"];
        chatterInfo = searchThreadsArr[indexPath.row][@"Opposite"];
    }
    
    ChatViewController *chatController = [[ChatViewController alloc] initWithPerson:chatterInfo];
    [self presentViewController:chatController animated:NO completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UIImageView *senderPic = (UIImageView *)[cell viewWithTag:100];
    UILabel *senderName = (UILabel *)[cell viewWithTag:101];
    UILabel *msglbl   = (UILabel *)[cell viewWithTag:102];
    
    if(mSearchTxt.tag==0){
        NSDictionary *threadInfo = threadsArr[indexPath.row];
        
        msglbl.text = threadInfo[@"MessageThread"][@"message_content"];
        senderName.text = threadInfo[@"UserDetails"][@"user_name"];
        
        NSURL *imageUrl = [NSURL URLWithString:threadInfo[@"UserDetails"][@"user_pic"]];
        [senderPic setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defpic.png"]];
        
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(![[app.userData objectForKey:@"user_id"] isEqualToString:threadInfo[@"MessageThread"][@"message_sender"]])  {
            
            NSString *isunread = threadInfo[@"MessageThread"][@"isunread"];
            if([isunread isEqualToString:@"YES"]){
                msglbl.font = [UIFont fontWithName:@"Raleway-Bold" size:14];
            }else{
                msglbl.font = [UIFont fontWithName:@"Raleway-Regular" size:14];
            }
        }
        
    }else{
        NSDictionary *threadInfo = searchThreadsArr[indexPath.row];
        
        msglbl.text = threadInfo[@"MessageThread"][@"message_content"];
        senderName.text = threadInfo[@"UserDetails"][@"user_name"];
        
        NSURL *imageUrl = [NSURL URLWithString:threadInfo[@"UserDetails"][@"user_pic"]];
        [senderPic setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defpic.png"]];
        
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(![[app.userData objectForKey:@"user_id"] isEqualToString:threadInfo[@"MessageDetails"][@"message_sender"]])  {
            
            NSString *isunread = threadInfo[@"MessageDetails"][@"isunread"];
            if([isunread isEqualToString:@"YES"]){
                msglbl.font = [UIFont fontWithName:@"Raleway-Bold" size:14];
            }else{
                msglbl.font = [UIFont fontWithName:@"Raleway-Regular" size:14];
            }
        }
    }
    
    return cell;
}


-(void)reloadTable{
    [threadTbl reloadData];
}

-(void)getThreads{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getThread.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                threadsArr = [result objectForKey:@"data"];
                NSLog(@"%@", threadsArr);
                [self reloadTable];
            }else{
                threadsArr = [[NSMutableArray alloc]init];
                [self reloadTable];
            }
        }else{
            //Connection Error
        }
    }];
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

