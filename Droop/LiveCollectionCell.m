//
//  LiveCollectionCell.m
//  Droop
//
//  Created by Smart Pro on 2/14/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import "LiveCollectionCell.h"
#import <UIImageView+AFNetworking.h>

@implementation LiveCollectionCell

- (void)configWithLive:(NSDictionary *)liveInfo
{
    self.titleLbl.text = [liveInfo[@"live_title"] uppercaseString];
    self.priceLbl.text = [@"$" stringByAppendingString:liveInfo[@"live_cost"]];
    [self.usernameBtn setTitle:liveInfo[@"user_name"] forState:UIControlStateNormal];
    
    NSURL *imageUrl = [NSURL URLWithString:liveInfo[@"user_pic"]];
    [self.mainImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defpic.png"]];
}

@end
