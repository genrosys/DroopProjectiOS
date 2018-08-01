//
//  broadcastScr.h
//  Droop
//
//  Created by apple on 14/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LLSimpleCamera.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface broadcastScr : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    IBOutlet UILabel *nomicrophoneLbl;
}

@property(nonatomic)IBOutlet UILabel *nomicrophoneLbl;
@property(nonatomic)LLSimpleCamera *camera;

@end
