//
//  msgsScr.h
//  Droop
//
//  Created by Himanshu Sharma on 03/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface msgsScr : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIAlertViewDelegate> {
    
    IBOutlet UITableView *msgsTbl;
    IBOutlet UIView *msgSendHolder;
    IBOutlet UIView *roundsendmsgback;
    IBOutlet UITextView *msgTxtField;
    IBOutlet UIImageView *sendMsgArr;
    IBOutlet UIActivityIndicatorView *indicatorSendMsg;
    IBOutlet UIButton *sendMsgB;
    IBOutlet UIButton *chatBackBtn;
    IBOutlet UILabel *friendNameLbl;
    IBOutlet UIImageView *friendImgV;
    IBOutlet UIActivityIndicatorView *mainIndicator;
    IBOutlet UIButton *friendViewProBtn;
    IBOutlet UIButton *clearChatBtn;
}

@property(nonatomic)IBOutlet UIButton *clearChatBtn;
@property(nonatomic)IBOutlet UIButton *friendViewProBtn;
@property(nonatomic)IBOutlet UIActivityIndicatorView *mainIndicator;
@property(nonatomic)IBOutlet UIButton *chatBackBtn;
@property(nonatomic)IBOutlet UILabel *friendNameLbl;
@property(nonatomic)IBOutlet UIImageView *friendImgV;
@property(nonatomic)IBOutlet UITableView *msgsTbl;
@property(nonatomic)IBOutlet UIView *msgSendHolder;
@property(nonatomic)IBOutlet UIView *roundsendmsgback;
@property(nonatomic)IBOutlet UITextView *msgTxtField;
@property(nonatomic)IBOutlet UIImageView *sendMsgArr;
@property(nonatomic)IBOutlet UIActivityIndicatorView *indicatorSendMsg;
@property(nonatomic)IBOutlet UIButton *sendMsgB;

@end
