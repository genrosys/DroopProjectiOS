//
//  liveHostAllScr.h
//  Droop
//
//  Created by Himanshu Sharma on 25/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface liveHostAllScr : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>{
    IBOutlet UICollectionView *livehostallcoll;
    IBOutlet UIButton *livehostAllBack,*livehostAllPost;
    IBOutlet UITextField *livehostSearchTxt;
    IBOutlet UIView *livehostAllHeadV;
}
@property(nonatomic)IBOutlet UIView *livehostAllHeadV;
@property(nonatomic)IBOutlet UICollectionView *livehostallcoll;
@property(nonatomic)IBOutlet UIButton *livehostAllBack,*livehostAllPost;
@property(nonatomic)IBOutlet UITextField *livehostSearchTxt;
@end
