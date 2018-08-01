//
//  notificationsScr.m
//  Droop
//
//  Created by Himanshu Sharma on 05/12/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "notificationsScr.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>

@interface notificationsScr ()

@end

@implementation notificationsScr

@synthesize notificationBack,notificationsTbl;
@synthesize clearBtn;
@synthesize clearIndicator;
@synthesize clearic;
@synthesize dualApprovalCaptionTxt;
@synthesize dualApprovalLbl,dualApprovalView,dualApprovalImage,dualApprovalScroll,dualAprrovalCancelBtn;
@synthesize dualApprovalConfBtn;
@synthesize dualApprovalHeaderLbl;
@synthesize hideDABtn;
NSMutableArray *notificationsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    notificationsArray = [[NSMutableArray alloc]init];
    // [notificationsTbl reloadData];
    [self getNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refetchNotification) name:@"REFETCHNOTIFICATION" object:nil];
    
    CGRect f =dualApprovalImage.frame;
    f.size.width = self.view.frame.size.width;
    f.size.height = self.view.frame.size.width;
    dualApprovalImage.frame = f;
    
    CGRect dACF = dualApprovalHeaderLbl.frame;
    dACF.origin.y = dualApprovalImage.frame.origin.y+dualApprovalImage.frame.size.height+14;
    dualApprovalHeaderLbl.frame = dACF;
    
    CGRect dACT = dualApprovalCaptionTxt.frame;
    dACT.origin.y = dualApprovalHeaderLbl.frame.origin.y+dualApprovalHeaderLbl.frame.size.height+6;
    dualApprovalCaptionTxt.frame = dACT;
    
    CGRect dACB = dualApprovalConfBtn.frame;
    dACB.origin.y = dualApprovalCaptionTxt.frame.origin.y+dualApprovalCaptionTxt.frame.size.height+20;
    dualApprovalConfBtn.frame = dACB;
    
    dualApprovalConfBtn.layer.cornerRadius = dualApprovalConfBtn.frame.size.height/2;
    dualApprovalConfBtn.layer.masksToBounds = YES;
    
    dualApprovalScroll.contentSize = CGSizeMake(dualApprovalScroll.frame.size.width, dualApprovalConfBtn.frame.origin.y+dualApprovalConfBtn.frame.size.height+10);
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refetchNotification{
    [self getNotifications];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"Enter Caption Here ..."]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [hideDABtn setHidden:NO];
    CGRect fScroll = dualApprovalScroll.frame;
 //   fScroll.size.height = self.view.frame.size.height-216;
    fScroll.origin.y  = self.view.frame.origin.y-216;
    dualApprovalScroll.frame = fScroll;
    
    return YES;
}

-(int)returnSizeofLabel:(NSString *)str width:(int)width{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    // CGSize expectedLabelSize = [str sizeWithFont:[UIFont fontWithName:@"Raleway-Medium" size:17] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    UIFont *labelFont = [UIFont fontWithName:@"Raleway-Medium" size:17];
    CGRect expectedLabelRect = [str boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: labelFont} context:nil];
    return expectedLabelRect.size.height;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(text.length>0){
        if(textView.text.length>=55){
            return NO;
        }
    }
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
        int height = [self returnSizeofLabel:completeMsg width:dualApprovalCaptionTxt.frame.size.width];
        if(height>100){
            height = 100;
        }else if(height<30){
            height = 30;
        }
        
        CGRect tFrame = dualApprovalCaptionTxt.frame;
        tFrame.size.height = height;
        dualApprovalCaptionTxt.frame = tFrame;
    }else{
        int height = 30;

        CGRect tFrame = dualApprovalCaptionTxt.frame;
        tFrame.size.height = height;
        dualApprovalCaptionTxt.frame = tFrame;
    }
    
    CGRect dACB = dualApprovalConfBtn.frame;
    dACB.origin.y = dualApprovalCaptionTxt.frame.origin.y+dualApprovalCaptionTxt.frame.size.height+20;
    dualApprovalConfBtn.frame = dACB;
    
    dualApprovalScroll.contentSize = CGSizeMake(dualApprovalScroll.frame.size.width, dualApprovalConfBtn.frame.origin.y+dualApprovalConfBtn.frame.size.height+10);
    
    return YES;
}

-(void)reloadTable{
    [self.view setUserInteractionEnabled:YES];
    [clearic setHidden:NO];
    [clearIndicator setHidden:YES];
    [notificationsTbl reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return notificationsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)reloadCell:(NSIndexPath *)index{
    @try{
        [notificationsTbl reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationNone];
    }@catch(NSException *r){}
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UIImageView *proPic = (UIImageView *)[cell viewWithTag:100];
    UILabel *notificationTxt = (UILabel *)[cell viewWithTag:101];
    
    NSDictionary *notificationInfo = notificationsArray[indexPath.row];
    
    notificationTxt.text = notificationInfo[@"notification_txt"];
    
    NSURL *imageUrl = [NSURL URLWithString:notificationInfo[@"user_pic"]];
    [proPic setImageWithURL:imageUrl];
    
    proPic.layer.cornerRadius = proPic.frame.size.height/2;
    proPic.layer.borderColor = [UIColor colorWithRed:0.29 green:0.67 blue:0.61 alpha:1.0].CGColor;
    proPic.layer.borderWidth = 1;
    proPic.layer.masksToBounds = YES;

    return cell;
}

-(void)getNotifications{
    notificationsArray = [[NSMutableArray alloc] init];
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getNotifications.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                notificationsArray = [result objectForKey:@"data"];
                [self markReadNotification];
                [self reloadTable];
            }else{
                
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)markReadNotification{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"marknotification.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        NSLog(@"Result: %@", result);
    }];
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==notificationBack){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"PROFILE"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
  //      app.window.rootViewController =  view;
        [self presentViewController:view animated:NO completion:nil];
    }else if(sender==clearBtn){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to clear all your notifications?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    }else if(sender==dualAprrovalCancelBtn){
        [dualApprovalView setHidden:YES];
        dualApprovalImage.image = nil;
        CGRect f = dualApprovalScroll.frame;
        f.size.height = self.view.frame.size.height;
        dualApprovalScroll.frame = f;
        [dualApprovalCaptionTxt resignFirstResponder];
    }else if(sender==hideDABtn){
        if(dualApprovalCaptionTxt.text.length==0){
            dualApprovalCaptionTxt.text = @"Enter Caption Here ...";
            dualApprovalCaptionTxt.textColor = [UIColor darkGrayColor];
        }
        
        CGRect f = dualApprovalScroll.frame;
  //      f.size.height = self.view.frame.size.height;
        f.origin.y  = self.view.frame.origin.y;
        dualApprovalScroll.frame = f;
        [dualApprovalCaptionTxt resignFirstResponder];
        
    }else if(sender==dualApprovalConfBtn){
        if(dualApprovalCaptionTxt.text.length==0 || [dualApprovalCaptionTxt.text isEqualToString:@"Enter Caption Here ..."]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Oops! Seems like you forgot to enter caption to this dual." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            return;
        }
        CGRect f = dualApprovalScroll.frame;
        f.size.height = self.view.frame.size.height;
        dualApprovalScroll.frame = f;
        [dualApprovalCaptionTxt resignFirstResponder];
        
        [self updateCaptionAPI];
    }
}

-(void)updatedSuccess{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Dual is updated and live now!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    alert = nil;
    [self buttonPressed:dualAprrovalCancelBtn];
}

-(void)updateCaptionAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"updateDual.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"dual_id=%@&dual_caption=%@&dual_posted_by=%@&dual_user_name=%@&dual_updated_by=%@",[app.selVentureDict objectForKey:@"dual_id"],dualApprovalCaptionTxt.text,[app.selVentureDict objectForKey:@"dual_posted_by"],[app.selVentureDict objectForKey:@"dual_linked_name"],[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self updatedSuccess];
            }else{
                [self failed:@"Oops! Seems like we are having trouble rite now, please try again if problem persists contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [clearIndicator setHidden:NO];
        [clearic setHidden:YES];
        [self.view setUserInteractionEnabled:NO];
        [self clearNotificationAPI];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *notificationInfo = notificationsArray[indexPath.row];
    
    NSString *notificationTxt = notificationInfo[@"notification_txt"];
    NSRange range = [notificationTxt rangeOfString:@"posted a dual with you" options:NSCaseInsensitiveSearch];
    NSRange range1 = [notificationTxt rangeOfString:@"shared a dual with you" options:NSCaseInsensitiveSearch];
    NSRange range2 = [notificationTxt rangeOfString:@"shared a Ad Venture with you" options:NSCaseInsensitiveSearch];
    
    if(range.length>0){
        //Dual posted with this user
        [self.view setUserInteractionEnabled:NO];
        [self getDualDetails:notificationInfo[@"notification_dual_id"]];
    }else if(range1.length>0){
        //Shared dual with user
        [self.view setUserInteractionEnabled:NO];
        [self getDualDetails:notificationInfo[@"notification_dual_id"]];
    }else if(range2.length>0){
        //Shared venture with user
        [self.view setUserInteractionEnabled:NO];
        [self getVentureDetails:notificationInfo[@"notification_venture_id"]];
    }else{
        [self.view setUserInteractionEnabled:NO];
        [self getDualDetails:notificationInfo[@"notification_dual_id"]];
    }
    [notificationsTbl reloadData];
}

-(void)setDualImage:(UIImage *)img{
    dualApprovalImage.image = img;
}
// show dual screen

-(void)showDualScreen{
    [self.view setUserInteractionEnabled:YES];
    
     __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    __unsafe_unretained AppDelegate app = (AppDelegate )[[UIApplication sharedApplication]delegate];
    if([[app.selVentureDict objectForKey:@"dual_caption"] isEqualToString:@"Not Provided"]){
        
        dualApprovalLbl.text = [NSString stringWithFormat:@"%@ posted a dual with you.", [app.selVentureDict objectForKey:@"dual_posted_name"]];
        [dualApprovalImage setImageWithURL:[NSURL URLWithString:app.selVentureDict[@"dual_image"]]];
        [dualApprovalView setHidden:NO];
        //        CGRect rect  =  CGRectMake(dualApprovalView.frame.origin.x+20, dualApprovalView.frame.origin.y+10, 180, 400);
        CGRect rect  =  CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [dualApprovalView setFrame:rect];
        dualApprovalScroll.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width*3);
        
    }else{
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"DUALDETAILS"];
        [self presentViewController:view animated:YES completion:nil];
    }
}

-(void)getVentureDetails:(NSString *)venture_id{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getVentureDet.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"venture_id=%@",venture_id] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                app.selVentureDict = [result objectForKey:@"data"];
                [self showVentureScreen];
            }else{
                [self.view setUserInteractionEnabled:NO];
                [self failed:@"Oops! Seems like the Ad Venture has been deleted."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)showVentureScreen{
    [self.view setUserInteractionEnabled:YES];
    UIStoryboard *story = self.storyboard;
    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"VENTUREPRE"];
    view.title = @"MODAL";
    [self presentViewController:view animated:NO completion:nil];
}

-(void)getDualDetails:(NSString *)dual_id{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getDualDet.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"dual_id=%@",dual_id] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                app.selVentureDict = [result objectForKey:@"data"];
                [self showDualScreen];
            }else{
                [self.view setUserInteractionEnabled:NO];
                [self failed:@"Oops! Seems like the dual has been deleted."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)clearNotificationAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"deleteNotifications.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                notificationsArray = [[NSMutableArray alloc] init];
                [self reloadTable];
            }else{
                [self failed:@"Oops! Seems like we are having trouble to complete your request, please try again if problem persists contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)failed:(NSString *)str{
    [self.view setUserInteractionEnabled:YES];
    [clearic setHidden:NO];
    [clearIndicator setHidden:YES];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
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
