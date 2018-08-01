//
//  dualDetailsScr.m
//  Droop
//
//  Created by Himanshu Sharma on 16/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "dualDetailsScr.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>

@interface dualDetailsScr ()

@end

@implementation dualDetailsScr

@synthesize dualPBtn,dualImggV,dCaptionTV,dualPHolder,userDImg,userDHolder,shareDualBtn,cancelDualDetailBtn;
@synthesize dDtimestampLbl;
@synthesize ddScroller;
@synthesize dualPostedbypic;
@synthesize dnoFollowersLbl;
@synthesize dualPostedByBtn;
@synthesize dualLinkedProBtn;
@synthesize reportDualBtn;
@synthesize dualShareV,dualFBShareBtn,dualMsgShareBtn,dualShareCancel,dualShareTransV,dualShareConfBtn,dualEmailShareBtn,dualShareFollowersColl;
NSMutableArray *dFollowersArr, *dSelectedShareFollowers;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dSelectedShareFollowers = [[NSMutableArray alloc]init];
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    dualPHolder.layer.cornerRadius = dualPHolder.frame.size.height/2;
    dualPHolder.layer.masksToBounds = YES;
    
    
    
    CGRect frame = dualImggV.frame;
    frame.size.height = self.view.frame.size.width;
    dualImggV.frame = frame;
    
    int height;
    int x;
    if([[app.selVentureDict objectForKey:@"dual_linked_to"]isEqualToString:@"-1"]){
        height= [self returnSizeofLabel:[app.selVentureDict objectForKey:@"dual_caption"] width:self.view.frame.size.width-10];
        x = 5;
    }else{
        height= [self returnSizeofLabel:[app.selVentureDict objectForKey:@"dual_caption"] width:self.view.frame.size.width-67];
        x = 59;
    }
    
    if(height<61){
        height = 61;
    }
    CGRect udFrame = userDHolder.frame;
    udFrame.origin.y = frame.origin.y+frame.size.height;
    udFrame.size.height =height+dDtimestampLbl.frame.size.height+dCaptionTV.frame.origin.y+10;
    userDHolder.frame = udFrame;
    
    CGRect dcframe = dCaptionTV.frame;
    dcframe.origin.x = x;
    dcframe.size.height = height;
    dCaptionTV.frame = dcframe;
    
    CGRect dTSFrame = dDtimestampLbl.frame;
    dTSFrame.origin.x = x;
    dTSFrame.origin.y = dCaptionTV.frame.origin.y+dCaptionTV.frame.size.height;
    dDtimestampLbl.frame = dTSFrame;
    
    dCaptionTV.text = [app.selVentureDict objectForKey:@"dual_caption"];
    [self fetchDualMain];
    [self fetchUProfilePic];
    [self fetchpostedbypic];
    [self getFollowing];

    ddScroller.contentSize = CGSizeMake(ddScroller.frame.size.width, userDHolder.frame.origin.y+userDHolder.frame.size.height);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"dd MMM, yyyy";
    NSString *currD = [formatter stringFromDate:[NSDate date]];
    
    NSString *dualTime=[app.selVentureDict objectForKey:@"dual_date"];
    NSDate *dualD = [formatter dateFromString:dualTime];
    
    if([currD isEqualToString:[app.selVentureDict objectForKey:@"dual_date"]]){
        dDtimestampLbl.text = [app.selVentureDict objectForKey:@"dual_time"];
    }else{
        NSInteger daysdiff = [self daysBetweenDate:dualD andDate:[NSDate date]];
        if(daysdiff<=7){
            dDtimestampLbl.text = [NSString stringWithFormat:@"%d DAYS AGO",(int)daysdiff];
        }else{
            dDtimestampLbl.text =[app.selVentureDict objectForKey:@"dual_date"];
        }
    }
}

-(void)fetchpostedbypic{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSURL *imageUrl = [NSURL URLWithString:app.selVentureDict[@"dual_posted_pic"]];
    [dualPostedbypic setImageWithURL:imageUrl];
    
    dualPostedbypic.layer.cornerRadius = dualPostedbypic.frame.size.height/2;
    dualPostedbypic.layer.masksToBounds = YES;
}

-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

-(int)returnSizeofLabel:(NSString *)str width:(int)width{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    // CGSize expectedLabelSize = [str sizeWithFont:[UIFont fontWithName:@"Raleway-Bold" size:17] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    UIFont *labelFont = [UIFont fontWithName:@"Raleway-Bold" size:17];
    CGRect expectedLabelRect = [str boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: labelFont} context:nil];
    return expectedLabelRect.size.height;
}

-(void)fetchUProfilePic{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    __weak typeof(self) weakSelf = self;

    NSURL *imageUrl = [NSURL URLWithString:app.selVentureDict[@"dual_linked_profile_pic"]];
    [userDImg setImageWithURLRequest:[NSURLRequest requestWithURL:imageUrl] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        weakSelf.userDImg.image = image;
        [weakSelf.dualLinkedProBtn setHidden:NO];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        weakSelf.userDImg.hidden = YES;
    }];
    
    userDImg.layer.cornerRadius = userDImg.frame.size.height/2;
    userDImg.layer.borderColor = [UIColor colorWithRed:0.29 green:0.67 blue:0.61 alpha:1.0].CGColor;
    userDImg.layer.borderWidth = 1;
    userDImg.layer.masksToBounds = YES;
}

-(void)fetchDualMain{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    __weak typeof(self) weakSelf = self;
    
    NSURL *imageUrl = [NSURL URLWithString:app.selVentureDict[@"dual_image"]];
    [dualImggV setImageWithURLRequest:[NSURLRequest requestWithURL:imageUrl] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        weakSelf.dualImggV.image = image;
        weakSelf.shareDualBtn.hidden = NO;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
    }];
}

-(void)noFollowersFound{
    [dnoFollowersLbl setHidden:NO];
    [dualShareFollowersColl setHidden:YES];
}

-(void)getFollowing{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getFollowers.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                NSMutableArray *ddFollowersArr = [result objectForKey:@"followers"];
                NSMutableArray *d = [result objectForKey:@"following"];
                dFollowersArr = [[NSMutableArray alloc]init];
                for(int i =0;i<ddFollowersArr.count;i++){
                    [dFollowersArr addObject:[ddFollowersArr objectAtIndex:i]];
                }
                for(int i =0;i<d.count;i++){
                    [dFollowersArr addObject:[d objectAtIndex:i]];
                }
                //                if(d.count>0){
                //                    [dFollowersArr addObjectsFromArray:d];
                //                }
                //            }else{
                //                dFollowersArr = [result objectForKey:@"following"];
                //            }
                [self reloadCollection];
            }else{
                [self noFollowersFound];
            }
        }else{
            
        }
    }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *proSImg = (UIImageView *)[cell viewWithTag:100];
    UIImageView *sTickIcon = (UIImageView *)[cell viewWithTag:101];
    [cell layoutIfNeeded];
    
    NSDictionary *followerInfo = dFollowersArr[indexPath.row];
    
    NSURL *imageUrl = [NSURL URLWithString:followerInfo[@"user_pic"]];
    [proSImg setImageWithURL:imageUrl];
    
    int exist = [self ifAlreadySelected:followerInfo[@"user_id"]];
    if(exist!=-1){
        [sTickIcon setHidden:NO];
    }else{
        [sTickIcon setHidden:YES];
    }
    proSImg.layer.cornerRadius = 4;
    proSImg.layer.masksToBounds = YES;
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *followerInfo = dFollowersArr[indexPath.row];
    
    int isExist = [self ifAlreadySelected:followerInfo[@"user_id"]];
    if(isExist!=-1){
        NSMutableArray *temp = [dSelectedShareFollowers mutableCopy];
        [temp removeObjectAtIndex:isExist];
        dSelectedShareFollowers = nil;
        dSelectedShareFollowers = temp;
        temp = nil;
    }else{
        [dSelectedShareFollowers addObject:followerInfo];
    }
    [dualShareFollowersColl reloadData];
}


-(int)ifAlreadySelected:(NSString *)uid{
    int isExist = -1;
    for(int i = 0;i<dSelectedShareFollowers.count;i++){
        NSString *str = dSelectedShareFollowers[i][@"user_id"];
        if ([str isEqualToString:uid]){
            isExist = i;
            break;
        }
        
    }
    return isExist;
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    return size;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return dFollowersArr.count;
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)reloadCollection{
    [dnoFollowersLbl setHidden:YES];
    [dualShareFollowersColl reloadData];
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==cancelDualDetailBtn){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(sender==shareDualBtn){
        [dualShareTransV setHidden:NO];
        [UIView transitionWithView:dualShareV duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = dualShareV.frame;
            frame.origin.y = self.view.frame.size.height-dualShareV.frame.size.height;
            dualShareV.frame = frame;
        } completion:nil];
        
        
    }else if(sender==dualPBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"FinaliseDual"];
        app.window.rootViewController = view;
    }else if(sender==dualMsgShareBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        MFMessageComposeViewController *mail = [[MFMessageComposeViewController alloc]init];
        if([MFMessageComposeViewController canSendText]){
            [mail setBody:[NSString stringWithFormat:@"Check it out, shared via Droop - %@ : %@",[app.selVentureDict objectForKey:@"dual_caption"],[app.selVentureDict objectForKey:@"dual_image"]]];
            [mail setMessageComposeDelegate:self];
            [self presentViewController:mail animated:YES completion:nil];
        }else{
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:@"Oops! Seems like sending sms is not possible from your phone." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            
        }
    }else if(sender==dualEmailShareBtn){
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc]init];
        if([MFMailComposeViewController canSendMail]){
            __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            NSData *jpegdata = UIImageJPEGRepresentation(dualImggV.image, 1.0);
            [mail setSubject:@"Check this awesome Post on Droop"];
            NSString *filename =@"test";
            filename  = [filename stringByAppendingPathExtension:@"jpeg"];
            [mail addAttachmentData:jpegdata mimeType:@"image/jpeg" fileName:filename];
            [mail setMessageBody:[NSString stringWithFormat:@"Check it out, shared via Droop - %@",[app.selVentureDict objectForKey:@"dual_caption"]] isHTML:YES];
            
            [mail setMailComposeDelegate:self];
            [self presentViewController:mail animated:YES completion:nil];
        }else{
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:@"Oops! Seems like you  haven't configured your email on your phone." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            
        }
    }else if(sender==dualFBShareBtn){
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [controller setInitialText:[NSString stringWithFormat:@"%@ - Shared via Droop (Download today from App Store)",[app.selVentureDict objectForKey:@"dual_caption"]]];
            [controller addImage:dualImggV.image];
            [self presentViewController:controller animated:YES completion:Nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Oops! Seems like your haven't configured facebook on your phone." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
        }
        
        
    }else if(sender==dualShareCancel){
        
        [UIView transitionWithView:dualShareV duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = dualShareV.frame;
            frame.origin.y = self.view.frame.size.height;
            dualShareV.frame = frame;
        } completion:^(BOOL finished){
            [dualShareTransV setHidden:YES];
        }];
    }else if(sender==dualShareConfBtn){
        if(dSelectedShareFollowers.count>0){
            NSString *users = @"";
            for(int i =0;i<dSelectedShareFollowers.count;i++){
                if(i==0){
                    users = [[dSelectedShareFollowers objectAtIndex:i] objectForKey:@"user_id"];
                }else{
                    users = [NSString stringWithFormat:@"%@#%@",users,[[dSelectedShareFollowers objectAtIndex:i]objectForKey:@"user_id"]];
                }
            }
            [self shareDualAPI:users];
        }
    }else if(sender==dualPostedByBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([[app.userData objectForKey:@"user_id"] isEqualToString:[app.selVentureDict objectForKey:@"dual_posted_by"]]){
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"PROFILE"];
            __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            view.title = self.title;
          //  app.window.rootViewController =  view;
            [self presentViewController:view animated:NO completion:nil];
        }else{
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"OTHERUSER"];
            view.title = @"OTHER";
            app.proUserID = [app.selVentureDict objectForKey:@"dual_posted_by"];
            [self presentViewController:view animated:YES completion:nil];
        }
    }else if(sender==dualLinkedProBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([[app.userData objectForKey:@"user_id"] isEqualToString:[app.selVentureDict objectForKey:@"dual_linked_to"]]){
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"PROFILE"];
            __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            view.title = self.title;
            app.window.rootViewController =  view;
        }else{
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"OTHERUSER"];
            view.title = @"OTHER";
            app.proUserID = [app.selVentureDict objectForKey:@"dual_linked_to"];
            [self presentViewController:view animated:YES completion:nil];
        }
    }else if(sender==reportDualBtn){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you find this Dual Post wrong, report us and we will review your request." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Report", nil];
        [alert show];
        alert = nil;
    }
}

-(void)reportDuals{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"reportDual.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"dual_id=%@",[app.selVentureDict objectForKey:@"dual_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self failed:@"Thank you! For helping us to keep the community clean, our team will review the report soon. Till then we removed the content from app."];
                [self reportedDualSuccess];
            }else{
                [self failed:@"Oops! Something went wrong, please try again. If problem persists, contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)failed:(NSString *)str{
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(void)reportedDualSuccess{
    [self buttonPressed:cancelDualDetailBtn];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self.view setUserInteractionEnabled:NO];
        [self reportDuals];
    }
}

-(void)shareDualAPI:(NSString *)str{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *m = [NSString stringWithFormat:@"%@ shared a dual with you.", [app.userData objectForKey:@"user_name"]];
    [dict setObject:[NSString stringWithFormat:@"dual_id=%@&shared_by=%@&shared_by_name=%@&share_with=%@&message_content=%@",[app.selVentureDict objectForKey:@"dual_id"],[app.userData objectForKey:@"user_id"],[app.userData objectForKey:@"user_name"],str,m] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        NSLog(@"Result: %@", result);
    }];
}

-(void)didReceiveMemoryWarning {
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

