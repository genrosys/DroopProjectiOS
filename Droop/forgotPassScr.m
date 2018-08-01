//
//  forgotPassScr.m
//  Droop
//
//  Created by apple on 30/08/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "forgotPassScr.h"
#import "AppDelegate.h"
@interface forgotPassScr ()

@end

@implementation forgotPassScr
@synthesize forgotCancelBtn,recoverBtn,regEmailAddr;
@synthesize forgotIndicator;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    recoverBtn.layer.cornerRadius = recoverBtn.frame.size.height/4;
    recoverBtn.layer.masksToBounds = YES;
    
    NSMutableAttributedString *attrPass = [[NSMutableAttributedString alloc]initWithString:regEmailAddr.placeholder];
    [attrPass addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, regEmailAddr.placeholder.length)];
    regEmailAddr.attributedPlaceholder = attrPass;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyTap:)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    // Do any additional setup after loading the view.
}

-(void)hideKeyTap:(UIGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)buttonPressed:(id)sender{
    if(sender==forgotCancelBtn){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(sender==recoverBtn){
        NSString *str = @"";
        if(regEmailAddr.text.length==0){
            
            str = @"Oops! Please enter your registered email address, we will send you email to recover your account.";
        }
        if(str.length>0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            return;
        }
        [self.view endEditing:YES];
        [self.view setUserInteractionEnabled:NO];
        [forgotIndicator setHidden:NO];
        [recoverBtn setTitle:@"" forState:UIControlStateNormal];
        [self callForgotAPI];
    }
}

-(void)failed:(NSString *)str{
    [self.view setUserInteractionEnabled:YES];
    [forgotIndicator setHidden:YES];
    [recoverBtn setTitle:@"Recover" forState:UIControlStateNormal];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert  = nil;
}

-(void)success{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)callForgotAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"forgot_pass.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"email=%@",regEmailAddr.text] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self success];
                [self failed:@"We've sent you a mail to recover your account, please check your inbox."];
            }else{
                [self failed:@"Oops! Something went wrong, please try again. If problem persists, contact us."];
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
