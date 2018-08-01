//
//  notificationsScr.h
//  Droop
//
//  Created by Himanshu Sharma on 05/12/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationsScr : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextViewDelegate> {
    IBOutlet UITableView *notificationsTbl;
    IBOutlet UIButton *notificationBack,*clearBtn;
    IBOutlet UIActivityIndicatorView *clearIndicator;
    IBOutlet UIImageView *clearic;
    
    //Dual approval screen
    IBOutlet UIView *dualApprovalView;
    IBOutlet UILabel *dualApprovalLbl;
    IBOutlet UIButton *dualAprrovalCancelBtn;
    IBOutlet UIImageView *dualApprovalImage;
    IBOutlet UIScrollView *dualApprovalScroll;
    IBOutlet UITextView *dualApprovalCaptionTxt;
    IBOutlet UIButton *dualApprovalConfBtn;
    IBOutlet UILabel *dualApprovalHeaderLbl;
    IBOutlet UIButton *hideDABtn;
}

@property(nonatomic)IBOutlet UIButton *hideDABtn;
@property(nonatomic)IBOutlet UILabel *dualApprovalHeaderLbl;
@property(nonatomic)IBOutlet UIButton *dualApprovalConfBtn;
@property(nonatomic)IBOutlet UITextView *dualApprovalCaptionTxt;
@property(nonatomic)IBOutlet UIView *dualApprovalView;
@property(nonatomic)IBOutlet UILabel *dualApprovalLbl;
@property(nonatomic)IBOutlet UIButton *dualAprrovalCancelBtn;
@property(nonatomic)IBOutlet UIImageView *dualApprovalImage;
@property(nonatomic)IBOutlet UIScrollView *dualApprovalScroll;
@property(nonatomic)IBOutlet UIImageView *clearic;
@property(nonatomic)IBOutlet UIActivityIndicatorView *clearIndicator;
@property(nonatomic)IBOutlet UIButton *notificationBack,*clearBtn;
@property(nonatomic)IBOutlet UITableView *notificationsTbl;

@end
