//
//  liveHostAllScr.m
//  Droop
//
//  Created by Himanshu Sharma on 25/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "liveHostAllScr.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>

@interface liveHostAllScr ()

@end

@implementation liveHostAllScr

@synthesize livehostAllBack,livehostallcoll,livehostAllPost,livehostSearchTxt;
@synthesize livehostAllHeadV;
NSMutableArray *liveHostArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    livehostAllHeadV.layer.cornerRadius = livehostAllHeadV.frame.size.height/2;
    livehostAllHeadV.layer.masksToBounds = YES;
    
    [self getLiveFeeds];
    // Do any additional setup after loading the view.
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
                liveHostArr = [result objectForKey:@"data"];
                [self reloadLiveCollections];
            }else{
                [self noliveFeedFound];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = CGSizeMake(((collectionView.frame.size.width-2)/2), ((collectionView.frame.size.width-2)/2)+60);
    return size;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *mainImg = (UIImageView *)[cell viewWithTag:100];
    UIImageView *userP = (UIImageView *)[cell viewWithTag:102];
    UILabel *userN = (UILabel *)[cell viewWithTag:990];
    UILabel *costing = (UILabel *)[cell viewWithTag:568];
    UILabel *rateLbl = (UILabel *)[cell viewWithTag:103];
    
    NSDictionary *liveInfo = liveHostArr[indexPath.row];
    
    costing.text = [NSString stringWithFormat:@"$%@", liveInfo[@"live_cost"]];
    rateLbl.text = [liveInfo[@"live_title"] uppercaseString];
    userN.text = liveInfo[@"user_name"];
    
    [userP setImageWithURL:[NSURL URLWithString:liveInfo[@"user_pic"]]];
    [mainImg setImageWithURL:[NSURL URLWithString:liveInfo[@"live_thumb"]]];
    
    userP.layer.cornerRadius = userP.frame.size.height/2;
    userP.layer.borderColor = [UIColor whiteColor].CGColor;
    userP.layer.borderWidth = 2;
    userP.layer.masksToBounds = YES;
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return liveHostArr.count;
}

-(void)noliveFeedFound{
//    [hnoLiveFeedLbl setHidden:NO];
    [livehostallcoll setHidden:YES];
}

-(void)failed:(NSString *)str{
    UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}
-(void)reloadLiveCollections{
//    [hnoLiveFeedLbl setHidden:YES];
    [livehostallcoll setHidden:NO];
    [livehostallcoll reloadData];
    
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==livehostAllBack){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.window.rootViewController = view;
    }else if(sender==livehostAllPost){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ADDPOSTSETUP"];
        [self presentViewController:view animated:YES completion:nil];
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
