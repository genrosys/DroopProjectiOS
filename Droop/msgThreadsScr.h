//
//  msgThreadsScr.h
//  Droop
//
//  Created by Himanshu Sharma on 03/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface msgThreadsScr : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    IBOutlet UITableView *threadTbl;
    IBOutlet UITextField *mSearchTxt;
    IBOutlet UIButton *threadHomeBtn,*threadDiscoverScr,*threadPostBtn,*threadprofileBtn;
    IBOutlet UIButton *msgThreadBackBtn;
    IBOutlet UIView *msgThreadNotificationIndicator;
}

@property(nonatomic)IBOutlet UIView *msgThreadNotificationIndicator;
@property(nonatomic)IBOutlet UIButton *msgThreadBackBtn;
@property(nonatomic)IBOutlet UITextField *mSearchTxt;
@property(nonatomic)IBOutlet UITableView *threadTbl;
@property(nonatomic)IBOutlet UIButton *threadHomeBtn,*threadDiscoverScr,*threadPostBtn,*threadprofileBtn;

@end
