//
//  LiveCollectionCell.h
//  Droop
//
//  Created by Smart Pro on 2/14/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *usernameBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

- (void)configWithLive:(NSDictionary *)liveInfo;

@end
