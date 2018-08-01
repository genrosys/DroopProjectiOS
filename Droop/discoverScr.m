//
//  discoverScr.m
//  Droop
//
//  Created by Himanshu Sharma on 20/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "discoverScr.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>

@interface discoverScr ()

@end

@implementation discoverScr

@synthesize discoverColl,discoverMsgBtn,discoverProBtn,discoverHomeBtn,discoverGoLiveBtn,discoverAddPostBtn;
@synthesize dMsgCountLbl,dMsgIndicator;
@synthesize dNoFeedFound;
@synthesize discoverHostV;
@synthesize discoverNotificationIndicator;
NSMutableArray *dLiveFeedArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    discoverHostV.layer.cornerRadius = discoverHostV.frame.size.height/2;
//    discoverHostV.layer.masksToBounds = YES;
    
    dMsgIndicator.layer.cornerRadius = dMsgIndicator.frame.size.height/2;
    dMsgIndicator.layer.masksToBounds = YES;
    
    [self getLiveFeeds];
    [self getThreads];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCount) name:@"DISCOVERCOUNTRELOAD" object:nil];
    [self getNotificationsCount];
    
    discoverNotificationIndicator.layer.cornerRadius = discoverNotificationIndicator.frame.size.height/2;
    discoverNotificationIndicator.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refetchNotification) name:@"DISCOVERNOTIFYCOUNT" object:nil];
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
    [discoverNotificationIndicator setHidden:NO];
}

-(void)nonotifications{
    [discoverNotificationIndicator setHidden:YES];
}

-(void)reloadCount{
    [self getThreads];
}

-(void)reloadLiveCollections{
    [dNoFeedFound setHidden:YES];
    [discoverColl reloadData];
}

-(void)noliveFeedFound{
    [dNoFeedFound setHidden:NO];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.selStreamDict = [dLiveFeedArr objectAtIndex:indexPath.row];
    UIStoryboard *story = self.storyboard;
    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"VIEWBROADCAST"];
    view.title = @"DISCOVER";
    app.window.rootViewController = view;
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
    [dMsgIndicator setHidden:NO];
    dMsgCountLbl.text = str;
}

-(void)nounread{
    [dMsgIndicator setHidden:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.text.length>0){
        dLiveFeedArr = [[NSMutableArray alloc]init];
        [discoverColl reloadData];
        [self callSearchLiveAPI];
    }else{
        dLiveFeedArr = [[NSMutableArray alloc]init];
        [discoverColl reloadData];
        
        [self getLiveFeeds];
    }
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
// Dynamical size of cell view. half of width screen
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = CGSizeMake((collectionView.frame.size.width/3)-5, ((collectionView.frame.size.width)/3-5)+35);
    return size;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *mainImg = (UIImageView *)[cell viewWithTag:100];
    UIImageView *userP = (UIImageView *)[cell viewWithTag:102];

    NSDictionary *liveInfo = dLiveFeedArr[indexPath.row];
    
    NSURL *imageUrl = [NSURL URLWithString:liveInfo[@"live_thumb"]];
    [mainImg setImageWithURL:imageUrl];
    
    imageUrl = [NSURL URLWithString:liveInfo[@"user_pic"]]; // second user pic
    [userP setImageWithURL:imageUrl];
    
   
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dLiveFeedArr.count;
}

-(void)failed:(NSString *)str{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(void)callSearchLiveAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"searchLive.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"search_txt=%@",disSearchTxt.text] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                dLiveFeedArr = [result objectForKey:@"data"];
                [self reloadLiveCollections];
            }else{
                [self noliveFeedFound];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}


-(void)getLiveFeeds{
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getLiveFeed.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                dLiveFeedArr = [result objectForKey:@"data"];
                [self reloadLiveCollections];
            }else{
                [self noliveFeedFound];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==discoverGoLiveBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ADDPOSTSETUP"];
        [self presentViewController:view animated:YES completion:nil];
    }else if(sender==discoverHomeBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.window.rootViewController = view;
    }else if(sender==discoverAddPostBtn){
//        UIStoryboard *story = self.storyboard;
//        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ADDPOST"];
//        [self presentViewController:view animated:YES completion:nil];
        
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"FinaliseDual"];
        [self presentViewController:view animated:YES completion:nil];
    }else if(sender==discoverMsgBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"MSGTHREAD"];
        view.title = @"DISCOVER";
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.window.rootViewController =  view;
    }else if(sender==discoverProBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"PROFILE"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if(![discoverNotificationIndicator isHidden]){
            view.title = @"YES";
        }else{
            view.title = @"NO";
        }
      //  app.window.rootViewController =  view;
        [self presentViewController:view animated:NO completion:nil];
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

