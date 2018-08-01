//
//  DualCollectionCell.h
//  Droop
//
//  Created by Smart Pro on 2/14/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DualCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImg;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UIButton *linkedProfileBtn;
@property (weak, nonatomic) IBOutlet UILabel *linkedNameLbl;
@property (weak, nonatomic) IBOutlet UITextView *captionTxt;
@property (weak, nonatomic) IBOutlet UILabel *timestampLbl;

- (void)configWithDual:(NSDictionary *)dualInfo;

@end
