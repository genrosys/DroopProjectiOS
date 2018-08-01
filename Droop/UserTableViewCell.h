//
//  UserTableViewCell.h
//  Droop
//
//  Created by Smart Pro on 2/8/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)configCell:(NSDictionary *)userInfo;

@end
