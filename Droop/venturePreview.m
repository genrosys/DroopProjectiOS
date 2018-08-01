//
//  venturePreview.m
//  Droop
//
//  Created by Himanshu Sharma on 18/10/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "venturePreview.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>
#import "ChatViewController.h"

@interface venturePreview ()

@end

@implementation venturePreview

@synthesize cancelVenturePre,ventureShareBtn,playerHolder,venturetitleLbl;
@synthesize mPlayer;
@synthesize shareV,cancalShare,mailShareBtn,msgShareBtn,fbMsgShareBtn,followersColl;
@synthesize viewsCountLbl;
@synthesize noFollowersLbl;
@synthesize ventureChatBtn;
@synthesize shareVentureBtn;
@synthesize seekbar;
@synthesize muteic;
@synthesize muteBtn;
@synthesize reportVentureBtn;

NSMutableArray *selectedShareFollowers;
NSMutableArray *followersSArr;
int duration;

// NSMutableDictionary *followersImgs ;
NSTimer *seekbartimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    duration = 0;
    selectedShareFollowers = [[NSMutableArray alloc]init];
    // followersImgs = [[NSMutableDictionary alloc]init];
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerPlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    [venturetitleLbl setText:[app.selVentureDict objectForKey:@"venture_title"]];
    int height = [self returnSizeofLabel:venturetitleLbl.text width:venturetitleLbl.frame.size.width];
    CGRect vTF = venturetitleLbl.frame;
    vTF.origin.y = viewsCountLbl.frame.origin.y-height-3;
    vTF.size.height = height;
    venturetitleLbl.frame = vTF;
    
    // NSURL *url = [NSURL URLWithString:[app.selVentureDict objectForKey:@"venture_url"]];
    viewsCountLbl.text = [NSString stringWithFormat:@"%d Views", [[app.selVentureDict objectForKey:@"views_count"]intValue]+1];
    
    [self updateViewsCount];
    [self getFollowing];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSURL *url = [NSURL URLWithString:[app.selVentureDict objectForKey:@"venture_url"]];
    if(mPlayer){
        mPlayer = nil;
    }
    mPlayer = [[MPMoviePlayerController alloc]init];
    [mPlayer setShouldAutoplay:YES];
    [mPlayer setContentURL:url.absoluteURL];
    [mPlayer setMovieSourceType:MPMovieSourceTypeFile];
    [mPlayer setFullscreen:YES];
    [mPlayer setScalingMode:MPMovieScalingModeAspectFit];
    [mPlayer setControlStyle:MPMovieControlStyleNone];
    mPlayer.view.frame = playerHolder.bounds;
    [playerHolder addSubview:mPlayer.view];
    [mPlayer prepareToPlay];
    [mPlayer play];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *sourceMovieURL = url;
    AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    CMTime cmduration = sourceAsset.duration;
    float seconds = CMTimeGetSeconds(cmduration);
    
    // duration = roundf(seconds);
    duration = seconds;
    seekbar.maximumValue = duration;
    seekbar.minimumValue = 0;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [mPlayer stop];
    mPlayer = nil;
}

-(void)setupSeekbar{
    
    if(mPlayer.playbackState == MPMoviePlaybackStatePlaying){
        float currValue = seekbar.value;
        if(currValue<duration){
            currValue = currValue+1;
            seekbar.value = currValue;
        }else{
            [seekbartimer invalidate];
            seekbartimer = nil;
        }
    }
}

-(int)returnSizeofLabel:(NSString *)str width:(int)width{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    // CGSize expectedLabelSize = [str sizeWithFont:[UIFont fontWithName:@"Raleway-Regular" size:19] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    UIFont *labelFont = [UIFont fontWithName:@"Raleway-Regular" size:19];
    CGRect expectedLabelRect = [str boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: labelFont} context:nil];
    return expectedLabelRect.size.height;
}

- (void)MPMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    if (mPlayer.playbackState == MPMoviePlaybackStatePlaying)
    { //playing
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSURL *url = [NSURL URLWithString:[app.selVentureDict objectForKey:@"venture_url"]];
        AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        CMTime cmduration = sourceAsset.duration;
        float seconds = CMTimeGetSeconds(cmduration);
        
        duration = seconds;
        seekbar.maximumValue = duration;
        seekbar.minimumValue = 0;
        seekbartimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupSeekbar) userInfo:self repeats:YES];
    }
    if (mPlayer.playbackState == MPMoviePlaybackStateStopped)
    { //stopped
    }if (mPlayer.playbackState == MPMoviePlaybackStatePaused)
    { //paused
    }if (mPlayer.playbackState == MPMoviePlaybackStateInterrupted)
    { //interrupted
    }if (mPlayer.playbackState == MPMoviePlaybackStateSeekingForward)
    { //seeking forward
    }if (mPlayer.playbackState == MPMoviePlaybackStateSeekingBackward)
    { //seeking backward
    }
    
}

- (void)updateViewsCount {
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *params = @{@"API": @"updateVentureCount.php", @"requestBody": [NSString stringWithFormat:@"venture_id=%@&views=%d", app.selVentureDict[@"venture_id"], [app.selVentureDict[@"views_count"] intValue] + 1]};

    [app makeAPICall:params completionHandler:^(NSMutableDictionary *result, NSError *error) {
        NSLog(@"Result: %@", result);
    }];
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    return size;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return followersSArr.count;
}

-(int)ifAlreadySelected:(NSString *)uid{
    int isExist = -1;
    for(int i = 0;i<selectedShareFollowers.count;i++){
        NSString *str = [[selectedShareFollowers objectAtIndex:i] objectForKey:@"user_id"];
        if([str isEqualToString:uid]){
            isExist = i;
            break;
        }
        
    }
    return isExist;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int isExist = [self ifAlreadySelected:[[followersSArr objectAtIndex:indexPath.row]objectForKey:@"user_id"]];
    if(isExist!=-1){
        NSMutableArray *temp = [selectedShareFollowers mutableCopy];
        [temp removeObjectAtIndex:isExist];
        selectedShareFollowers = nil;
        selectedShareFollowers = temp;
        temp = nil;
    }else{
        [selectedShareFollowers addObject:[followersSArr objectAtIndex:indexPath.row]];
    }
    [followersColl reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *proSImg = (UIImageView *)[cell viewWithTag:100];
    UIImageView *sTickIcon = (UIImageView *)[cell viewWithTag:101];
    
    NSURL *imageUrl = [NSURL URLWithString:followersSArr[indexPath.row][@"user_pic"]];
    [proSImg setImageWithURL:imageUrl];
    
    int exist = [self ifAlreadySelected:followersSArr[indexPath.row][@"user_id"]];
    if(exist!=-1){
        [sTickIcon setHidden:NO];
    }else{
        [sTickIcon setHidden:YES];
    }
    return cell;
    
}
-(void)reloadCollection{
    [noFollowersLbl setHidden:YES];
    NSMutableArray *temp = followersSArr;
    followersSArr = [[NSMutableArray alloc]init];
    for(int i =0;i<temp.count;i++){
        NSString *str = [[temp objectAtIndex:i] objectForKey:@"user_id"];
        BOOL isExist = [self checkifexist:str array:followersSArr];
        if(!isExist){
            [followersSArr addObject:[temp objectAtIndex:i]];
        }
    }
    temp = nil;
    [followersColl reloadData];
    
}
-(BOOL)checkifexist:(NSString *)uid array:(NSMutableArray *)temp{
    BOOL isexist = NO;
    for(int i = 0;i<temp.count;i++){
        NSString *str = [[temp objectAtIndex:i] objectForKey:@"user_id"];
        if([str isEqualToString:uid]){
            isexist = YES;
            break;
        }
    }
    return isexist;
}

-(void)nofollowersFound{
    [noFollowersLbl setHidden:NO];
    [followersColl setHidden:YES];
}

-(void)getFollowing{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *params = @{@"API": @"getFollowers.php", @"requestBody": [NSString stringWithFormat:@"user_id=%@", app.userData[@"user_id"]]};

    [app makeAPICall:params completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if (result.count > 0) {
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"1"]){
                NSMutableArray *ddfollowersSArr = [result objectForKey:@"followers"];
                followersSArr = [[NSMutableArray alloc]init];
                for(int i =0;i<ddfollowersSArr.count;i++){
                    [followersSArr addObject:[ddfollowersSArr objectAtIndex:i]];
                }
                
                NSMutableArray *d = [result objectForKey:@"following"];
                for(int i=0;i<d.count;i++){
                    [followersSArr addObject:[d objectAtIndex:i]];
                }
                [self reloadCollection];
            }else{
                [self nofollowersFound];
            }
        }else{
            
        }
    }];
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==cancelVenturePre){
        if([self.title isEqualToString:@"MODAL"]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if([self.title isEqualToString:@"ALL"]){
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ADVALL"];
            __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            app.window.rootViewController = view;
        }else{
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
            __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            app.window.rootViewController = view;
        }
    }else if(sender==ventureShareBtn){
        [UIView transitionWithView:shareV duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = shareV.frame;
            frame.origin.y = self.view.frame.size.height-shareV.frame.size.height;
            shareV.frame = frame;
        } completion:nil];
    }else if(sender==mailShareBtn){
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc]init];
        if([MFMailComposeViewController canSendMail]){
            __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [mail setSubject:@"Check this awesome video"];
            [mail setMessageBody:[NSString stringWithFormat:@"%@ - %@ . Check it out, shared via Droop",[app.selVentureDict objectForKey:@"venture_title"],[app.selVentureDict objectForKey:@"venture_url"]] isHTML:YES];
            [mail setMailComposeDelegate:self];
            [self presentViewController:mail animated:YES completion:nil];
        }else{
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:@"Oops! Seems like you  haven't configured your email on your phone." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            
        }
    }else if(sender==msgShareBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        MFMessageComposeViewController *mail = [[MFMessageComposeViewController alloc]init];
        if([MFMessageComposeViewController canSendText]){
            [mail setBody:[NSString stringWithFormat:@"%@ - %@ . Check it out, shared via Droop",[app.selVentureDict objectForKey:@"venture_title"],[app.selVentureDict objectForKey:@"venture_url"]]];
            [mail setMessageComposeDelegate:self];
            [self presentViewController:mail animated:YES completion:nil];
        }else{
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:@"Oops! Seems like sending sms is not possible from your phone." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            
        }
    }else if(sender==cancalShare){
        [UIView transitionWithView:shareV duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = shareV.frame;
            frame.origin.y = self.view.frame.size.height;
            shareV.frame = frame;
        } completion:nil];
    }else if(sender==ventureChatBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        /*UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"CHATSCR"];
        view.title = [app.selVentureDict objectForKey:@"venture_posted_by"];
        [self presentViewController:view animated:NO completion:nil];*/
        
        ChatViewController *chatController = [[ChatViewController alloc] initWithPerson:app.selVentureDict];
        [self presentViewController:chatController animated:NO completion:nil];
    }else if(sender==shareVentureBtn){
        NSString *users = @"";
        for(int i =0;i<selectedShareFollowers.count;i++){
            if(i==0){
                users = [[selectedShareFollowers objectAtIndex:i] objectForKey:@"user_id"];
            }else{
                users = [NSString stringWithFormat:@"%@#%@",users,[[selectedShareFollowers objectAtIndex:i]objectForKey:@"user_id"]];
            }
        }
        [self shareVentureAPI:users];
        
    }else if(sender==muteBtn){
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        
        // find the volumeSlider
        UISlider *volumeViewSlider = nil;
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
                volumeViewSlider = (UISlider *)view;
                break;
            }
        }
        
        if(muteBtn.tag==0){
            muteBtn.tag=1;
            [muteic setImage:[UIImage imageNamed:@"muteonic.png"]];
            // [[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
            [volumeViewSlider setValue:0.0f animated:YES];
            [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        }else{
            muteBtn.tag=0;
            [muteic setImage:[UIImage imageNamed:@"muteic.png"]];
            // [[MPMusicPlayerController applicationMusicPlayer] setVolume:1];
            [volumeViewSlider setValue:1.0f animated:YES];
            [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }else if(sender==fbMsgShareBtn){
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [controller setInitialText:[NSString stringWithFormat:@"%@ - Shared via Droop (Download today from App Store)",[app.selVentureDict objectForKey:@"venture_title"]]];
            [controller addURL:[app.selVentureDict objectForKey:@"venture_url"]];
            [self presentViewController:controller animated:YES completion:Nil];
        }
    }else if(sender==reportVentureBtn){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you find this Ad-Venture wrong, report us and we will review your request." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Report", nil];
        [alert show];
        alert = nil;
    }
}

-(void)failed:(NSString *)str{
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(void)reportVenture{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"reportVenture.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"venture_id=%@",[app.selVentureDict objectForKey:@"venture_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self failed:@"Thank you! For helping us to keep the community clean, our team will review the report soon. Till then we removed the content from app."];
                [self reportedVentureSuccess];
            }else{
                [self failed:@"Oops! Somenthing went wrong, please try again. If problem persists, contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)reportedVentureSuccess{
    [self buttonPressed:cancelVenturePre];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self.view setUserInteractionEnabled:NO];
        [self reportVenture];
    }
}

-(void)shareVentureAPI:(NSString *)str{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *m = [NSString stringWithFormat:@"%@ shared a Ad Venture with you.",[app.userData objectForKey:@"user_name"]];
    [dict setObject:@"shareVenture.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"venture_id=%@&shared_by=%@&shared_by_name=%@&share_with=%@&message_content=%@",[app.selVentureDict objectForKey:@"venture_id"],[app.userData objectForKey:@"user_id"],[app.userData objectForKey:@"user_name"],str,m] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        NSLog(@"Result: %@", result);
    }];
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
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

