//
//  followersScr.m
//  Droop
//
//  Created by Himanshu Sharma on 23/10/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "followersScr.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>

@interface followersScr ()

@end

@implementation followersScr

@synthesize followersTbl,followersBackBtn;
@synthesize headerLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerLbl.text = self.title;
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    __unsafe_unretained AppDelegate *app  = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return app.followArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UIImageView *proUPic = (UIImageView *)[cell viewWithTag:100];
    UILabel *proUName = (UILabel *)[cell viewWithTag:101];
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *followerInfo = app.followArr[indexPath.row];
    
    [proUPic setImageWithURL:[NSURL URLWithString:followerInfo[@"user_pic"]]];
    proUName.text = followerInfo[@"user_name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIStoryboard *story = self.storyboard;
    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"OTHERUSER"];
    view.title = @"OTHER";
    app.proUserID = [[app.followArr objectAtIndex:indexPath.row] objectForKey:@"user_id"];
    [self presentViewController:view animated:YES completion:nil];
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==followersBackBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"PROFILE"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      //  app.window.rootViewController = view;
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
