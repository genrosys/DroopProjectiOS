//
//  myProfileScr.m
//  Droop
//
//  Created by apple on 03/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "myProfileScr.h"
#import "AppDelegate.h"
#import "Utils.h"
#import <UIImageView+AFNetworking.h>

@interface myProfileScr ()

@end

@implementation myProfileScr

@synthesize proMsgBtn,proHomeBtn,proLiveBtn,proAddPostBtn,editProBtn;
@synthesize proLiveV,proVentureV,proLiveScroller,proMainScroller,proVentureScroller,proDualPostScroller;
@synthesize proLocationTxt,prouserNameTxt;
@synthesize demoPro1,demoPro2;
@synthesize changePicHolder,changeProfilePicBtn;
@synthesize editIcon;
@synthesize updateLoader;
@synthesize proprofilePic;
@synthesize previewImg,picPreviewHolder;
@synthesize viewsScroller;
@synthesize dualPostColl;
@synthesize nuberOfViewsLbl;
@synthesize followersBtn,followersLbl,followingBtn,followingLbl,followingView;
@synthesize pNoDualsLbl;
@synthesize pMsgIndicator,pMsgunreadCount;
@synthesize settingBtn;
@synthesize isnotification;
@synthesize notificationsBtn;
@synthesize msgBackBtn;

NSIndexPath *indexx;
NSMutableArray *followersArr,*followingArr;
NSMutableArray *userVenturesArr;
NSMutableArray *userDualsArr;
UIImage *imgg;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pMsgIndicator.layer.cornerRadius = pMsgIndicator.frame.size.height/2;
    pMsgIndicator.layer.masksToBounds = YES;
    
    //size of main view
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    proMainScroller.contentSize = CGSizeMake(proMainScroller.frame.size.width, dualPostColl.frame.origin.y+dualPostColl.frame.size.height+10);
    
    prouserNameTxt.text = [app.userData objectForKey:@"user_name"];
    NSString *numberViewsStr =[app.userData objectForKey:@"user_views"];
    int numberViews = [numberViewsStr intValue];
    if(numberViews<999){
        nuberOfViewsLbl.text = [NSString stringWithFormat:@"%d",numberViews];
    }else{
        nuberOfViewsLbl.text = [NSString stringWithFormat:@"%@",[self suffixNumber:[NSNumber numberWithInt:numberViews]]];
    }
    
    CGRect pF = previewImg.frame;
    pF.size.height = self.view.frame.size.width;
    pF.size.width  = self.view.frame.size.width;
    pF.origin.y = (self.view.frame.size.height-self.view.frame.size.width)/2;
    previewImg.frame = pF;
    
    NSString *loc = [app.userData objectForKey:@"user_location"];
    if([loc isEqualToString:@"NA"]){
        proLocationTxt.text = @"City not available";
    }else{
        proLocationTxt.text = loc;
    }
    
    [self fetchProfilePic];
    
    changePicHolder.layer.cornerRadius = changePicHolder.frame.size.height/2;
    changePicHolder.layer.masksToBounds = YES;
    proprofilePic.layer.cornerRadius = proprofilePic.frame.size.height/2;
    proprofilePic.layer.borderColor = [UIColor colorWithRed:0.53 green:0.12 blue:0.47 alpha:1.0].CGColor;
    proprofilePic.layer.borderWidth = 1;
    proprofilePic.layer.masksToBounds = YES;
    
    isnotification.layer.cornerRadius = isnotification.frame.size.height/2;
    isnotification.layer.masksToBounds = YES;
    if([self.title isEqualToString:@"YES"]){
        [isnotification setHidden:NO];
    }else{
        [isnotification setHidden:YES];
    }
    previewImg.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width);
    
    demoPro2.layer.cornerRadius = demoPro2.frame.size.height/2;
    demoPro2.layer.masksToBounds = YES;
    
    demoPro1.layer.cornerRadius = demoPro1.frame.size.height/2;
    demoPro1.layer.borderColor = [UIColor whiteColor].CGColor;
    demoPro1.layer.borderWidth = 2;
    demoPro1.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *showPreTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPreview:)];
    showPreTap.numberOfTapsRequired = 1;
    [proprofilePic setUserInteractionEnabled:YES];
    [proprofilePic addGestureRecognizer:showPreTap];
    
    UITapGestureRecognizer *hidePreTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePreview:)];
    hidePreTap.numberOfTapsRequired = 1;
    [picPreviewHolder setUserInteractionEnabled:YES];
    [picPreviewHolder addGestureRecognizer:hidePreTap];
    
    [self getUserVentures];
    [self getFollowing];
    [self getUserDuals];
    [self getThreads];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCount) name:@"REFRESHPROCOUNT" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationShow) name:@"PRONOTIFYSHOW" object:nil];
    
    // Do any additional setup after loading the view.
 }

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if([self.title isEqualToString:@"YES"]){
        [isnotification setHidden:NO];
    }else{
        [isnotification setHidden:YES];
    }
}

-(void)notificationShow{
    [isnotification setHidden:NO];
}

-(IBAction)delDualPost:(UIButton *)btn{
      UICollectionViewCell *cell = (UICollectionViewCell *)[[btn superview]superview];
     if(cell){
     indexx = [dualPostColl indexPathForCell:cell];
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you really want to delete Dual Post?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
     alert.tag=2;
     [alert show];
     }
}

-(IBAction)delVentureBtnTapped:(UIButton *)btn{
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[[btn superview]superview];
}

-(void)delDualPost{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"deldualpost.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"dualid=%@",[[userDualsArr objectAtIndex:indexx.row]objectForKey:@"dual_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self getUserDuals];
            }else{
                [self failed:@"Oops! We are having trouble completing your request. Please try again, if problem persists contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)delAdVenture{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"delVenture.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"ventureid=%@",[[userVenturesArr objectAtIndex:indexx.row]objectForKey:@"venture_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self getUserVentures];
            }else{
                [self failed:@"Oops! We are having trouble completing your request. Please try again, if problem persists contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        if(alertView.tag==1){
            [self delAdVenture];
        }else{
            [self delDualPost];
        }
    }
}

-(void)reloadCount{
    [self getThreads];
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
                NSMutableArray *threadsArr = [result objectForKey:@"data"];
                int count = 0;
                for(int i =0;i<threadsArr.count;i++){
                    if(![[app.userData objectForKey:@"user_id"] isEqualToString:[[[threadsArr objectAtIndex:i]objectForKey:@"MessageThread"]objectForKey:@"message_sender"]]){
                        if([[[[threadsArr objectAtIndex:i]objectForKey:@"MessageThread"]objectForKey:@"isunread"] isEqualToString:@"YES"]){
                            count = count+1;
                        }
                    }
                }
                if(count==0){
                    [self nounread];
                }else{
                    NSString *strr = @"";
                    if(count>9){
                        strr = @"9+";
                    }else{
                        strr = [NSString stringWithFormat:@"%d",count];
                    }
                    [self foundunread:strr];
                }
            }else{
            }
        }else{
            //Connection Error
        }
    }];
}

-(void)foundunread:(NSString *)str{
    [pMsgIndicator setHidden:NO];
    pMsgunreadCount.text = str;
}

-(void)nounread{
    [pMsgIndicator setHidden:YES];
}

-(NSString*) suffixNumber:(NSNumber*)number
{
    if (!number)
        return @"";
    
    long long num = [number longLongValue];
    
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log10l(num) / 3.f); //log10l(1000));
    
    NSArray* units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    return [NSString stringWithFormat:@"%@%.1f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}
// Collection view size
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSInteger sizeOfCell = collectionView.frame.size.width/3;
        CGSize size = CGSizeMake(sizeOfCell, sizeOfCell);
     
        return size;
  
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView==dualPostColl){
        return userDualsArr.count;
    }else{
        return userVenturesArr.count;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView==dualPostColl){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        UIImageView *uMainImg = (UIImageView *)[cell viewWithTag:100];
 //       UIImageView *uPImg = (UIImageView *)[cell viewWithTag:101];
 //       UILabel *uLinkLbl = (UILabel *)[cell viewWithTag:102];
        
        NSDictionary *dualInfo = userDualsArr[indexPath.row];

        NSURL *imageUrl = [NSURL URLWithString:dualInfo[@"dual_image"]];
        [uMainImg setImageWithURL:imageUrl];
        
     /*   NSString *linkedto = dualInfo[@"dual_linked_to"];
        if([linkedto isEqualToString:@"-1"]){
            [uPImg setHidden:YES];
            CGRect frame = uLinkLbl.frame;
            frame.origin.x = uMainImg.frame.origin.x;
            frame.size.width = uMainImg.frame.size.width;
            uLinkLbl.frame = frame;
        }else{
            NSURL *linkedUrl = [NSURL URLWithString:dualInfo[@"dual_linked_profile_pic"]];
            [uPImg setImageWithURL:linkedUrl];
            [uPImg setHidden:NO];
            
            CGRect frame = uLinkLbl.frame;
            frame.origin.x = uPImg.frame.origin.x+uPImg.frame.size.width+3;
            frame.size.width = uMainImg.frame.size.width-(uPImg.frame.origin.x+uPImg.frame.size.width+3);
            uLinkLbl.frame = frame;
        }
        
        uLinkLbl.text = dualInfo[@"dual_caption"];
        */
        return cell;
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
        UIImageView *mainImg = (UIImageView *)[cell viewWithTag:100];
 //       UILabel *ventureLbl  = (UILabel *)[cell viewWithTag:102];
        
        NSDictionary *ventureInfo = userVenturesArr[indexPath.row];
        
 //       [ventureLbl setText:ventureInfo[@"venture_title"]];
        
        NSURL *imageUrl = [NSURL URLWithString:ventureInfo[@"venture_thumb"]];
        [mainImg setImageWithURL:imageUrl];
    
        return cell;
    }
}

-(void)hidePreview:(UIGestureRecognizer *)gesture{
    [picPreviewHolder setHidden:YES];
}

-(void)showPreview:(UIGestureRecognizer *)gesture{
    [picPreviewHolder setHidden:NO];
}

- (void)fetchProfilePic {
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSURL *profileUrl = [NSURL URLWithString:app.userData[@"user_pic"]];
    UIImage *placeholder = [UIImage imageNamed:@"defpic.png"];
    [proprofilePic setImageWithURL:profileUrl placeholderImage:placeholder];
    [previewImg setImageWithURL:profileUrl placeholderImage:placeholder];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    app.selVentureDict = [userDualsArr objectAtIndex:indexPath.row];
    UIStoryboard *story = self.storyboard;
    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"DUALDETAILS"];
    [self presentViewController:view animated:YES completion:nil];
    [collectionView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(proLocationTxt.text.length==0){
        proLocationTxt.text = @"City not available";
    }
    return YES;
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(editProBtn.tag==0){
        return NO;
    }
    return YES;
}

-(void)updateFollowingLbl{
    if(followingArr.count>0){
        [followingLbl setText:[NSString stringWithFormat:@"%d Following",(int)followingArr.count]];
    }else{
        [followingLbl setText:[NSString stringWithFormat:@"0 Following"]];
    }
    if(followersArr.count>0){
        [followersLbl setText:[NSString stringWithFormat:@"%d Followers",(int)followersArr.count]];
    }else{
        [followersLbl setText:@"0 Followers"];
    }
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
                followersArr = [result objectForKey:@"followers"];
                followingArr = [result objectForKey:@"following"];
                [self updateFollowingLbl];
            }
        }else{
            
        }
    }];
}

-(void)getUserVentures{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict= [[NSMutableDictionary alloc]init];
    [dict setObject:@"getuserventure.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                userVenturesArr = [result objectForKey:@"data"];
                [self userVentureReload];
            }else{
                [self noVenturesFound];
            }
        }else{
            
        }
    }];
}

-(void)noVenturesFound{
}

-(void)reloadUDualsColl{
   // dynammical set frame size for main scroll view and for cell view
    
    proMainScroller.contentSize = CGSizeMake(proMainScroller.frame.size.width, dualPostColl.frame.origin.y+(dualPostColl.frame.size.width/3+2)*(userDualsArr.count/3+1)+30);
    // set dunamical size of dual view collection
    CGRect rect = dualPostColl.frame;
    rect.size.height = (dualPostColl.frame.size.width/3)*(userDualsArr.count/3+1);
    [dualPostColl setFrame:rect];
   
    [pNoDualsLbl setHidden:YES];
    [dualPostColl setHidden:NO];
    [dualPostColl reloadData];
}

-(void)nodualsfound{
    [pNoDualsLbl setHidden:NO];
    [dualPostColl setHidden:YES];
}

-(void)getUserDuals{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getUserDuals.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                userDualsArr = [result objectForKey:@"data"];
                [self reloadUDualsColl];
            }else{
                [self nodualsfound];
            }
        }else{
            
        }
    }];
   
}

-(void)userVentureReload{
}

-(IBAction)buttonPressed:(id)sender{
    
    if(sender==proHomeBtn){
        if([self.title isEqualToString:@"MODAL"]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
            __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            app.window.rootViewController = view;
        }
    }else if(sender==editProBtn){
        if(editProBtn.tag==0){
            editProBtn.tag=1;
            prouserNameTxt.layer.borderColor = [UIColor colorWithRed:0.29 green:0.67 blue:0.61 alpha:1.0].CGColor;
            prouserNameTxt.layer.borderWidth = 1;
            prouserNameTxt.layer.masksToBounds = YES;
            [editIcon setImage:[UIImage imageNamed:@"saveprofileicon.png"]];
            [changePicHolder setHidden:NO];
        }else{
            NSString *str = @"";
            if(prouserNameTxt.text.length==0){
                str = @"Hey! Seems like you forgot to provide us your name.";
            }
            if(str.length>0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                return;
            }
            [self.view setUserInteractionEnabled:NO];
            [editIcon setImage:[UIImage imageNamed:@"blankgcircle.png"]];
            [editIcon setUserInteractionEnabled:NO];
            
            [self updateProfile];
            [updateLoader setHidden:NO];
        }
    }else if(sender==changeProfilePicBtn){
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Gallery",@"Camera", nil];
        [action showInView:self.view];
    }else if(sender==proAddPostBtn){
//        UIStoryboard *story = self.storyboard;
//        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ADDPOST"];
//        [self presentViewController:view animated:YES completion:nil];
//        FinaliseDual
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"FinaliseDual"];
        [self presentViewController:view animated:YES completion:nil];
    }else if(sender==followersBtn){
        if(followersArr.count==0){
            return;
        }
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"FOLLOWERS"];
        view.title = @"Followers";
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.followArr = followersArr;
        app.window.rootViewController = view;
    }else if(sender==followingBtn){
        if(followingArr.count==0){
            return;
        }
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"FOLLOWERS"];
        view.title = @"Following";
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.followArr = followingArr;
        app.window.rootViewController = view;
    }else if(sender==proMsgBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"MSGTHREAD"];
        view.title = @"PROFILE";
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.window.rootViewController =  view;
    }else if(sender==settingBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"SETTINGS"];
        view.title = self.title;
        app.window.rootViewController = view;
    }else if(sender==proLiveBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"DISCOVER"];
        app.window.rootViewController = view;
    }else if(sender==notificationsBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"NOTIFICATIONS"];
        app.window.rootViewController = view;
    }else if(sender==msgBackBtn){
       
      
      [self dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void)successUpdate{
    [self.view setUserInteractionEnabled:YES];
    [editIcon setUserInteractionEnabled:YES];
    [updateLoader setHidden:YES];
    [changePicHolder setHidden:YES];
    prouserNameTxt.layer.borderColor = [UIColor clearColor].CGColor;
    prouserNameTxt.layer.borderWidth = 1;
    prouserNameTxt.layer.masksToBounds = YES;
    [editIcon setImage:[UIImage imageNamed:@"editic.png"]];
    editProBtn.tag=0;
}

- (void)updateProfile {
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *urlPic = [app.userData objectForKey:@"user_pic"];
    NSArray *bits = [urlPic componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    urlPic = [bits lastObject];
    bits = [urlPic componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    urlPic = [bits firstObject];
    NSData *data = UIImagePNGRepresentation([Utils imageWithImage:imgg scaledToSize:CGSizeMake(600, 600)]);
    NSString *base64 = [data base64EncodedStringWithOptions:0];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"updateProfile.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@&user_name=%@&location=%@&filename=%@&profile_pic=%@",[app.userData objectForKey:@"user_id"],prouserNameTxt.text,proLocationTxt.text,urlPic,base64] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                app.userData = [result objectForKey:@"data"];
                [self successUpdate];
            }else{
                [self failed:@"Oops! Something went wrong, please try again. If problem persists, kindly contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)failed:(NSString *)str{
    [self.view setUserInteractionEnabled:YES];
    [editIcon setUserInteractionEnabled:YES];
    [updateLoader setHidden:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    imageCropVC.cropMode = RSKImageCropModeCircle;
    imageCropVC.delegate = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:imageCropVC animated:NO completion:nil];
    }];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle {
    
    proprofilePic.image = croppedImage;
    imgg = proprofilePic.image;
    previewImg.image = imgg;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [picker setDelegate:self];
        //        [picker setAllowsEditing:YES];
        [self presentViewController:picker animated:YES completion:nil];
        
    }else if(buttonIndex==1){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [picker setDelegate:self];
        //        [picker setAllowsEditing:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }
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

