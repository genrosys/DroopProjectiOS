//
//  broadcastScr.m
//  Droop
//
//  Created by apple on 14/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "broadcastScr.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>

@interface broadcastScr ()

@end

@implementation broadcastScr

@synthesize nomicrophoneLbl;
LLSimpleCamera *camera;
UIButton *snapButton,*rotateCamera,*flashButton;
UIButton *liveModeBtn,*dualPostBtn;
UIButton *cancelBroadcastBtn;
UIButton *galleryBtn;
UILabel *timeLabel;
NSTimer *countdownTimer;
UIImage *thumbImage;
NSURL *outputURL;
BOOL oncall;
int countdown;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    countdown = 15;
    // create camera with standard settings
    //    camera = [[LLSimpleCamera alloc] init];
    
    // camera with video recording capability
    //    camera =  [[LLSimpleCamera alloc] initWithVideoEnabled:YES];
    
    // camera with precise quality, position and video parameters.
    oncall= NO;
    CTCallCenter *ctCallCenter = [[CTCallCenter alloc] init];
    if (ctCallCenter.currentCalls != nil)
    {
        NSArray* currentCalls = [ctCallCenter.currentCalls allObjects];
        for (CTCall *call in currentCalls)
        {
            if(call.callState == CTCallStateConnected)
            {
                oncall= YES;
                // connected
            }
        }
    }
    if(oncall==NO){
        [nomicrophoneLbl setHidden:YES];
        camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh position:LLCameraPositionRear videoEnabled:YES];
        // attach to the view
        
        [camera attachToViewController:self withFrame:screenRect];
        
        [camera start];
    }
    snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    snapButton.frame = CGRectMake((self.view.frame.size.width-70)/2, self.view.frame.size.height-80, 70.0f, 70.0f);
    snapButton.clipsToBounds = YES;
    snapButton.layer.cornerRadius = snapButton.frame.size.width / 2.0f;
    snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    snapButton.layer.borderWidth = 2.0f;
    snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    snapButton.layer.shouldRasterize = YES;
    [snapButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:snapButton];
    // Do any additional setup after loading the view.
    
    liveModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    liveModeBtn.frame = CGRectMake(self.view.frame.size.width/3, self.view.frame.size.height-130, self.view.frame.size.width/3, 50);
    liveModeBtn.clipsToBounds = YES;
    liveModeBtn.backgroundColor = [UIColor clearColor];
    [liveModeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [liveModeBtn setTitle:@"Host Live" forState:UIControlStateNormal];
    liveModeBtn.titleLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:19];
    liveModeBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    liveModeBtn.layer.shouldRasterize = YES;
    [liveModeBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:liveModeBtn];
    
    //    liveModeBtnn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    liveModeBtnn.frame = CGRectMake(0, self.view.frame.size.height-130, self.view.frame.size.width/3, 50);
    //    liveModeBtnn.clipsToBounds = YES;
    //    liveModeBtnn.backgroundColor = [UIColor clearColor];
    //    liveModeBtnn.titleLabel.text = @"Live Sell";
    //    liveModeBtnn.titleLabel.textColor = [UIColor whiteColor];
    //
    //    liveModeBtnn.titleLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:19];
    //    [self.view addSubview:liveModeBtnn];
    
//    adventureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-130, self.view.frame.size.width/3, 50)];
//    adventureBtn.backgroundColor = [UIColor clearColor];
//    [adventureBtn setTitle:@"Ad Venture" forState:UIControlStateNormal];
//    adventureBtn.clipsToBounds = YES;
//    adventureBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    adventureBtn.layer.shouldRasterize = YES;
//    [adventureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    adventureBtn.titleLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:19];
//    [adventureBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:adventureBtn];
    
    dualPostBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width/3)*2, self.view.frame.size.height-130, self.view.frame.size.width/3, 50)];
    dualPostBtn.backgroundColor = [UIColor clearColor];
    [dualPostBtn setTitle:@"Dual Post" forState:UIControlStateNormal];
    dualPostBtn.clipsToBounds = YES;
    dualPostBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    dualPostBtn.layer.shouldRasterize = YES;
    [dualPostBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dualPostBtn.titleLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:19];
    [dualPostBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dualPostBtn];
    
    
    rotateCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    rotateCamera.frame = CGRectMake(self.view.frame.size.width-65, 25, 40, 14);
    rotateCamera.clipsToBounds = YES;
    [rotateCamera setBackgroundImage:[UIImage imageNamed:@"camerarotate.png"] forState:UIControlStateNormal];
    [rotateCamera addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotateCamera];
    
    flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flashButton.frame = CGRectMake((self.view.frame.size.width-30)/2, 15, 30,30 );
    flashButton.clipsToBounds = YES;
    [flashButton setBackgroundImage:[UIImage imageNamed:@"flashoff.png"] forState:UIControlStateNormal];
    [flashButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashButton];
    
    cancelBroadcastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBroadcastBtn.frame = CGRectMake(15, 15, 25, 25);
    cancelBroadcastBtn.clipsToBounds = YES;
    [cancelBroadcastBtn setBackgroundImage:[UIImage imageNamed:@"crossic.png"] forState:UIControlStateNormal];
    [cancelBroadcastBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBroadcastBtn];
    
    [self buttonPressed:liveModeBtn];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 30)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:17];
    timeLabel.textColor = [UIColor redColor];
    timeLabel.text = @"00:00:15";
    [self.view addSubview:timeLabel];
    
    
    galleryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    galleryBtn.frame = CGRectMake(self.view.frame.size.width-40, self.view.frame.size.height-40, 30, 30);
    galleryBtn.clipsToBounds = YES;
    [galleryBtn setBackgroundImage:[UIImage imageNamed:@"gellryic.png"] forState:UIControlStateNormal];
    [galleryBtn setHidden:YES];
    [galleryBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:galleryBtn];
    [timeLabel setHidden:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    if(dualPostBtn.tag==1){
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.thumbImg = [info objectForKey:UIImagePickerControllerEditedImage];
        
    }
    
    
    
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==flashButton){
        if(oncall){
            return;
        }
        if(camera.flash == LLCameraFlashOff) {
            BOOL done = [camera updateFlashMode:LLCameraFlashOn];
            if(done) {
                [flashButton setBackgroundImage:[UIImage imageNamed:@"flashon.png"] forState:UIControlStateNormal];
            }
        }
        else {
            BOOL done = [camera updateFlashMode:LLCameraFlashOff];
            if(done) {
                [flashButton setBackgroundImage:[UIImage imageNamed:@"flashoff.png"] forState:UIControlStateNormal];
            }
        }
    }else if(sender==rotateCamera){
        
        if(oncall){
            return;
        }
        [camera togglePosition];
    }else if(sender==snapButton){
        if(oncall){
            return;
        }
        if(liveModeBtn.tag==1){
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ADDPOSTSETUP"];
            [self presentViewController:view animated:YES completion:nil];
            return;
        }
        
        if(dualPostBtn.tag==1){
            [camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
                if(!error) {
                    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                    app.croppedImage = image;
                    UIStoryboard *story = self.storyboard;
                    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"FinaliseDual"];
                    app.window.rootViewController = view;
                }
                else {
                    NSLog(@"An error has occured: %@", error);
                }
            } exactSeenImage:YES];
            
        }
    }else if(sender==dualPostBtn){
        
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"FinaliseDual"];
        app.window.rootViewController = view;
        
        //        dualPostBtn.tag=1;
        //        liveModeBtn.tag=0;
        //        adventureBtn.tag=0;
        //
        //        [dualPostBtn setTitleColor:[UIColor colorWithRed:0.29 green:0.67 blue:0.61 alpha:1.0] forState:UIControlStateNormal];
        //        [liveModeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [adventureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if(sender==galleryBtn){
        
        if(dualPostBtn.tag==1){
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
        
        
    }else if(sender==liveModeBtn){
        if(oncall){
            return;
        }
        dualPostBtn.tag=0;
        liveModeBtn.tag=1;
        
        [liveModeBtn setTitleColor:[UIColor colorWithRed:0.29 green:0.67 blue:0.61 alpha:1.0] forState:UIControlStateNormal];
        [dualPostBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else if(sender==cancelBroadcastBtn){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



-(void)moveNext{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UIStoryboard *story = self.storyboard;
    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ADVENTUREFINAL"];
    view.title = [NSString stringWithFormat:@"%@",outputURL];
    
    app.window.rootViewController = view;
}

- (NSString *)outputFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"compressed.MOV"]; NSFileManager *fileManager = [NSFileManager defaultManager];
    //    return path;
    if ([fileManager fileExistsAtPath: path])
    {
        [fileManager removeItemAtPath:path error:nil];
    }
    path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"compressed.MOV"] ];
    NSLog(@"path is== %@", path);
    return path;
}
// Actual compression is here.
- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                  outputURLL:(NSURL*)outputURLL
                                     handler:(void (^)(AVAssetExportSession*))handler
{
    //    [self startCompressingTheVideo:outputURLL];
    //
    //
    //    return;
    [[NSFileManager defaultManager] removeItemAtURL:outputURLL error:nil];
    //    AVAssetWriter
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    //    exportSession.fileLengthLimit = 30*1024;
    exportSession.outputURL = outputURLL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(exportSession);
         //         [exportSession release];
     }];
}

- (void)compressMyVideo:(NSURL *)videoPath completionBlock:(void(^)(id data, BOOL result))block{
    NSLog(@"compressing ====%@", videoPath);
    
    NSURL *videoURL = videoPath;//[NSURL fileURLWithPath:videoPath];
    NSLog(@"video url is== %@", videoURL);
    NSString *outputPath = [self outputFilePath];
    outputURL = [NSURL fileURLWithPath:outputPath];
    [self convertVideoToLowQuailtyWithInputURL:videoURL outputURLL:outputURL handler:^(AVAssetExportSession *exportSession)
     {
         if (exportSession.status == AVAssetExportSessionStatusCompleted)
         {
             printf("completed\n");
             block(outputURL, YES);
         }
         else
         {
             printf("error\n");
             block(nil, NO);
         }
     }];
}


-(void)countdown{
    countdown = countdown-1;
    if(countdown==0){
        [countdownTimer invalidate];
        countdownTimer = nil;
        [self buttonPressed:snapButton];
    }else{
        timeLabel.text = [NSString stringWithFormat:@"00:00:%d",countdown];
    }
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
