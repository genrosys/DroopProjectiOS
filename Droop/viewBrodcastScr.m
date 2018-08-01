//
//  viewBrodcastScr.m
//  Droop
//
//  Created by apple on 28/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "viewBrodcastScr.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>

@interface viewBrodcastScr ()

@end

@implementation viewBrodcastScr

@synthesize cancelViewBroadcast,commentViewBtn,titlelive,costlive;
@synthesize playerHolderr;
@synthesize mp;
@synthesize userPPic,userDHolder;
@synthesize commTbl;
@synthesize sCommIc,sCommTxt,sCommHolder,sCommSendBtn,sCommIndicator,rBack;
@synthesize scrollerVB;
@synthesize hideKeyboard;
@synthesize reportLiveBtn;
NSMutableArray *commArr;
NSTimer *sCommTimer;
BOOL isfirst;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isfirst = NO;
    commArr = [[NSMutableArray alloc]init];
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    titlelive.text = [app.selStreamDict objectForKey:@"live_title"];
    costlive.text = [NSString stringWithFormat:@"$%@", [app.selStreamDict objectForKey:@"live_cost"]];
    
    rBack.layer.cornerRadius = rBack.frame.size.height/2;
    rBack.layer.borderColor = [UIColor lightGrayColor].CGColor;
    rBack.layer.borderWidth = 1;
    rBack.layer.masksToBounds = YES;
    
    CGRect phF = playerHolderr.frame;
    phF.size.width = self.view.frame.size.width;
    phF.size.height = self.view.frame.size.width;
    playerHolderr.frame = phF;
    
    CGRect udF = userDHolder.frame;
    udF.origin.y = playerHolderr.frame.origin.y+playerHolderr.frame.size.height;
    userDHolder.frame = udF;
    
    CGRect ctF = commTbl.frame;
    ctF.origin.y = userDHolder.frame.origin.y+userDHolder.frame.size.height;
    ctF.size.height = self.view.frame.size.height-(userDHolder.frame.origin.y+userDHolder.frame.size.height)-40;
    commTbl.frame = ctF;
    
    scrollerVB.contentSize = CGSizeMake(scrollerVB.frame.size.width, commTbl.frame.origin.y+commTbl.frame.size.height+40);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rtmp.streamaxia.com:1935/streamaxia/%@/playlist.m3u8",[app.selStreamDict objectForKey:@"live_streamname"]]];
    mp = [[MPMoviePlayerController alloc]init];
    [mp setShouldAutoplay:YES];
    [mp setControlStyle:MPMovieControlStyleNone];
    [mp setContentURL:url];
    [mp setMovieSourceType:MPMovieSourceTypeFile];
    
    [mp setScalingMode:MPMovieScalingModeAspectFill];
    mp.view.frame = playerHolderr.bounds;
    [playerHolderr addSubview:mp.view];
    [mp prepareToPlay];
    [mp play];
    
    UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(terminateKeyboard:)];
    swiper.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swiper];
    
    [self fetchcommentsAPI];
    [self fetchPicture];
    [self addViewer];
}

- (void)addViewer {
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"addviewer.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"live_id=%@", [app.selStreamDict objectForKey:@"live_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        NSLog(@"Result: %@", result);
    }];
}

- (void)fetchPicture {
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSURL *imageUrl = [NSURL URLWithString:app.selStreamDict[@"user_pic"]];
    [userPPic setImageWithURL:imageUrl];
    
    userPPic.layer.cornerRadius = userPPic.frame.size.height/2;
    userPPic.layer.borderColor = [UIColor colorWithRed:0.29 green:0.67 blue:0.61 alpha:1.0].CGColor;
    userPPic.layer.borderWidth = 1;
    userPPic.layer.masksToBounds = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int height = [self returnSizeofCellLabel:[[commArr objectAtIndex:indexPath.row]objectForKey:@"comment_txt"] width:self.view.frame.size.width-73];
    if(height<30){
        height = 30;
        return 72;
    }else{
        return 31+height+11;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UIImageView *imgPic = (UIImageView *)[cell viewWithTag:100];
    UILabel *uName = (UILabel *)[cell viewWithTag:101];
    UILabel *comment  = (UILabel *)[cell viewWithTag:102];
    
    NSDictionary *commentInfo = commArr[indexPath.row];
    
    NSURL *imageUrl = [NSURL URLWithString:commentInfo[@"user_pic"]];
    [imgPic setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defpic.png"]];
    
    int height = [self returnSizeofCellLabel:commentInfo[@"comment_txt"] width:self.view.frame.size.width-73];
    if(height<30){
        height = 30;
    }
    
    CGRect commFrame = comment.frame;
    commFrame.size.height = height;
    comment.frame = commFrame;
    
    imgPic.layer.cornerRadius = imgPic.frame.size.height/2;
    imgPic.layer.masksToBounds = YES;
    [uName setText:commentInfo[@"user_name"]];
    [comment setText:commentInfo[@"comment_txt"]];
    
    return cell;
}

- (void)postCommentAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"post_comment.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"broadcast_id=%@&comment_by=%@&comment_txt=%@",[app.selStreamDict objectForKey:@"live_id"],[app.userData objectForKey:@"user_id"],sCommTxt.text] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self resetTxtView];
                [self fetchcommentsAPI];
            }else{
                [self failed:@"Oops! Something went wrong, please send your comment again."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please send your comment again."];
        }
    }];
}

-(void)setupTimer{
    [sCommTimer invalidate];
    sCommTimer = nil;
    sCommTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refetchComment) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [sCommTimer invalidate];
    sCommTimer = nil;
}

-(void)resetTxtView{
    int height = 30;
    sCommTxt.text = @"Write Comment Here ...";
    sCommTxt.textColor = [UIColor darkGrayColor];
    CGRect frame = sCommHolder.frame;
    frame.size.height = height+17;
    frame.origin.y = self.view.frame.size.height-216-frame.size.height;
    sCommHolder.frame = frame;
    
    CGRect rFrame = rBack.frame;
    rFrame.size.height = height+7;
    
    rBack.frame = rFrame;
    
    CGRect tFrame = sCommTxt.frame;
    tFrame.size.height = height;
    sCommTxt.frame = tFrame;
}

-(void)failed:(NSString *)str{
    [sCommIc setHidden:NO];
    [sCommIndicator setHidden:YES];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
    
}

-(void)refetchComment{
    [self fetchcommentsAPI];
}

-(void)terminateKeyboard:(UIGestureRecognizer *)gesture{
    [sCommTxt resignFirstResponder];
    CGRect f = scrollerVB.frame;
    f.size.height = self.view.frame.size.height;
    scrollerVB.frame = f;
    
    if(sCommTxt.text.length==0){
        sCommTxt.text = @"Write Comment Here ...";
        sCommTxt.textColor = [UIColor darkGrayColor];
    }
    [UIView transitionWithView:sCommHolder duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = sCommHolder.frame;
        frame.origin.y = self.view.frame.size.height-sCommHolder.frame.size.height;
        sCommHolder.frame = frame;
    } completion:nil];
    [hideKeyboard setHidden:YES];
}

-(int)returnSizeofLabel:(NSString *)str width:(int)width{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    // CGSize expectedLabelSize = [str sizeWithFont:[UIFont fontWithName:@"Raleway-Regular" size:19] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    UIFont *labelFont = [UIFont fontWithName:@"Raleway-Regular" size:19];
    CGRect expectedLabelRect = [str boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: labelFont} context:nil];
    return expectedLabelRect.size.height;
}

-(int)returnSizeofCellLabel:(NSString *)str width:(int)width{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    // CGSize expectedLabelSize = [str sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
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
        int height = [self returnSizeofLabel:completeMsg width:sCommTxt.frame.size.width];
        if(height>100){
            height = 100;
        }else if(height<30){
            height = 30;
        }
        
        CGRect frame = sCommHolder.frame;
        frame.size.height = height+17;
        frame.origin.y = self.view.frame.size.height-216-frame.size.height;
        sCommHolder.frame = frame;
        
        CGRect rFrame = rBack.frame;
        rFrame.size.height = height+7;
        
        rBack.frame = rFrame;
        
        
        CGRect tFrame = sCommTxt.frame;
        tFrame.size.height = height;
        sCommTxt.frame = tFrame;
    }else{
        int height = 30;
        
        CGRect frame = sCommHolder.frame;
        frame.size.height = height+17;
        frame.origin.y = self.view.frame.size.height-216-frame.size.height;
        sCommHolder.frame = frame;
        
        CGRect rFrame = rBack.frame;
        rFrame.size.height = height+7;
        
        rBack.frame = rFrame;
        
        CGRect tFrame = sCommTxt.frame;
        tFrame.size.height = height;
        sCommTxt.frame = tFrame;
    }
    return YES;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [hideKeyboard setHidden:NO];
    if([textView.text isEqualToString:@"Write Comment Here ..."]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    CGRect f = scrollerVB.frame;
    f.size.height = self.view.frame.size.height-216;
    scrollerVB.frame = f;
    
    [UIView transitionWithView:sCommHolder duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = sCommHolder.frame;
        frame.origin.y = self.view.frame.size.height-216-sCommHolder.frame.size.height;
        sCommHolder.frame = frame;
    } completion:nil];
    return YES;
}

-(void)fetchcommentsAPI{
    [self setupTimer];

    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:@"get_comments.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"b_id=%@",[app.selStreamDict objectForKey:@"live_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                commArr = [result objectForKey:@"data"];
                [self reloadTable];
            }else if([status isEqualToString:@"2"]){
                [self broadcastStopped];
            }else{
                
            }
        }else{
            
        }
    }];
}

-(void)broadcastStopped{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Broadcast is stopped by broadcaster." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
    [self buttonPressed:cancelViewBroadcast];
}

-(void)reloadTable{
    [self.view setUserInteractionEnabled:YES];
    if([sCommIc isHidden]){
        [sCommIc setHidden:NO];
        [sCommIndicator setHidden:YES];
        sCommTxt.text = @"";
        [self buttonPressed:hideKeyboard];
    }
    [commTbl reloadData];
    
    //    [commentTbl setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==cancelViewBroadcast){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app removeViewer:[app.selStreamDict objectForKey:@"live_id"]];
        if(mp){
            [mp stop];
            mp = nil;
        }
        if([self.title isEqualToString:@"DISCOVER"]){
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"DISCOVER"];
            app.window.rootViewController = view;
        }else{
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
            app.window.rootViewController = view;
        }
    }else if(sender==sCommSendBtn){
        if([sCommTxt.text isEqualToString:@"Write Comment Here ..."] || sCommTxt.text.length==0){
            return;
        }
        [self.view setUserInteractionEnabled:NO];
        [sCommIc setHidden:YES];
        [sCommIndicator setHidden:NO];
        [self postCommentAPI];
    }else if(sender==hideKeyboard){
        [sCommTxt resignFirstResponder];
        CGRect f = scrollerVB.frame;
        f.size.height = self.view.frame.size.height;
        scrollerVB.frame = f;
        
        if(sCommTxt.text.length==0){
            sCommTxt.text = @"Write Comment Here ...";
            sCommTxt.textColor = [UIColor darkGrayColor];
        }
        [UIView transitionWithView:sCommHolder duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = sCommHolder.frame;
            frame.origin.y = self.view.frame.size.height-sCommHolder.frame.size.height;
            sCommHolder.frame = frame;
        } completion:nil];
        [hideKeyboard setHidden:YES];
    }else if(sender==reportLiveBtn){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you find this Live Stream wrong, report us and we will review your request." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Report", nil];
        [alert show];
        alert = nil;
    }
}

-(void)reportLive{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"reportLive.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"live_id=%@",[app.selStreamDict objectForKey:@"live_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self failed:@"Thank you! For helping us to keep the community clean, our team will review the report soon. Till then we removed the content from app."];
                [self reportedLiveSuccess];
            }else{
                [self failed:@"Oops! Something went wrong, please try again. If problem persists, contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)reportedLiveSuccess{
    [self buttonPressed:cancelViewBroadcast];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self reportLive];
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

