//
//  otherProScr.h
//  Droop
//
//  Created by Himanshu Sharma on 17/10/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface otherProScr : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource> {
    IBOutlet UIButton *otherCancelBtn;
    IBOutlet UIImageView *otherProImg;
    IBOutlet UILabel *otherProusername;
    IBOutlet UILabel *otherProViewsLbl;
    IBOutlet UICollectionView *otherProDualPostColl;
    IBOutlet UIScrollView *otherScoller;
    IBOutlet UIButton *followBtn;
    IBOutlet UIButton *sendMessageBtn;
    IBOutlet UILabel *opNoDualsLbl;
    IBOutlet UIView *oPreviewImageHolder;
    IBOutlet UIImageView *oPreviewImg;
}

@property(nonatomic)IBOutlet UIView *oPreviewImageHolder;
@property(nonatomic)IBOutlet UIImageView *oPreviewImg;
@property(nonatomic)IBOutlet UILabel *opNoDualsLbl;
@property(nonatomic)IBOutlet UIButton *sendMessageBtn;
@property(nonatomic)IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *blockBtn;
@property(nonatomic)IBOutlet UIScrollView *otherScoller;
@property(nonatomic)IBOutlet UIButton *otherCancelBtn;
@property(nonatomic)IBOutlet UIImageView *otherProImg;
@property(nonatomic)IBOutlet UILabel *otherProusername;
@property(nonatomic)IBOutlet UILabel *otherProViewsLbl;
@property(nonatomic)IBOutlet UICollectionView *otherProDualPostColl;
@property (weak, nonatomic) IBOutlet UIView *detailProfileView;
@property (weak, nonatomic) IBOutlet UIView *followView;

@end
