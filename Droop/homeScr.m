//
//  homeScr.m
//  Droop
//  DCPANEL @Wk12Wu?FmTR
//  Created by apple on 31/08/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "homeScr.h"
#import "AppDelegate.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <DGActivityIndicatorView.h>
#import "HomeCollectionHeaderView.h"
#import "HomeLiveCell.h"
#import "DualCollectionCell.h"
#import "UserTableViewCell.h"

#import <WowzaGoCoderSDK/WowzaGoCoderSDK.h>
#import "SettingsViewModel.h"
#import "SettingsViewController.h"
#import "MP4Writer.h"


#import "goliveScr.m"
#pragma mark VideoPlayerViewController (GoCoder SDK Sample App) -

//NSString *const SDKSampleSavedConfigKey = @"SDKSampleSavedConfigKey";
////NSString *const SDKSampleAppLicenseKey = @"GOSK-6443-0101-CD19-EB0F-E04E"; //old-no-features
//
////USE NEW KEY
//NSString *const SDKSampleAppLicenseKey = @"GOSK-6D45-010F-F010-333D-AC20"; // com.wowza.gocoder.sdk.bpsampleapp




@interface homeScr () <WZStatusCallback>

@property (strong, nonatomic) NSMutableArray *filterUserAry;
@property (strong, nonatomic) DGActivityIndicatorView *activityIndicator;
@property (nonatomic) CGFloat keyboardHeight;


#pragma mark - GoCoder SDK Components
@property (nonatomic, strong) WowzaConfig               *goCoderConfig;
//@property (nonatomic, strong) WOWZPlayer                  *player;

@end

@implementation homeScr

@synthesize homeMsgBtn, homeAddPostBtn, homeProfileBtn;
@synthesize goLiveBtn;
@synthesize homeDiscoverBtn;
@synthesize msgIndicator;
@synthesize notificationIndicator;

NSMutableArray *liveFeeds;
NSMutableArray *dualsArr;
CGRect frameInitial;





- (void)viewDidLoad {
    [super viewDidLoad];
    
    msgIndicator.layer.cornerRadius = msgIndicator.frame.size.height/2;
    msgIndicator.layer.masksToBounds = YES;
    [msgIndicator setHidden:YES];
    
    liveFeeds = [[NSMutableArray alloc]init];
    
    notificationIndicator.layer.cornerRadius = notificationIndicator.frame.size.height/2;
    notificationIndicator.layer.masksToBounds = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recheckCount) name:@"REFRESHCOUNTHOME" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recheckNotification) name:@"HOMENOTIFYCOUNT" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UIColor *droopColor = [UIColor colorWithRed:33/255.f green:182/255.f blue:168/255.f alpha:1.f];
    self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallPulse tintColor:droopColor size:40.0f];
    [self.searchTable addSubview:self.activityIndicator];
}



- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSLog(@"Keyboard Height = %f", self.keyboardHeight);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getLiveFeeds];
    [self getDuals];
    
    [self getThreads];

    [self getNotificationsCount];
}

- (void)recheckNotification {
    [self getNotificationsCount];
}

- (void)recheckCount {
    [self getThreads];
}

-(void)nonotifications{
    [notificationIndicator setHidden:YES];
}

-(void)notificationfound{
    [notificationIndicator setHidden:NO];
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

- (void)getDuals {
    
//    dualsArr = nil;
//    [self.homeCollectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];

    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getDuals.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];
    
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                dualsArr = [result objectForKey:@"data"];
                [self.homeCollectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
            } else {
            }
        } else {
        }
    }];
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
                for (int i =0; i<threadsArr.count; i++) {
                    if (! [app.userData[@"user_id"] isEqualToString:threadsArr[i][@"MessageThread"][@"message_sender"]]) {
                        if ([threadsArr[i][@"MessageThread"][@"isunread"] isEqualToString:@"YES"]) {
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
    [msgIndicator setHidden:NO];
}

-(void)nounread{
    [msgIndicator setHidden:YES];
}

-(void)getLiveFeeds{
//    liveFeeds = nil;
//    [self.homeCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];

    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getLiveFeed.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                liveFeeds = [result objectForKey:@"data"];
                [self.homeCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            } else {
            }
        } else {
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)failed:(NSString *)str{
    UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {
        return MAX(dualsArr.count, 1);
    } else {
        return 1;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HomeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HomeHeader" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLbl.text = @"Host Live";
            headerView.secondTitleLbl.text = @"Experience";
        } else {
            headerView.titleLbl.text = nil;
            
            
            NSString *text1 = @"Dual ";
            NSString *text2 = @"Post";
            UIFont *text1Font = [UIFont fontWithName:@"Raleway-ExtraBold" size:37];
            NSMutableAttributedString *attributedString1 =
            [[NSMutableAttributedString alloc] initWithString:text1 attributes:@{ NSFontAttributeName : text1Font }];
            NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setAlignment:NSTextAlignmentLeft];
            
            UIFont *text2Font = [UIFont fontWithName:@"Raleway-ExtraBold" size:37];
            NSMutableAttributedString *attributedString2 =
            [[NSMutableAttributedString alloc] initWithString:text2 attributes:@{NSFontAttributeName : text2Font, NSForegroundColorAttributeName : [UIColor colorWithRed:0.52 green:0.12 blue:0.47 alpha:1] }];
            NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle2 setAlignment:NSTextAlignmentLeft];
            [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [attributedString2 length])];
            [attributedString1 appendAttributedString:attributedString2];
            
            headerView.titleLbl.attributedText = attributedString1;
            headerView.secondTitleLbl.text = @"";
            
            
            
        }
        headerView.seeAllBtn.hidden = (indexPath.section == 1);
        headerView.seeAllBtn.tag = 100 + indexPath.section;
        
        return headerView;
    }
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([liveFeeds count] > 0) {
            HomeLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeLiveCell" forIndexPath:indexPath];
            cell.liveAry = liveFeeds;
            return cell;
        } else {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoLiveCell" forIndexPath:indexPath];
            
            
            
            [WowzaGoCoder setLogLevel:WowzaGoCoderLogLevelDefault];
            
            // Load or initialization the streaming configuration settings
            NSData *savedConfig = [[NSUserDefaults standardUserDefaults] objectForKey:SDKSampleSavedConfigKey];
            if (savedConfig) {
                self.goCoderConfig = [NSKeyedUnarchiver unarchiveObjectWithData:savedConfig];
            }
            else {
                self.goCoderConfig = [WowzaConfig new];
            }
            
            //default to these on... you can change.
            self.goCoderConfig.audioEnabled = YES;
            self.goCoderConfig.videoEnabled = YES;
            
            //dont let the app sleep from idle timer while watching clips.
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            
            NSLog (@"WowzaGoCoderSDK version =\n major:%lu\n minor:%lu\n revision:%lu\n build:%lu\n short string: %@\n verbose string: %@",
                   (unsigned long)[WZVersionInfo majorVersion],
                   (unsigned long)[WZVersionInfo minorVersion],
                   (unsigned long)[WZVersionInfo revision],
                   (unsigned long)[WZVersionInfo buildNumber],
                   [WZVersionInfo string],
                   [WZVersionInfo verboseString]);
            
            NSLog (@"%@", [WZPlatformInfo string]);
            
      //       Register the GoCoder SDK license key
            NSError *goCoderLicensingError = [WowzaGoCoder registerLicenseKey:SDKSampleAppLicenseKey];
            if (goCoderLicensingError != nil) {
               //  Handle license key registration failure
              //  [VideoPlayerViewController showAlertWithTitle:@"GoCoder SDK Licensing Error" error:goCoderLicensingError presenter:self];
            }
            else {
//                self.player = [WOWZPlayer new];
//
//                self.volumeSlider.value = self.player.volume;
//                // Set default preroll buffer duration
//                self.player.prerollDuration = [[NSUserDefaults standardUserDefaults] floatForKey:PlaybackPrerollKey];

                // Optionally set up data sink to handle in stream events
           //     [self.player registerDataSink:self eventName:@"onTextData"];
            }
            
            
            return cell;
        }
    } else {
        if ([dualsArr count] > 0) {
            DualCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DualCell" forIndexPath:indexPath];
            [cell configWithDual:dualsArr[indexPath.row]];
            cell.profileBtn.tag = 100 + indexPath.row;
            cell.linkedProfileBtn.tag = 100 + indexPath.row;
            return cell;
        } else {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoDualCell" forIndexPath:indexPath];
            return cell;
        }
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.selVentureDict = dualsArr[indexPath.row];
        UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"DUALDETAILS"];
        if (![notificationIndicator isHidden]) {
            view.title = @"YES";
        } else {
            view.title = @"NO";
        }
        [self presentViewController:view animated:YES completion:nil];
    }
    // [collectionView reloadData];
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(collectionView.frame.size.width, 187);
    } else {
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.width + 145);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return CGSizeMake(collectionView.bounds.size.width,104);
    } else {
        return CGSizeMake(collectionView.bounds.size.width,54);
    }

}

#pragma mark - IBAction Handler

- (IBAction)onSeeAll:(UIButton *)sender {
    if (sender.tag == 100) {
        UIViewController *allLiveCtlr = [self.storyboard instantiateViewControllerWithIdentifier:@"LIVEALL"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.window.rootViewController = allLiveCtlr;
    } else if (sender.tag == 101) {
        UIViewController *allVentureCtlr = [self.storyboard instantiateViewControllerWithIdentifier:@"ADVALL"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.window.rootViewController = allVentureCtlr;
    }
}

- (IBAction)onLiveProfile:(UIButton *)sender {
    NSDictionary *liveInfo = liveFeeds[sender.tag - 100];
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([app.userData[@"user_id"] isEqualToString:liveInfo[@"user_id"]]) {
        [self buttonPressed:homeProfileBtn];
    } else {
        UIViewController *profileCtlr = [self.storyboard instantiateViewControllerWithIdentifier:@"OTHERUSER"];
        profileCtlr.title = @"OTHER";
        app.proUserID = liveInfo[@"user_id"];
        [self presentViewController:profileCtlr animated:YES completion:nil];
    }
}

- (IBAction)onVentureProfile:(UIButton *)sender {
}

- (IBAction)onDualProfile:(UIButton *)sender {
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *dualInfo = dualsArr[sender.tag - 100];
    
    if ([app.userData[@"user_id"] isEqualToString:dualInfo[@"dual_posted_by"]]) {
        [self buttonPressed:homeProfileBtn];
    } else {
        UIViewController *profileCtlr = [self.storyboard instantiateViewControllerWithIdentifier:@"OTHERUSER"];
        profileCtlr.title = @"OTHER";
        app.proUserID = dualInfo[@"dual_posted_by"];
        [self presentViewController:profileCtlr animated:YES completion:nil];
    }
}

- (IBAction)onDualLinkedProfile:(UIButton *)sender {
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *dualInfo = dualsArr[sender.tag - 100];
    
    if ([app.userData[@"user_id"] isEqualToString:dualInfo[@"dual_linked_to"]]) {
        [self buttonPressed:homeProfileBtn];
    } else {
        UIViewController *profileCtlr = [self.storyboard instantiateViewControllerWithIdentifier:@"OTHERUSER"];
        profileCtlr.title = @"OTHER";
        app.proUserID = dualInfo[@"dual_linked_to"];
        [self presentViewController:profileCtlr animated:YES completion:nil];
    }
}

- (IBAction)buttonPressed:(id)sender {
    
    if (sender==homeProfileBtn) {
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"PROFILE"];
        // __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if(![notificationIndicator isHidden]){
            view.title = @"YES";
        }else{
            view.title = @"NO";
        }
        [self presentViewController:view animated:NO completion:nil];
    }else if(sender==homeAddPostBtn){

//        UIStoryboard *story = self.storyboard;
//        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ADDPOST"];
//        [self presentViewController:view animated:YES completion:nil];
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"FinaliseDual"];
        [self presentViewController:view animated:YES completion:nil];

    }else if(sender==homeMsgBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"MSGTHREAD"];
        view.title = @"HOME";
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.window.rootViewController =  view;
    }else if(sender==goLiveBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ADDPOSTSETUP"];
        [self presentViewController:view animated:YES completion:nil];
        
    }else if(sender==homeDiscoverBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"DISCOVER"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.window.rootViewController =  view;
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filterUserAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    
    NSDictionary *userInfo = self.filterUserAry[indexPath.row];
    [cell configCell:userInfo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OTHERUSER"];
    view.title = @"OTHER";
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.proUserID = self.filterUserAry[indexPath.row][@"user_id"];
    
    [self searchBarCancelButtonClicked:self.userSearchBar];
    
    [self presentViewController:view animated:YES completion:^{
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [UIView animateWithDuration:0.35 animations:^{
        self.searchTable.alpha = 1.f;
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.searchTable.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.filterUserAry = nil;
        [self.searchTable reloadData];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.filterUserAry = nil;
    
    if ([searchText length] == 0) {
        [self.searchTable reloadData];
        return;
    }
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *params = @{@"API": @"searchUser.php", @"requestBody": [NSString stringWithFormat:@"search_txt=%@&user_id=%@", searchText, [app.userData objectForKey:@"user_id"]]};
    
    self.activityIndicator.frame = CGRectMake((self.searchTable.frame.size.width - 50.f) / 2.f, (self.searchTable.frame.size.height - self.headerView.frame.size.height - self.keyboardHeight - 50.f) / 2.f, 50.0f, 50.0f);
    [self.activityIndicator startAnimating];
    
    [app makeAPICall:params completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if (result.count > 0) {
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                self.filterUserAry = [result objectForKey:@"data"];
            }else{
                
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
        [self.activityIndicator stopAnimating];
        [self.searchTable reloadData];
    }];
}



#pragma mark - WOWZStatusCallback Protocol Instance Methods

- (void) onWZStatus:(WZStatus *) goCoderStatus {
    // A successful status transition has been reported by the GoCoder SDK
    
    switch (goCoderStatus.state) {
            
        case WZStateIdle:
            
//            self.settingsButton.hidden = NO;
//            self.closeButton.hidden = NO;
//            self.playbackButton.enabled = YES;
//            [self.playbackButton setImage:[UIImage imageNamed:(@"playback_button")] forState:UIControlStateNormal];
        {
            [UIView animateWithDuration:0.25 animations:^{
               // self.infoLabel.alpha = 0;
            }];
        }
            break;
            
        case WZStateStarting:
            // A streaming playback session is starting up
//            self.closeButton.hidden = YES;
//            self.settingsButton.hidden = YES;
//            self.playbackButton.enabled = NO;
//            self.infoLabel.text = @"Starting...";
//            self.infoLabel.alpha = 1;
//            self.player.playerView = self.previewView;
            
            break;
            
        case WZStateRunning:
//            [self.playbackButton setImage:[UIImage imageNamed:(@"stop_playback_button")] forState:UIControlStateNormal];
//            self.playbackButton.enabled = YES;
//            self.infoLabel.text = @"Playing";
        {
            [UIView animateWithDuration:0.25 animations:^{
             //   self.infoLabel.alpha = 0;
            }];
        }
            break;
            
        case WZStateStopping:
//            self.playbackButton.enabled = NO;
//            self.infoLabel.alpha = 1;
//            self.infoLabel.text = @"Stopping";
            break;
            
        case WZStateBuffering:
           // self.infoLabel.text = @"Buffering...";
            break;
            
        default:
            break;
    }
}

- (void) onWZEvent:(WZStatus *) goCoderStatus {
    // nothing to do
}

- (void) onWZError:(WZStatus *) goCoderStatus {
    // If an error is reported by the GoCoder SDK, display an alert dialog containing the error details
    //[WOWZPlayerViewController showAlertWithTitle:@"Playback Error" status:goCoderStatus presenter:self];
}


#pragma mark - WOWZDataSink

- (void) onData:(WZDataEvent *)dataEvent {
    NSLog(@"Got data - %@", dataEvent.description);
}

#pragma mark -

+ (void) showAlertWithTitle:(NSString *)title status:(WZStatus *)status presenter:(UIViewController *)presenter {
    
   // [SettingsViewController presentAlert:title message:status.description presenter:presenter];
}

+ (void) showAlertWithTitle:(NSString *)title error:(NSError *)error presenter:(UIViewController *)presenter {
    
  //  [SettingsViewController presentAlert:title message:error.localizedDescription presenter:presenter];
}


@end
