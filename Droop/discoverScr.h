//
//  discoverScr.h
//  Droop
//
//  Created by Himanshu Sharma on 20/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface discoverScr : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate> {
    IBOutlet UICollectionView *discoverColl;
    IBOutlet UIButton *discoverHomeBtn, *discoverAddPostBtn, *discoverMsgBtn, *discoverProBtn, *discoverGoLiveBtn;
    IBOutlet UITextField *disSearchTxt;
    IBOutlet UIView *dMsgIndicator;
    IBOutlet UILabel *dMsgCountLbl;
    IBOutlet UILabel *dNoFeedFound;
    IBOutlet UIView *discoverHostV;
    IBOutlet UIView *discoverNotificationIndicator;
}

@property(nonatomic)IBOutlet UIView *discoverNotificationIndicator;
@property(nonatomic)IBOutlet UIView *discoverHostV;
@property(nonatomic)IBOutlet UILabel *dNoFeedFound;
@property(nonatomic)IBOutlet UIView *dMsgIndicator;
@property(nonatomic)IBOutlet UILabel *dMsgCountLbl;
@property(nonatomic)IBOutlet UICollectionView *discoverColl;
@property(nonatomic)IBOutlet UIButton *discoverHomeBtn, *discoverAddPostBtn, *discoverMsgBtn, *discoverProBtn, *discoverGoLiveBtn;

@end
