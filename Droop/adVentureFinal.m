//
//  adVentureFinal.m
//  Droop
//
//  Created by apple on 15/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "adVentureFinal.h"
#import "AppDelegate.h"
#import "Utils.h"
#import <MediaPlayer/MediaPlayer.h>

@interface adVentureFinal ()

@end

@implementation adVentureFinal

@synthesize thumbImgV,playVentureBtn,uploadVentureBtn,discardBtn;
@synthesize uploadVentureLoader;
@synthesize captionTxt,captionHolder;
@synthesize adHideKeyboard;
int yaxis;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    thumbImgV.image =app.thumbImg;
    uploadVentureBtn.layer.cornerRadius = uploadVentureBtn.frame.size.height/2;
    uploadVentureBtn.layer.masksToBounds = YES;
    yaxis = captionHolder.frame.origin.y;
    
    UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(terminateKeyboard:)];
    swiper.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swiper];
    // Do any additional setup after loading the view.
}

-(void)terminateKeyboard:(UIGestureRecognizer *)gesture{
    if(captionTxt.text.length==0){
        captionTxt.text = @"Add Caption";
    }
    [captionTxt resignFirstResponder];
    CGRect frame = captionHolder.frame;
    frame.origin.y = uploadVentureBtn.frame.origin.y-captionHolder.frame.size.height;
    captionHolder.frame = frame;
    [adHideKeyboard setHidden:YES];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [adHideKeyboard setHidden:NO];
    CGRect frame = captionHolder.frame;
    frame.origin.y = self.view.frame.size.height-216-captionHolder.frame.size.height;
    captionHolder.frame = frame;
    if([textView.text isEqualToString:@"Add Caption"]){
        textView.text = @"";
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
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
        int height = [self returnSizeofLabel:completeMsg width:textView.frame.size.width];
        if(height>100){
            height = 100;
        }else if(height<30){
            height = 30;
        }
        
        CGRect frame = captionHolder.frame;
        frame.size.height = height+10;
        frame.origin.y = self.view.frame.size.height-216-frame.size.height;
        captionHolder.frame = frame;
        yaxis = frame.origin.y;
        
        CGRect tFrame = textView.frame;
        tFrame.size.height = height;
        textView.frame = tFrame;
    }else{
        int height = 34;
        
        CGRect frame = captionHolder.frame;
        frame.size.height = height+10;
        frame.origin.y = self.view.frame.size.height-216-frame.size.height;
        captionHolder.frame = frame;
        yaxis = frame.origin.y;
        
        
        CGRect tFrame = textView.frame;
        tFrame.size.height = height;
        textView.frame = tFrame;
    }
    
    return YES;
}

-(int)returnSizeofLabel:(NSString *)str width:(int)width{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    // CGSize expectedLabelSize = [str sizeWithFont:[UIFont fontWithName:@"Raleway-Bold" size:19] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    UIFont *labelFont = [UIFont fontWithName:@"Raleway-Bold" size:19];
    CGRect expectedLabelRect = [str boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: labelFont} context:nil];
    return expectedLabelRect.size.height;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect frame = captionHolder.frame;
    frame.origin.y = self.view.frame.size.height-216-captionHolder.frame.size.height;
    captionHolder.frame = frame;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    CGRect frame = captionHolder.frame;
    frame.origin.y = yaxis;
    captionHolder.frame = frame;
    return YES;
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==discardBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.window.rootViewController = view;
        
    }else if(sender==playVentureBtn){
        
        MPMoviePlayerViewController *videoPlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.title]];
        [self presentMoviePlayerViewControllerAnimated:videoPlayerView];
        [videoPlayerView.moviePlayer play];
    }else if(sender==uploadVentureBtn){
        if([captionTxt.text isEqualToString:@"Add Caption"] || [captionTxt.text isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Oops! Seems like you forgot to enter caption for Ad Venture." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            return;
        }
        
        [uploadVentureLoader setHidden:NO];
        [uploadVentureBtn setTitle:@"" forState:UIControlStateNormal];
        [self.view setUserInteractionEnabled:NO];
        [self uploadVenture];
        
    }else if(sender==adHideKeyboard){
        if(captionTxt.text.length==0){
            captionTxt.text = @"Add Caption";
        }
        [captionTxt resignFirstResponder];
        CGRect frame = captionHolder.frame;
        frame.origin.y = uploadVentureBtn.frame.origin.y-captionHolder.frame.size.height;
        captionHolder.frame = frame;
        [adHideKeyboard setHidden:YES];
    }
}

-(void)failed:(NSString *)str{
    [uploadVentureLoader setHidden:YES];
    [uploadVentureBtn setTitle:@"Upload" forState:UIControlStateNormal];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(void)venturePosted{
    [uploadVentureLoader setHidden:YES];
    [uploadVentureBtn setTitle:@"Upload" forState:UIControlStateNormal];
    [self.view setUserInteractionEnabled:YES];
    [self buttonPressed:discardBtn];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Venture posted successfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    
    return randomString;
}



-(void)uploadVenture{
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"uploadVenture.php" forKey:@"API"];
    
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.title]];
    NSString *base64video = [videoData base64EncodedStringWithOptions:0];
    base64video = [base64video stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSArray *bits = [self.title componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    NSString *fileext = [bits lastObject];
    NSArray *b = [fileext componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    fileext = [b lastObject];
    NSString *filename =[NSString stringWithFormat:@"%@", [self randomStringWithLength:10]];
    [dict setObject:[NSString stringWithFormat:@"venture_video=%@&venture_filename=%@", base64video, filename] forKey:@"requestBody"];

    NSLog(@"Data size: %lu, String size: %lu", (unsigned long)[videoData length], (unsigned long)[base64video length]);
    
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self uploadVenture:result[@"url"]];
                
            }else{
                [self failed:@"Oops! Something went wrong. Please try again, if problem persists, contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize isAspectRation:(BOOL)aspect {
    if (!image) {
        return nil;
    }
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    CGFloat originRatio = image.size.width / image.size.height;
    CGFloat newRatio = newSize.width / newSize.height;
    
    CGSize sz;
    
    if (!aspect) {
        sz = newSize;
    }else {
        if (originRatio < newRatio) {
            sz.height = newSize.height;
            sz.width = newSize.height * originRatio;
        }else {
            sz.width = newSize.width;
            sz.height = newSize.width / originRatio;
        }
    }
    CGFloat scale = 1.0;
    //    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)]) {
    //        CGFloat tmp = [[UIScreen mainScreen]scale];
    //        if (tmp > 1.5) {
    //            scale = 2.0;
    //        }
    //    }
    sz.width /= scale;
    sz.height /= scale;
    UIGraphicsBeginImageContextWithOptions(sz, NO, scale);
    [image drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)uploadVenture:(NSString *)url{
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSData *picData = UIImagePNGRepresentation([Utils imageWithImage:app.thumbImg scaledToSize:CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height*2)]);
    NSString *base64 = [picData base64EncodedStringWithOptions:0];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [dict setObject:@"postVenture.php" forKey:@"API"];
    
    [dict setObject:[NSString stringWithFormat:@"user_id=%@&venture_url=%@&venture_thumb=%@&venture_title=%@",[app.userData objectForKey:@"user_id"],url,base64,captionTxt.text] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self venturePosted];
            }else{
                [self failed:@"Oops! Something went wrong. Please try again, if problem persists, contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
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

