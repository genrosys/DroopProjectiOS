//
//  dualDetailsScr.h
//  Droop
//
//  Created by Himanshu Sharma on 16/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
@interface dualDetailsScr : UIViewController<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>{
    IBOutlet UIImageView *dualImggV;
    IBOutlet UIButton *cancelDualDetailBtn,*shareDualBtn;
    IBOutlet UIView *dualPHolder;
    IBOutlet UIButton *dualPBtn;
    IBOutlet UIView *userDHolder;
    IBOutlet UIImageView *userDImg;
    IBOutlet UILabel *dCaptionTV;
    IBOutlet UILabel *dDtimestampLbl;
    IBOutlet UIScrollView *ddScroller;
    IBOutlet UIImageView *dualPostedbypic;
    IBOutlet UIView *dualShareTransV,*dualShareV;
    IBOutlet UIButton *dualMsgShareBtn, *dualEmailShareBtn,*dualFBShareBtn;
    IBOutlet UICollectionView *dualShareFollowersColl;
    IBOutlet UIButton *dualShareCancel,*dualShareConfBtn;
    IBOutlet UILabel *dnoFollowersLbl;
    IBOutlet UIButton *dualPostedByBtn;
    IBOutlet UIButton *dualLinkedProBtn;
    IBOutlet UIButton *reportDualBtn;
    
}
@property(nonatomic)IBOutlet UIButton *reportDualBtn;
@property(nonatomic)IBOutlet UIButton *dualLinkedProBtn;
@property(nonatomic)IBOutlet UIButton *dualPostedByBtn;
@property(nonatomic)IBOutlet UILabel *dnoFollowersLbl;
@property(nonatomic)IBOutlet UIView *dualShareTransV,*dualShareV;
@property(nonatomic)IBOutlet UIButton *dualMsgShareBtn, *dualEmailShareBtn,*dualFBShareBtn;
@property(nonatomic)IBOutlet UICollectionView *dualShareFollowersColl;
@property(nonatomic)IBOutlet UIButton *dualShareCancel,*dualShareConfBtn;
@property(nonatomic)IBOutlet UIImageView *dualPostedbypic;
@property(nonatomic)IBOutlet UIScrollView *ddScroller;
@property(nonatomic)IBOutlet UILabel *dDtimestampLbl;
@property(nonatomic)IBOutlet UIView *dualPHolder;
@property(nonatomic)IBOutlet UIImageView *dualImggV;
@property(nonatomic)IBOutlet UIButton *cancelDualDetailBtn,*shareDualBtn;
@property(nonatomic)IBOutlet UIButton *dualPBtn;
@property(nonatomic)IBOutlet UIView *userDHolder;
@property(nonatomic)IBOutlet UIImageView *userDImg;
@property(nonatomic)IBOutlet UILabel *dCaptionTV;
@end
