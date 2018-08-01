//
//  loginScr.h
//  Droop
//
//  Created by apple on 30/08/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginScr : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *usernameTxt,*passTxt;
    IBOutlet UIButton *signInBtn,*signUpBtn,*forgotPassBtn;
    IBOutlet UIActivityIndicatorView *loginIndicator;
}
@property(nonatomic)IBOutlet UIActivityIndicatorView *loginIndicator;
@property(nonatomic)IBOutlet UITextField *usernameTxt,*passTxt;
@property(nonatomic)IBOutlet UIButton *signInBtn,*signUpBtn,*forgotPassBtn;
@end
