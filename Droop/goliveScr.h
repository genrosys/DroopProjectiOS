//
//  goliveScr.h
//  Droop
//
//  Created by apple on 20/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <StreamaxiaSDK/StreamaxiaSDK.h>
#import <LLSimpleCamera/LLSimpleCamera.h>
#import <CoreVideo/CoreVideo.h>
#import <WowzaGoCoderSDK/WowzaGoCoderSDK.h>



@interface goliveScr : UIViewController  {
    IBOutlet UIButton *startLiveBtn;
    IBOutlet UIView *recorderPreview;
    IBOutlet UILabel *liveLbl;
    IBOutlet UIButton *cancelLivebtn;
    IBOutlet UIView *commentsHolder;
    IBOutlet UIButton *commentsBtn;
    IBOutlet UILabel *urlLbl;
    IBOutlet UILabel *nocommentsLbl;
    IBOutlet UITableView *commentTbl;
    IBOutlet UIView *commentsendHolder;
    IBOutlet UITextView *sendMsgTxt;
    IBOutlet UIButton *sendMsgBtn;
    IBOutlet UIImageView *sendCommentIcon;
    IBOutlet UIView *backRound;
    IBOutlet UIActivityIndicatorView *sendMsgIndicator;
    IBOutlet UIImageView *tempPre;
    IBOutlet UIView *screenshotTempV;
    IBOutlet UIView *switchCameraV;
    IBOutlet UIView *switchCBtn;
    IBOutlet UIButton *gHideKeyboard;
    IBOutlet UILabel * viewersCountLbl;
}

@property(nonatomic)IBOutlet UILabel * viewersCountLbl;
@property(nonatomic)IBOutlet UIButton *gHideKeyboard;
@property(nonatomic)IBOutlet UIView *switchCameraV;
@property(nonatomic)IBOutlet UIView *switchCBtn;
@property(nonatomic)IBOutlet UIView *screenshotTempV;
@property(nonatomic)IBOutlet UIImageView *tempPre;
@property(nonatomic)IBOutlet UIView *backRound;
@property(nonatomic)IBOutlet UILabel *nocommentsLbl;
@property(nonatomic)IBOutlet UIActivityIndicatorView *sendMsgIndicator;
@property(nonatomic)IBOutlet UIImageView *sendCommentIcon;
@property(nonatomic)IBOutlet UITableView *commentTbl;
@property(nonatomic)IBOutlet UIView *commentsendHolder;
@property(nonatomic)IBOutlet UITextView *sendMsgTxt;
@property(nonatomic)IBOutlet UIButton *sendMsgBtn;
@property(nonatomic)IBOutlet UILabel *urlLbl;
@property(nonatomic)IBOutlet UIButton *commentsBtn;
@property(nonatomic)IBOutlet UIView *commentsHolder;
@property(nonatomic)IBOutlet UIButton *cancelLivebtn;
@property(nonatomic)IBOutlet UILabel *liveLbl;
@property(nonatomic)IBOutlet UIView *recorderPreview;
@property(nonatomic)IBOutlet UIButton *startLiveBtn;

//@property (nonatomic, strong) WowzaGoCoder      *goCoder;
//@property (nonatomic, strong) WowzaConfig       *goCoderConfig;
//@property (nonatomic, strong) WZCameraPreview   *goCoderCameraPreview;
//

@end
