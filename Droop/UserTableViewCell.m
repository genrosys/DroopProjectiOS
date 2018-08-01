//
//  UserTableViewCell.m
//  Droop
//
//  Created by Smart Pro on 2/8/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import "UserTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCell:(NSDictionary *)userInfo
{
    [self.profileImage setImageWithURL:[NSURL URLWithString:userInfo[@"user_pic"]] placeholderImage:[UIImage imageNamed:@"defpic.png"]];
    self.nameLabel.text = userInfo[@"user_name"];
}

@end
