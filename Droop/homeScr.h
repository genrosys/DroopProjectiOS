//
//  homeScr.h
//  Droop
//
//  Created by apple on 31/08/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface homeScr : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource> {
    IBOutlet UIButton *homeAddPostBtn, *homeMsgBtn, *homeProfileBtn, *homeDiscoverBtn;
    IBOutlet UIButton *goLiveBtn;
    IBOutlet UIView *msgIndicator;
    IBOutlet UIView *notificationIndicator;
}

@property(nonatomic)IBOutlet UIView *notificationIndicator;
@property(nonatomic)IBOutlet UIView *msgIndicator;
@property(nonatomic)IBOutlet UIButton *goLiveBtn;
@property(nonatomic)IBOutlet UIButton *homeAddPostBtn, *homeMsgBtn, *homeProfileBtn, *homeDiscoverBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *homeCollectionView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UISearchBar *userSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchTable;

@end
