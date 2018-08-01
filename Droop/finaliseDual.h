//
//  finaliseDual.h
//  Droop
//
//  Created by Himanshu Sharma on 23/10/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSKImageCropper/RSKImageCropper.h>
#import <LLSimpleCamera.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface finaliseDual : UIViewController <RSKImageCropViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate> {
    IBOutlet UIView *imgdual;
    IBOutlet UIButton *dualCancel;
    IBOutlet UIScrollView *dualScroller;
    IBOutlet UIView *bottomHolder;
    IBOutlet UICollectionView *peersColl;//,*followerColl;
    IBOutlet UIButton *postDualConfBtn;
    IBOutlet UIActivityIndicatorView *postDualIndicator;
    IBOutlet UIImageView *finalImgSel;
    IBOutlet UIButton *flashButtond,*switchButtond,*dshutterBtn,*photolibrarybtn;
    IBOutlet UIImageView *flashicond,*switchicond,*photoLibraryicon;
    IBOutlet UIView *shutterHolderView;
    IBOutlet UITextView *captionDTxt;
    IBOutlet UIButton *dHideKeyboard;
    IBOutlet UILabel *addCaptionHeader;
    IBOutlet UILabel *dualHeaderLbl;
}

@property(nonatomic)IBOutlet UILabel *dualHeaderLbl;
@property(nonatomic)IBOutlet UILabel *addCaptionHeader;
@property(nonatomic)IBOutlet UIButton *dHideKeyboard;
@property(nonatomic)IBOutlet UITextView *captionDTxt;
@property(nonatomic)IBOutlet UIView *shutterHolderView;
@property(nonatomic)UIImageView *flashicond,*switchicond,*photoLibraryicon;
@property(nonatomic)IBOutlet UIButton *flashButtond,*switchButtond,*dshutterBtn,*photolibrarybtn;
@property(nonatomic)IBOutlet UIImageView *finalImgSel;
@property(nonatomic)IBOutlet UIActivityIndicatorView *postDualIndicator;
@property(nonatomic)IBOutlet UIButton *postDualConfBtn;
@property(nonatomic)IBOutlet UIScrollView *dualScroller;
@property(nonatomic)IBOutlet UIView *bottomHolder;
@property(nonatomic)IBOutlet UICollectionView *peersColl;//,*followerColl;
@property(nonatomic)IBOutlet UIView *imgdual;
@property(nonatomic)IBOutlet UIButton *dualCancel;

@end
