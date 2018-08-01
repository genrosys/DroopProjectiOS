//
//  viewBrodcastScr.h
//  Droop
//
//  Created by apple on 28/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface viewBrodcastScr : UIViewController <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIAlertViewDelegate> {
    IBOutlet UIView *playerHolderr;
    IBOutlet UIButton *cancelViewBroadcast;
    IBOutlet UIButton *commentViewBtn;
    IBOutlet UILabel *titlelive;
    IBOutlet UILabel *costlive;
    MPMoviePlayerController *mp;
    IBOutlet UIView *userDHolder;
    IBOutlet UIImageView *userPPic;
    IBOutlet UITableView *commTbl;
    IBOutlet UIView *sCommHolder;
    IBOutlet UIView *rBack;
    IBOutlet UITextView *sCommTxt;
    IBOutlet UIImageView *sCommIc;
    IBOutlet UIActivityIndicatorView *sCommIndicator;
    IBOutlet UIButton *sCommSendBtn;
    IBOutlet UIScrollView *scrollerVB;
    IBOutlet UIButton *hideKeyboard;
    IBOutlet UIButton *reportLiveBtn;
}

@property(nonatomic)IBOutlet UIButton *reportLiveBtn;
@property(nonatomic)IBOutlet UIButton *hideKeyboard;
@property(nonatomic)IBOutlet UIScrollView *scrollerVB;
@property(nonatomic)IBOutlet UIView *sCommHolder;
@property(nonatomic)IBOutlet UIView *rBack;
@property(nonatomic)IBOutlet UITextView *sCommTxt;
@property(nonatomic)IBOutlet UIImageView *sCommIc;
@property(nonatomic)IBOutlet UIActivityIndicatorView *sCommIndicator;
@property(nonatomic)IBOutlet UIButton *sCommSendBtn;
@property(nonatomic)IBOutlet UITableView *commTbl;
@property(nonatomic)IBOutlet UIImageView *userPPic;
@property(nonatomic)IBOutlet UIView *userDHolder;
@property(nonatomic)MPMoviePlayerController *mp;
@property(nonatomic)IBOutlet UIView *playerHolderr;
@property(nonatomic)IBOutlet UIWebView *previewWebber;
@property(nonatomic)IBOutlet UIButton *cancelViewBroadcast;
@property(nonatomic)IBOutlet UIButton *commentViewBtn;
@property(nonatomic)IBOutlet UILabel *titlelive;
@property(nonatomic)IBOutlet UILabel *costlive;

@end
