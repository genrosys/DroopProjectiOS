//
//  followersScr.h
//  Droop
//
//  Created by Himanshu Sharma on 23/10/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface followersScr : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *followersTbl;
    IBOutlet UIButton *followersBackBtn;
    IBOutlet UILabel *headerLbl;
}
@property(nonatomic)IBOutlet UILabel *headerLbl;
@property(nonatomic)IBOutlet UITableView *followersTbl;
@property(nonatomic)IBOutlet UIButton *followersBackBtn;
@end
