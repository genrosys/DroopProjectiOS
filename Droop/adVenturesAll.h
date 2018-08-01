//
//  adVenturesAll.h
//  Droop
//
//  Created by Himanshu Sharma on 25/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface adVenturesAll : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>{
    IBOutlet UICollectionView *adVentureAllColl;
    IBOutlet UIButton *adventureAllBack,*adventureAllPost;
    IBOutlet UITextField *adventureAllSearchTxt;
    IBOutlet UIView *adventureAllheadV;
    IBOutlet UILabel *advNoLbl;
}
@property(nonatomic)IBOutlet UILabel *advNoLbl;
@property(nonatomic)IBOutlet UIView *adventureAllheadV;
@property(nonatomic)IBOutlet UICollectionView *adVentureAllColl;
@property(nonatomic)IBOutlet UIButton *adventureAllBack,*adventureAllPost;
@property(nonatomic)IBOutlet UITextField *adventureAllSearchTxt;
@end
