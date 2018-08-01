//
//  signupScr.m
//  Droop
//
//  Created by apple on 30/08/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "signupScr.h"
#import "AppDelegate.h"
#import "Utils.h"

@interface signupScr ()

@end

@implementation signupScr
@synthesize sPassTxt,sUserNTxt,sProfilePic,sFullNameTxt,sEmailAddrTxt,cancelSignUp,confirmBtn;
@synthesize scroller;
@synthesize signUpIndicator;
@synthesize termsSignupBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    confirmBtn.layer.cornerRadius = confirmBtn.frame.size.height/4;
    confirmBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *hideKeyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    hideKeyTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:hideKeyTap];
    
    
    NSMutableAttributedString *attrUser = [[NSMutableAttributedString alloc]initWithString:sUserNTxt.placeholder];
    [attrUser addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, sUserNTxt.placeholder.length)];
    sUserNTxt.attributedPlaceholder = attrUser;
    
    NSMutableAttributedString *attrPass = [[NSMutableAttributedString alloc]initWithString:sPassTxt.placeholder];
    [attrPass addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, sPassTxt.placeholder.length)];
    sPassTxt.attributedPlaceholder = attrPass;
    
    NSMutableAttributedString *attrfulln = [[NSMutableAttributedString alloc]initWithString:sFullNameTxt.placeholder];
    [attrfulln addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, sFullNameTxt.placeholder.length)];
    sFullNameTxt.attributedPlaceholder = attrfulln;
    
    NSMutableAttributedString *attremail = [[NSMutableAttributedString alloc]initWithString:sEmailAddrTxt.placeholder];
    [attremail addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, sEmailAddrTxt.placeholder.length)];
    sEmailAddrTxt.attributedPlaceholder = attremail;
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImageTap:)];
    imageTap.numberOfTapsRequired = 1;
    [sProfilePic setUserInteractionEnabled:YES];
    [sProfilePic addGestureRecognizer:imageTap];
    
    
    scroller.contentSize = CGSizeMake(scroller.frame.size.width, confirmBtn.frame.origin.y+confirmBtn.frame.size.height+20);
    // Do any additional setup after loading the view.
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect frame = scroller.frame;
    frame.size.height = self.view.frame.size.height-216;
    scroller.frame = frame;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    CGRect frame = scroller.frame;
    frame.size.height = self.view.frame.size.height;
    scroller.frame = frame;
    return YES;
}
-(IBAction)buttonPressed:(id)sender{
    if(sender==cancelSignUp){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(sender==confirmBtn){
        NSString *str =@"";
        if(sUserNTxt.text.length==0){
            str = @"Oops! Enter a username you want , for your account.";
        }else if(sFullNameTxt.text.length==0){
            str = @"Oops! Please enter your full name.";
        }else if(sEmailAddrTxt.text.length==0){
            str = @"Oops! Enter your email address, it will help you to recover your account when needed.";
        }else if(sPassTxt.text.length==0){
            str = @"Oops! Enter password to secure your account.";
        }
        if(str.length>0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            return;
        }
        [self.view endEditing:YES];
        CGRect frame = scroller.frame;
        frame.size.height = self.view.frame.size.height;
        scroller.frame = frame;
        [self.view setUserInteractionEnabled:NO];
        [signUpIndicator setHidden:NO];
        [confirmBtn setTitle:@"" forState:UIControlStateNormal];
        [self callSignUp];
    }else if(sender==termsSignupBtn){
        NSURL *URL = [NSURL URLWithString:@"http://www.droopllc.com/Droop1/tncDroop.pdf"];
        [[UIApplication sharedApplication] openURL:URL];
    }
}

-(void)failed:(NSString *)str{
    [self.view setUserInteractionEnabled:YES];
    [signUpIndicator setHidden:YES];
    [confirmBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}
-(void)successSignup{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sUserNTxt.text forKey:@"username"];
    [defaults setObject:sPassTxt.text forKey:@"password"];
    UIStoryboard *story = self.storyboard;
    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
//    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"PROFILE"];
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *d = [[NSMutableDictionary alloc]init];
    [d setObject:sUserNTxt.text forKey:@"username"];
    [d setObject:sPassTxt.text forKey:@"password"];
    [app saveuser:d];
    //app.window.rootViewController = view;
    [self presentViewController:view animated:NO completion:nil];
}
-(void)callSignUp{
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSData *data = UIImagePNGRepresentation([Utils imageWithImage:sProfilePic.image scaledToSize:CGSizeMake(600, 600)]);
    
    NSString *base64 = [data base64EncodedStringWithOptions:0];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"signup.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"name=%@&email=%@&pass=%@&username=%@&profile_pic=%@&device_token=%@&device_type=%@", sFullNameTxt.text, sEmailAddrTxt.text, sPassTxt.text, sUserNTxt.text, base64,app.dToken, @"iOS"] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                app.userData = [result objectForKey:@"data"];
                [self successSignup];
            }else if([status isEqualToString:@"2"]){
                [self failed:@"Oops! This email address is already registered with us, recover your account using 'Forgot Password', if this email belongs to you."];
            }else if([status isEqualToString:@"3"]){
                [self failed:@"Oops! This username is already taken, use different username."];
            }else{
                [self failed:@"Oops! Something went wrong, please check and try again. If problem persists, contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)selectImageTap:(UIGestureRecognizer *)tap{
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Gallery",@"Camera", nil];
    [action showInView:self.view];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    sProfilePic.image = [info objectForKey:UIImagePickerControllerEditedImage];
    sProfilePic.layer.cornerRadius = sProfilePic.frame.size.height/2;
    sProfilePic.layer.masksToBounds = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        [picker setDelegate:self];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [picker setAllowsEditing:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }else if(buttonIndex==1){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        [picker setDelegate:self];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [picker setAllowsEditing:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }
}
-(void)hideKeyboard:(UIGestureRecognizer *)gesture{
    [self.view endEditing:YES];
    CGRect frame = scroller.frame;
    frame.size.height = self.view.frame.size.height;
    scroller.frame = frame;
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
