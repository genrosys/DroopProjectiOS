//
//  adVentureFinal.h
//  Droop
//
//  Created by apple on 15/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface adVentureFinal : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    
    IBOutlet UIImageView *thumbImgV;
    IBOutlet UIButton *uploadVentureBtn,*playVentureBtn;
    IBOutlet UIButton *discardBtn;
    IBOutlet UIActivityIndicatorView *uploadVentureLoader;
    IBOutlet UIView *captionHolder;
    IBOutlet UIButton *adHideKeyboard;
    IBOutlet UITextView *captionTxt;
}
@property(nonatomic)IBOutlet UIButton *adHideKeyboard;
@property(nonatomic)IBOutlet UIView *captionHolder;
@property(nonatomic)IBOutlet UITextView *captionTxt;
@property(nonatomic)IBOutlet UIActivityIndicatorView *uploadVentureLoader;
@property(nonatomic)IBOutlet UIImageView *thumbImgV;
@property(nonatomic)IBOutlet UIButton *uploadVentureBtn,*playVentureBtn;
@property(nonatomic)IBOutlet UIButton *discardBtn;
@end
