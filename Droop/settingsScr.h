//
//  settingsScr.h
//  Droop
//
//  Created by Himanshu Sharma on 20/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface settingsScr : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *delAccIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *settCancelBtn, *setttermsBtn, *settContactBtn, *settReportProblem, *settLogout, *settDeleteAccount;
@property (weak, nonatomic) IBOutlet UIButton *usernameBtn;

@end
