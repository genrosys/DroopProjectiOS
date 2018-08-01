//
//  settingsScr.m
//  Droop
//
//  Created by Himanshu Sharma on 20/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "settingsScr.h"
#import "AppDelegate.h"
#import "Utils.h"
#import <UIImageView+AFNetworking.h>
#import <RSKImageCropViewController.h>
#import <SVProgressHUD.h>

@interface settingsScr () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate>

@end

@implementation settingsScr

@synthesize settLogout,setttermsBtn,settCancelBtn,settContactBtn,settDeleteAccount,settReportProblem;
@synthesize delAccIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.profileImage.layer.borderColor = [UIColor colorWithRed:0.29 green:0.67 blue:0.61 alpha:1.0].CGColor;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.profileImage setImageWithURL:[NSURL URLWithString:app.userData[@"user_pic"]] placeholderImage:[UIImage imageNamed:@"defpic.png"]];
    [self.usernameBtn setTitle:app.userData[@"user_name"] forState:UIControlStateNormal];
}

- (IBAction)buttonPressed:(id)sender{
    if(sender==settLogout){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logout" message:@"Are you sure, you want to logout?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes", nil];
        alert.tag = 111;
        [alert show];
        
    }else if(sender==settDeleteAccount){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logout" message:@"Are you sure, you want to delete your account? This will delete all your data." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
        alert.tag = 123;
        [alert show];
    }else if(sender==settCancelBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"PROFILE"];
        view.title = self.title;
      //  app.window.rootViewController = view;
        [self presentViewController:view animated:NO completion:nil];
    }else if(sender==settReportProblem){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:[NSString stringWithFormat:@"Droop[Problem]"]];
        [mail setMessageBody:[NSString stringWithFormat:@"%@ reported a problem.",[app.userData objectForKey:@"user_name"]] isHTML:NO];
        [mail setToRecipients:@[@"support@droopllc.com"]];
            settReportProblem.tag=1;
            settContactBtn.tag=0;
        [self presentViewController:mail animated:YES completion:NULL];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Oops! We are unable to complete your request. Please configure your email id on device." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
        }
        
    }else if(sender==settContactBtn){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([MFMailComposeViewController canSendMail]){
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setSubject:[NSString stringWithFormat:@"Droop[Query]"]];
            [mail setMessageBody:[NSString stringWithFormat:@"%@ asked a query.",[app.userData objectForKey:@"user_name"]] isHTML:NO];
            [mail setToRecipients:@[@"support@droopllc.com"]];
            settContactBtn.tag=1;
            settReportProblem.tag=0;
            [self presentViewController:mail animated:YES completion:NULL];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Oops! We are unable to complete your request. Please configure your email id on device." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
        }
    }else if(sender==setttermsBtn){
        NSURL *URL = [NSURL URLWithString:@"http://www.droopllc.com/Droop1/tncDroop.pdf"];
        [[UIApplication sharedApplication] openURL:URL];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(result==MFMailComposeResultSent){
        if(settReportProblem.tag==1){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Thank you! Our team will respond you within 2 business days." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Thank you! Our team will respond you within 2 business days." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag==111){
        //Logout
        if(buttonIndex==1){
            __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app delUser];
            app.userData = nil;
            app.userData = [[NSMutableDictionary alloc]init];
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"LOGIN"];
            app.window.rootViewController = view;
        }
        
    }else if(alertView.tag==123){
        //Delete Account
        if(buttonIndex==0){
            [delAccIndicator setHidden:NO];
            [self.view setUserInteractionEnabled:NO];
            [self deleteAPI];
        }
    }
}

-(void)failedDelete:(NSString *)str{
    [delAccIndicator setHidden:YES];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(void)successDelete{
    [delAccIndicator setHidden:YES];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Your Droop Account has been deleted." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app delUser];
    app.userData = nil;
    app.userData = [[NSMutableDictionary alloc]init];
    UIStoryboard *story = self.storyboard;
    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"LOGIN"];
    app.window.rootViewController = view;
}

-(void)deleteAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"delUser.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@", [app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];
    
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                //Success
                [self successDelete];
            }else{
                //Failed
                [self failedDelete:@"Oops! Seems like we are having trouble, please try again."];
            }
        }else{
            [self failedDelete:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}
    
- (IBAction)onChangePhoto:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Change Profile Photo" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Photo Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [actionSheet addAction:galleryAction];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [actionSheet addAction:cameraAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    imageCropVC.cropMode = RSKImageCropModeCircle;
    imageCropVC.delegate = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:imageCropVC animated:NO completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle
{
    [self updateProfileName:nil andPhoto:croppedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateProfileName:(NSString *)username andPhoto:(UIImage *)profilePhoto {
    [SVProgressHUD showWithStatus:@"Updating..."];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"API"] = @"updateProfile.php";

    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (username == nil || [username length] == 0) {
        username = app.userData[@"user_name"];
    }
    if (profilePhoto == nil) {
        profilePhoto = self.profileImage.image;
    }
    
    NSString *urlPic = [app.userData objectForKey:@"user_pic"];
    NSArray *bits = [urlPic componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    urlPic = [bits lastObject];
    bits = [urlPic componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    urlPic = [bits firstObject];
    NSData *data = UIImagePNGRepresentation([Utils imageWithImage:profilePhoto scaledToSize:CGSizeMake(600, 600)]);
    NSString *base64 = [data base64EncodedStringWithOptions:0];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    dict[@"requestBody"] = [NSString stringWithFormat:@"user_id=%@&user_name=%@&location=%@&filename=%@&profile_pic=%@", app.userData[@"user_id"], username, app.userData[@"user_location"], urlPic, base64];
    
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if (result.count > 0) {
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                app.userData = [result objectForKey:@"data"];
                self.profileImage.image = profilePhoto;
                [self.usernameBtn setTitle:username forState:UIControlStateNormal];
                
                NSMutableDictionary *userInfo = [app getSavedUser];
                userInfo[@"username"] = username;
                [app delUser];
                [app saveuser:userInfo];
                
                [SVProgressHUD showSuccessWithStatus:@"Success!"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Failed!"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"Connection Issue!"];
        }
    }];
}

- (IBAction)onUsername:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"User name"
                                                                   message:@"Enter your new full name."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *fullName = app.userData[@"user_name"];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    
    UIAlertAction *change = [UIAlertAction actionWithTitle:@"Change" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *username = alert.textFields[0].text;
        if ([username length] > 0 && ![username isEqualToString:fullName]) {
            [self updateProfileName:username andPhoto:nil];
        }
    }];
    [alert addAction:change];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"User full name";
        textField.text = fullName;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
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
