//
//  addpostSetup.h
//  Droop
//
//  Created by apple on 12/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addpostSetup : UIViewController{
    
    IBOutlet UIView *selectPostTypeV, *selectPostTypePop;
    IBOutlet UIButton *selectPostTypeDone;
    IBOutlet UIButton *typeLiveSell,*typeAdVenture,*typeDualPost;
    IBOutlet UIImageView *liveCheck,*adVentureCheck,*dualPostCheck;
    
    IBOutlet UIView *liveSetTitleV,*liveSetTitlePop;
    IBOutlet UIButton *liveSetTitleDone;
    IBOutlet UITextField *liveSetTitleTxt;
    
    IBOutlet UIView *liveSetPriceV,*liveSetPricePop;
    IBOutlet UIButton *liveSetPriceDone;
    IBOutlet UITextField *liveSetPriceTxt;
    IBOutlet UISwitch *freeSwitchLive;
    IBOutlet UIButton *addpostSetupBack;
}
@property(nonatomic)IBOutlet UIButton *addpostSetupBack;
@property(nonatomic)IBOutlet UISwitch *freeSwitchLive;
@property(nonatomic)IBOutlet UIView *liveSetPriceV,*liveSetPricePop;
@property(nonatomic)IBOutlet UIButton *liveSetPriceDone;
@property(nonatomic)IBOutlet UITextField *liveSetPriceTxt;
@property(nonatomic)IBOutlet UIView *liveSetTitleV,*liveSetTitlePop;
@property(nonatomic)IBOutlet UIButton *liveSetTitleDone;
@property(nonatomic)IBOutlet UITextField *liveSetTitleTxt;
@property(nonatomic)IBOutlet UIImageView *liveCheck,*adVentureCheck,*dualPostCheck;
@property(nonatomic)IBOutlet UIView *selectPostTypeV, *selectPostTypePop;
@property(nonatomic)IBOutlet UIButton *selectPostTypeDone;
@property(nonatomic)IBOutlet UIButton *typeLiveSell,*typeAdVenture,*typeDualPost;
@end
