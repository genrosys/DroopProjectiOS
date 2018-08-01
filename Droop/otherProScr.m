//
//  otherProScr.m
//  Droop
//
//  Created by Himanshu Sharma on 17/10/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "otherProScr.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>
#import "ChatViewController.h"
#import <SVProgressHUD.h>

@interface otherProScr ()

@end

@implementation otherProScr

@synthesize otherScoller;
NSMutableDictionary *currUserDetail;
@synthesize followBtn;
@synthesize sendMessageBtn;
@synthesize opNoDualsLbl;
@synthesize oPreviewImg,oPreviewImageHolder;
@synthesize otherProImg, otherCancelBtn, otherProusername, otherProViewsLbl, otherProDualPostColl;
NSMutableArray *oUserVentureArr;
NSMutableArray *oUserDualsArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    otherScoller.contentSize = CGSizeMake(otherScoller.frame.size.width, otherProDualPostColl.frame.origin.y+otherProDualPostColl.frame.size.height+10);

    otherProImg.layer.cornerRadius = otherProImg.frame.size.height/2;
    otherProImg.layer.borderColor =
    [UIColor colorWithRed:0.53 green:0.12 blue:0.47 alpha:1.0].CGColor;
    otherProImg.layer.borderWidth = 1;
    otherProImg.layer.masksToBounds = YES;
    
    [self getOtherUserInfo];
    // [self checkFollowing];
    [self checkBlocking];
    // Do any additional setup after loading the view.
    
    CGRect oPF = oPreviewImg.frame;
    oPF.size.height = self.view.frame.size.width;
    oPF.size.width = self.view.frame.size.width;
    oPF.origin.y = (self.view.frame.size.height-self.view.frame.size.width)/2;
    oPreviewImg.frame = oPF;
    
    
    UITapGestureRecognizer *showPGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPreview:)];
    showPGesture.numberOfTapsRequired = 1;
    [otherProImg setUserInteractionEnabled:YES];
    [otherProImg addGestureRecognizer:showPGesture];
    
    UITapGestureRecognizer *hidePreviewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePreview:)];
    hidePreviewGesture.numberOfTapsRequired = 1;
    [oPreviewImageHolder addGestureRecognizer:hidePreviewGesture];
}

-(void)hidePreview:(UIGestureRecognizer *)gesture{
    [oPreviewImageHolder setHidden:YES];
}

-(void)showPreview:(UIGestureRecognizer *)gesture{
    [oPreviewImageHolder setHidden:NO];
}

-(void)getUserVentures{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict= [[NSMutableDictionary alloc]init];
    [dict setObject:@"getuserventure.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",app.proUserID] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                oUserVentureArr = [result objectForKey:@"data"];
                [self userVentureReload];
            }else{
                [self noVenturesFound];
            }
        }else{
            
        }
    }];
}

-(void)reloadUDualsColl{
    
    // dynammical set frame size for main scroll view and for cell view
    
    
    otherScoller.contentSize = CGSizeMake(otherScoller.frame.size.width, otherProDualPostColl.frame.origin.y+(otherProDualPostColl.frame.size.width/3+2)*(oUserDualsArr.count/3+1)+300);
    // set dunamical size of dual view collection
    CGRect rect = otherProDualPostColl.frame;
    rect.size.height = (otherProDualPostColl.frame.size.width/3)*(oUserDualsArr.count/3+1);
    [otherProDualPostColl setFrame:rect];
    [opNoDualsLbl setHidden:YES];
    [otherProDualPostColl setHidden:NO];
    [otherProDualPostColl reloadData];
}

- (void)getUserDuals {
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getUserDuals.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",app.proUserID] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                oUserDualsArr = [result objectForKey:@"data"];
                [self reloadUDualsColl];
            }else{
                [self nodualsFound];
            }
        }else{
            
        }
    }];
}

-(void)nodualsFound{
    [opNoDualsLbl setHidden:NO];
    [otherProDualPostColl setHidden:YES];
}

-(void)noVenturesFound{
}

-(void)userVentureReload{
}
// size of call

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sizeOfCell = collectionView.frame.size.width/3;
    CGSize size = CGSizeMake(sizeOfCell, sizeOfCell);
    return size;
   /* if(collectionView==otherProDualPostColl){
        CGSize size = CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
        return size;
    }else{
        CGSize size = CGSizeMake(collectionView.frame.size.width/3-1, collectionView.frame.size.width/3-1);
        return size;
    }*/
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)failed:(NSString *)str{
    [[[UIAlertView alloc ]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    [self buttonPressed:otherCancelBtn];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView==otherProDualPostColl){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
        UIImageView *mImgV = (UIImageView *)[cell viewWithTag:100];
        UIImageView *pImgV = (UIImageView *)[cell viewWithTag:101];
   //     UILabel *oDualCaption = (UILabel *)[cell viewWithTag:102];
        
        NSDictionary *dualInfo = oUserDualsArr[indexPath.row];
        
        NSURL *imageUrl = [NSURL URLWithString:dualInfo[@"dual_image"]];
        [mImgV setImageWithURL:imageUrl];
        
        imageUrl = [NSURL URLWithString:dualInfo[@"dual_linked_profile_pic"]];
        [pImgV setImageWithURL:imageUrl];
        
 //       oDualCaption.text = dualInfo[@"dual_caption"];
        
        return cell;
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
        UIImageView *mainImg = (UIImageView *)[cell viewWithTag:100];
        UILabel *ventureLbl  = (UILabel *)[cell viewWithTag:102];
        
        NSDictionary *ventureInfo = oUserVentureArr[indexPath.row];
        
        [ventureLbl setText:ventureInfo[@"venture_title"]];
        
        NSURL *imageUrl = [NSURL URLWithString:ventureInfo[@"venture_thumb"]];
        [mainImg setImageWithURL:imageUrl];
        
        return cell;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView==otherProDualPostColl){
        return oUserDualsArr.count;
    }else{
        return oUserVentureArr.count;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    app.selVentureDict = [oUserDualsArr objectAtIndex:indexPath.row];
    UIStoryboard *story = self.storyboard;
    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"DUALDETAILS"];
    [self presentViewController:view animated:YES completion:nil];

    [collectionView reloadData];
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

-(void)updateScreen{
    otherProusername.text = [currUserDetail objectForKey:@"user_name"];
    NSString *numberViewsStr =[currUserDetail objectForKey:@"user_views"];
    int numberViews = [numberViewsStr intValue];
    numberViews = numberViews+1;
    if(numberViews<999){
        otherProViewsLbl.text = [NSString stringWithFormat:@"%d",numberViews];
    }else{
        otherProViewsLbl.text = [NSString stringWithFormat:@"%@",[self suffixNumber:[NSNumber numberWithInt:numberViews]]];
    }
    
    NSURL *imageUrl = [NSURL URLWithString:currUserDetail[@"user_pic"]];
    [otherProImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defpic.png"]];
    [oPreviewImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defpic.png"]];
}

-(void)getOtherUserInfo{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getUserDetail.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",app.proUserID] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                currUserDetail = [result objectForKey:@"data"];
                [self updateScreen];
            }else{
                [self failed:@"Oops! Seems like the user does not exist."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

#pragma mark - Following

-(void)followUser{
    [SVProgressHUD showWithStatus:@"Following..."];
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"follow_user.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"followed_by=%@&following_id=%@&isDelete=NO", [app.userData objectForKey:@"user_id"], app.proUserID] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self followSuccess];
                [SVProgressHUD showSuccessWithStatus:@"Success!"];
            }else{
                // [self failedfollow:@"Oops! Something went wrong, please try again."];
                [SVProgressHUD showErrorWithStatus:@"Failed!"];
            }
        }else{
            // [self failedfollow:@"Oops! Seems like a connection issue, please try again."];
            [SVProgressHUD showErrorWithStatus:@"Connection Issue!"];
        }
    }];
}

- (void)checkFollowing {
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"checkfollowing.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"followed_by=%@&following_id=%@",[app.userData objectForKey:@"user_id"],app.proUserID] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self followSuccess];
            } else {
                [self unfollowSuccess];
            }
        }else{
            // [self failedfollow:@"Oops! Seems like a connection issue, please try again."];
        }
    }];
}


-(void)unfollowUser{
    [SVProgressHUD showWithStatus:@"Unfollowing..."];
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"follow_user.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"followed_by=%@&following_id=%@&isDelete=YES",[app.userData objectForKey:@"user_id"],app.proUserID] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self unfollowSuccess];
                [SVProgressHUD showSuccessWithStatus:@"Success!"];
            }else{
                [SVProgressHUD showErrorWithStatus:@"Failed!"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"Connection Issue!"];
        }
    }];
}

-(void)followSuccess{
    followBtn.tag=1;
    [followBtn setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.detailProfileView.alpha = 1.f;
        self.sendMessageBtn.alpha = 1.f;
        self.followView.alpha = 0.f;
    }];
    
    [self getUserVentures];
    [self getUserDuals];
}

-(void)unfollowSuccess{
    followBtn.tag=0;
    [followBtn setTitle:@"FOLLOW" forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.detailProfileView.alpha = 0.f;
        self.sendMessageBtn.alpha = 0.f;
        self.followView.alpha =  1.f;
    }];
}

#pragma mark - Blocking

- (void)blockUser {
    [SVProgressHUD showWithStatus:@"Blocking..."];
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"block_user.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@&block_id=%@&isDelete=NO", [app.userData objectForKey:@"user_id"], app.proUserID] forKey:@"requestBody"];
    
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self blockSuccess];
                [self unfollowUser];
            }else{
                // [self failedfollow:@"Oops! Something went wrong, please try again."];
                [SVProgressHUD showErrorWithStatus:@"Failed!"];
            }
        }else{
            // [self failedfollow:@"Oops! Seems like a connection issue, please try again."];
            [SVProgressHUD showErrorWithStatus:@"Connection Issue!"];
        }
    }];
}

- (void)checkBlocking {
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"checkblocking.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@&block_id=%@", [app.userData objectForKey:@"user_id"], app.proUserID] forKey:@"requestBody"];
    
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self blockSuccess];
            } else {
                [self unblockSuccess];
                [self checkFollowing];
            }
        }else{
            // [self failedfollow:@"Oops! Seems like a connection issue, please try again."];
        }
    }];
}


- (void)unblockUser {
    [SVProgressHUD showWithStatus:@"Unblocking..."];
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"block_user.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@&block_id=%@&isDelete=YES", [app.userData objectForKey:@"user_id"], app.proUserID] forKey:@"requestBody"];
    
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [SVProgressHUD showSuccessWithStatus:@"Success!"];
                [self unblockSuccess];
            }else{
                [SVProgressHUD showErrorWithStatus:@"Failed!"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"Connection Issue!"];
        }
    }];
}

- (void)blockSuccess {
    self.blockBtn.tag = 1;
    [self.blockBtn setTitle:@"UNBLOCK" forState:UIControlStateNormal];
    [followBtn setTitle:@"FOLLOW" forState:UIControlStateNormal];
    [followBtn setEnabled:NO];

    [UIView animateWithDuration:0.4 animations:^{
        self.detailProfileView.alpha = 0.f;
        self.sendMessageBtn.alpha = 0.f;
        self.followView.alpha = 1.f;
    }];
}

- (void)unblockSuccess {
    self.blockBtn.tag = 0;
    [self.blockBtn setTitle:@"BLOCK" forState:UIControlStateNormal];
    [followBtn setEnabled:YES];
    followBtn.tag = 0;

    [UIView animateWithDuration:0.4 animations:^{
        self.detailProfileView.alpha = 0.f;
        self.sendMessageBtn.alpha = 0.f;
        self.followView.alpha = 1.f;
    }];
}

#pragma mark - Button Handler

- (IBAction)buttonPressed:(id)sender {
    if(sender==otherCancelBtn){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(sender==followBtn){
        if(followBtn.tag==0){
            [self followUser];
            
        }else{
            [self unfollowUser];
        }
    } else if ([sender isEqual:self.blockBtn]) {
        if (self.blockBtn.tag == 0) {
            [self blockUser];
        } else {
            [self unblockUser];
        }
    }else if(sender==sendMessageBtn){
        /*UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"CHATSCR"];
        view.title = [currUserDetail objectForKey:@"user_id"];
        [self presentViewController:view animated:NO completion:nil];*/
        
        ChatViewController *chatController = [[ChatViewController alloc] initWithPerson:currUserDetail];
        [self presentViewController:chatController animated:NO completion:nil];
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

