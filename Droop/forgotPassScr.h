//
//  forgotPassScr.h
//  Droop
//
//  Created by apple on 30/08/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgotPassScr : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *regEmailAddr;
    IBOutlet UIButton *recoverBtn,*forgotCancelBtn;
    IBOutlet UIActivityIndicatorView *forgotIndicator;
}
@property(nonatomic)IBOutlet UIActivityIndicatorView *forgotIndicator;
@property(nonatomic)IBOutlet UITextField *regEmailAddr;
@property(nonatomic)IBOutlet UIButton *recoverBtn,*forgotCancelBtn;
@end
