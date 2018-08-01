//
//  signupScr.h
//  Droop
//
//  Created by apple on 30/08/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface signupScr : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    IBOutlet UITextField *sUserNTxt,*sFullNameTxt,*sPassTxt,*sEmailAddrTxt;
    IBOutlet UIImageView *sProfilePic;
    IBOutlet UIButton *confirmBtn,*cancelSignUp;
    IBOutlet UIScrollView *scroller;
    IBOutlet UIActivityIndicatorView *signUpIndicator;
    IBOutlet UIButton *termsSignupBtn;
}
@property(nonatomic)IBOutlet UIButton *termsSignupBtn;
@property(nonatomic)IBOutlet UIActivityIndicatorView *signUpIndicator;
@property(nonatomic)IBOutlet UIScrollView *scroller;
@property(nonatomic)IBOutlet UITextField *sUserNTxt,*sFullNameTxt,*sPassTxt,*sEmailAddrTxt;
@property(nonatomic)IBOutlet UIImageView *sProfilePic;
@property(nonatomic)IBOutlet UIButton *confirmBtn,*cancelSignUp;
@end
