//
//  loginScr.m
//  Droop
//
//  Created by apple on 30/08/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "loginScr.h"
#import "AppDelegate.h"

@interface loginScr ()

@end

@implementation loginScr

@synthesize usernameTxt,passTxt,forgotPassBtn,signInBtn,signUpBtn;
@synthesize loginIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* username = [defaults stringForKey:@"username"];
    NSString* password = [defaults stringForKey:@"password"];
    
    NSMutableAttributedString *attrUser = [[NSMutableAttributedString alloc]initWithString:usernameTxt.placeholder];
    [attrUser addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, usernameTxt.placeholder.length)];
    usernameTxt.attributedPlaceholder = attrUser;
    usernameTxt.text = username;
    
    NSMutableAttributedString *attrPass = [[NSMutableAttributedString alloc]initWithString:passTxt.placeholder];
    [attrPass addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, passTxt.placeholder.length)];
    passTxt.attributedPlaceholder = attrPass;
    passTxt.text = password;
    
    signInBtn.layer.cornerRadius = signInBtn.frame.size.height/4;
    signInBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *hideKeyboardTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    hideKeyboardTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:hideKeyboardTap];
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if(app.dToken.length==0){
    
        [app getToken];
    }
    // Do any additional setup after loading the view.
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==signUpBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"SIGNUP"];
        [self presentViewController:view animated:YES completion:nil];
    }else if(sender==signInBtn){
        NSString *str = @"";
        if(usernameTxt.text.length==0){
            str = @"Oops! Seems like you forgot to enter your username.";
        }else if(passTxt.text.length==0){
            str = @"Oops! Seems like you forgot to enter your password.";
        }
        if(str.length>0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            return;
        }
        [self.view endEditing:YES];
        [self.view setUserInteractionEnabled:NO];
        [loginIndicator setHidden:NO];
        [signInBtn setTitle:@"" forState:UIControlStateNormal];
        [self callLoginAPI];
    }else if(sender==forgotPassBtn){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"FORGOT"];
        [self presentViewController:view animated:YES completion:nil];
    }
}

- (void)successLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:usernameTxt.text forKey:@"username"];
    [defaults setObject:passTxt.text forKey:@"password"];
    
    UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"HOME"];
//    UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"PROFILE"];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    [d setObject:usernameTxt.text forKey:@"username"];
    [d setObject:passTxt.text forKey:@"password"];
    [app saveuser:d];
    //app.window.rootViewController = view;
     [self presentViewController:view animated:NO completion:nil];
}

-(void)callLoginAPI{
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"login.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"username=%@&password=%@&device_token=%@&device_type=iOS", usernameTxt.text, passTxt.text, app.dToken] forKey:@"requestBody"];
    
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if (result.count > 0) {
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"1"]){
                app.userData = [result objectForKey:@"data"];
                [self successLogin];
            } else {
                [self failed:@"Oops! Something went wrong, please try again. If problem persists, contact us."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)failed:(NSString *)str{
    [self.view setUserInteractionEnabled:YES];
    [loginIndicator setHidden:YES];
    [signInBtn setTitle:@"Sign In" forState:UIControlStateNormal];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(void)hideKeyboard:(UIGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
