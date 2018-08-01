//
//  myProfileScr.h
//  Droop
//
//  Created by apple on 03/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSKImageCropper/RSKImageCropper.h>

@interface myProfileScr : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, RSKImageCropViewControllerDelegate, UIAlertViewDelegate> {
    IBOutlet UIButton *proHomeBtn,*proLiveBtn,*proAddPostBtn,*proMsgBtn,*editProBtn;
    IBOutlet UIScrollView *proMainScroller,*proLiveScroller,*proVentureScroller,*proDualPostScroller;
    IBOutlet UIView *proLiveV;
    IBOutlet UIImageView *proprofilePic;
    IBOutlet UITextField *prouserNameTxt,*proLocationTxt;
    IBOutlet UIImageView *demoPro1,*demoPro2;
    IBOutlet UIActivityIndicatorView *updateLoader;
    IBOutlet UILabel *followersLbl,*followingLbl;
    IBOutlet UIButton *followersBtn,*followingBtn;
    IBOutlet UIView *followingView;
    IBOutlet UILabel *nuberOfViewsLbl;
    IBOutlet UIView *changePicHolder;
    IBOutlet UIImageView *editIcon;
    IBOutlet UIButton *changeProfilePicBtn;
    IBOutlet UILabel *pNoDualsLbl;
    IBOutlet UIView *isnotification;
    
    IBOutlet UICollectionView *dualPostColl;
    IBOutlet UIView *pMsgIndicator;
    IBOutlet UILabel *pMsgunreadCount;
    IBOutlet UIView *picPreviewHolder;
    IBOutlet UIImageView *previewImg;
    IBOutlet UIButton *settingBtn;
    IBOutlet UIButton *notificationsBtn;
    IBOutlet UIButton *msgBackBtn;
}

@property(nonatomic)IBOutlet UIButton *notificationsBtn;
@property(nonatomic)IBOutlet UIView *isnotification;
@property(nonatomic)IBOutlet UIButton *settingBtn;
@property(nonatomic)IBOutlet UIView *pMsgIndicator;
@property(nonatomic)IBOutlet UILabel *pMsgunreadCount;
@property(nonatomic)IBOutlet UILabel *pNoVentureLbl;
@property(nonatomic)IBOutlet UILabel *pNoDualsLbl;
@property(nonatomic)IBOutlet UILabel *nuberOfViewsLbl;
@property(nonatomic)IBOutlet UILabel *followersLbl,*followingLbl;
@property(nonatomic)IBOutlet UIButton *followersBtn,*followingBtn;
@property(nonatomic)IBOutlet UIView *followingView;
@property(nonatomic)IBOutlet UICollectionView *dualPostColl,*adVenturesColl;
@property(nonatomic)IBOutlet UIView *dualPostHolder,*adventureHolder;
@property(nonatomic)IBOutlet UIScrollView *viewsScroller;
@property(nonatomic)IBOutlet UIImageView *proprofilePic;
@property(nonatomic)IBOutlet UIView *picPreviewHolder;
@property(nonatomic)IBOutlet UIImageView *previewImg;
@property(nonatomic)IBOutlet UIActivityIndicatorView *updateLoader;
@property(nonatomic)IBOutlet UIImageView *editIcon;
@property(nonatomic)IBOutlet UIView *changePicHolder;
@property(nonatomic)IBOutlet UIButton *changeProfilePicBtn;
@property(nonatomic)IBOutlet UITextField *prouserNameTxt,*proLocationTxt;
@property(nonatomic)IBOutlet UIImageView *demoPro1,*demoPro2;
@property(nonatomic)IBOutlet UIScrollView *proMainScroller,*proLiveScroller,*proVentureScroller,*proDualPostScroller;
@property(nonatomic)IBOutlet UIView *proLiveV,*proVentureV;
@property(nonatomic)IBOutlet UIButton *proHomeBtn,*proLiveBtn,*proAddPostBtn,*proMsgBtn,*editProBtn;
@property(nonatomic)IBOutlet UIButton *msgBackBtn;

@end
