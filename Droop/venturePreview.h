//
//  venturePreview.h
//  Droop
//
//  Created by Himanshu Sharma on 18/10/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Messages/Messages.h>
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import <Social/Social.h>

@interface venturePreview : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate> {
    
    IBOutlet UIButton *cancelVenturePre,*ventureShareBtn;
    IBOutlet UIView *playerHolder;
    IBOutlet UILabel *venturetitleLbl;
    MPMoviePlayerController *mPlayer;
    
    //Share View
    IBOutlet UIView *shareV;
    IBOutlet UICollectionView *followersColl;
    IBOutlet UIButton *mailShareBtn,*msgShareBtn,*fbMsgShareBtn;
    IBOutlet UIButton *cancalShare;
    IBOutlet UILabel *viewsCountLbl;
    IBOutlet UILabel *noFollowersLbl;
    IBOutlet UIButton *ventureChatBtn;
    IBOutlet UIButton *shareVentureBtn;
    IBOutlet UISlider *seekbar;
    IBOutlet UIButton *muteBtn;
    IBOutlet UIImageView *muteic;
    IBOutlet UIButton *reportVentureBtn;
}

@property(nonatomic)IBOutlet UIButton *reportVentureBtn;
@property(nonatomic)IBOutlet UIImageView *muteic;
@property(nonatomic)IBOutlet UIButton *muteBtn;
@property(nonatomic)IBOutlet UISlider *seekbar;
@property(nonatomic)IBOutlet UIButton *shareVentureBtn;
@property(nonatomic)IBOutlet UIButton *ventureChatBtn;
@property(nonatomic)IBOutlet UILabel *noFollowersLbl;
@property(nonatomic)IBOutlet UILabel *viewsCountLbl;
@property(nonatomic)IBOutlet UIView *shareV;
@property(nonatomic)IBOutlet UICollectionView *followersColl;
@property(nonatomic)IBOutlet UIButton *mailShareBtn,*msgShareBtn,*fbMsgShareBtn;
@property(nonatomic)IBOutlet UIButton *cancalShare;
@property(nonatomic)MPMoviePlayerController *mPlayer;
@property(nonatomic)IBOutlet UIButton *cancelVenturePre,*ventureShareBtn;
@property(nonatomic)IBOutlet UIView *playerHolder;
@property(nonatomic)IBOutlet UILabel *venturetitleLbl;

@end
