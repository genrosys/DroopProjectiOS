//
//  goliveScr.m
//  Droop
//
//  Created by apple on 20/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "goliveScr.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>
#import <WowzaGoCoderSDK/WowzaGoCoderSDK.h>
#import "SettingsViewModel.h"
#import "SettingsViewController.h"
#import "MP4Writer.h"



#pragma mark VideoPlayerViewController (GoCoder SDK Sample App) -

NSString *const SDKSampleSavedConfigKey = @"SDKSampleSavedConfigKey";
//NSString *const SDKSampleAppLicenseKey = @"GOSK-6443-0101-CD19-EB0F-E04E"; //old-no-features

//USE NEW KEY
NSString *const SDKSampleAppLicenseKey = @"GOSK-6D45-010F-F010-333D-AC20"; // com.wowza.gocoder.sdk.bpsampleapp



@interface goliveScr () <WZStatusCallback, WZVideoSink, WZAudioSink, WZVideoEncoderSink, WZAudioEncoderSink>

#pragma mark - UI Elements
@property (nonatomic, weak) IBOutlet UIButton           *broadcastButton;
@property (nonatomic, weak) IBOutlet UIButton           *settingsButton;
@property (nonatomic, weak) IBOutlet UIButton           *switchCameraButton;
@property (nonatomic, weak) IBOutlet UIButton           *torchButton;
@property (nonatomic, weak) IBOutlet UIButton           *micButton;
@property (weak, nonatomic) IBOutlet UILabel            *timeLabel;


#pragma mark - GoCoder SDK Components
@property (nonatomic, strong) WowzaGoCoder      *goCoder;
@property (nonatomic, strong) WowzaConfig       *goCoderConfig;
@property (nonatomic, strong) WZCameraPreview   *goCoderCameraPreview;

#pragma mark - Data
@property (nonatomic, strong) NSMutableArray    *receivedGoCoderEventCodes;
@property (nonatomic, assign) BOOL              blackAndWhiteVideoEffect;
@property (nonatomic, assign) BOOL              recordVideoLocally;
@property (nonatomic, assign) CMTime            broadcastStartTime;

#pragma mark - MP4Writing
@property (nonatomic, strong) MP4Writer         *mp4Writer;
@property (nonatomic, assign) BOOL              writeMP4;
@property (nonatomic, strong) dispatch_queue_t  video_capture_queue;

#pragma mark - WZData injection
@property (nonatomic, assign) long long         broadcastFrameCount;

@end

@implementation goliveScr

@synthesize startLiveBtn;
@synthesize recorderPreview;
@synthesize liveLbl;
@synthesize cancelLivebtn;
@synthesize commentsHolder;
@synthesize commentsBtn;
@synthesize urlLbl;
@synthesize commentTbl,sendMsgBtn,sendMsgTxt,commentsendHolder;
@synthesize sendCommentIcon;
@synthesize sendMsgIndicator;
@synthesize nocommentsLbl;
@synthesize backRound;
@synthesize tempPre;
@synthesize screenshotTempV;
@synthesize switchCBtn,switchCameraV;
@synthesize gHideKeyboard;
@synthesize viewersCountLbl;
UIColor *basicColor;
NSTimer *liveTimer;
//AXRecorder *recorderr;
NSString *streamname;
NSString *liveTitle, *liveCost;
NSMutableDictionary *liveSData;
NSMutableArray *commentsArr;
LLSimpleCamera *glCamera;
NSTimer *commentfetchtimer;
NSString *viewer;
BOOL isfetched;

#pragma mark - UIViewController Protocol Instance Methods

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"VideoPlayerViewController - goodbye");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isfetched = NO;
    viewer = @"0";
    CGRect rFrame = recorderPreview.frame;
    rFrame.size.height = self.view.frame.size.width;
    rFrame.size.width = self.view.frame.size.width;
    recorderPreview.frame = rFrame;
    
    screenshotTempV.frame = rFrame;
    
    CGRect commhFrame = commentsHolder.frame;
    commhFrame.origin.y = rFrame.size.height;
    commhFrame.size.height = self.view.frame.size.height-rFrame.size.height;
    commentsHolder.frame = commhFrame;
    
    CGRect slFrame = startLiveBtn.frame;
    slFrame.origin.y = rFrame.size.height-startLiveBtn.frame.size.height-10;
    startLiveBtn.frame = slFrame;
    
    CGRect scFrame = switchCameraV.frame;
    scFrame.origin.y = rFrame.size.height-switchCameraV.frame.size.height-10;
    switchCameraV.frame = scFrame;
    
    CGRect vF = viewersCountLbl.frame;
    vF.origin.y = rFrame.size.height-viewersCountLbl.frame.size.height-10;
    viewersCountLbl.frame = vF;
    
    basicColor = startLiveBtn.backgroundColor;
    commentsArr = [[NSMutableArray alloc]init];
    startLiveBtn.layer.cornerRadius = startLiveBtn.frame.size.height/2;
    startLiveBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    startLiveBtn.layer.borderWidth  = 2;
    startLiveBtn.layer.masksToBounds = YES;
    
    backRound.layer.cornerRadius = backRound.frame.size.height/2;
    backRound.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backRound.layer.borderWidth = 1;
    backRound.layer.masksToBounds = YES;
    [commentsBtn setHidden:YES];
    NSArray *bits = [self.title componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    liveTitle = [bits objectAtIndex:0];
    liveCost = [bits objectAtIndex:1];
    
    
    
    
    
    
    // Removing **Streamaxia** SDK
//
//
//
//    AXStreamaxiaSDK *sdk = [AXStreamaxiaSDK sharedInstance];
//    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"streamaxiabundle" withExtension:@"bundle"];
//    NSLog(@"%@", bundleURL);
//    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
//    [sdk setupSDKWithURL:bundle.bundleURL withCompletion:^(BOOL success, AXError *error){
//        [sdk debugPrintSDKStatus];
//        if(success){
//            [self performSelectorOnMainThread:@selector(setupStream) withObject:nil waitUntilDone:NO];
//        }
//    }];
//
//    sendMsgTxt.text = @"Write Comment Here ...";
//
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(terminateKeyboard:)];
//    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
//    [self.view addGestureRecognizer:swipeGesture];
//
//    //    [recorderPreview addGestureRecognizer:tappreview];
//
//    // Do any additional setup after loading the view.
//
    [self prepareGeoCoder];
    
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.goCoder.cameraPreview.previewLayer.frame = self.view.bounds;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSData *savedConfigData = [NSKeyedArchiver archivedDataWithRootObject:self.goCoderConfig];
    [[NSUserDefaults standardUserDefaults] setObject:savedConfigData forKey:SDKSampleSavedConfigKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Update the configuration settings in the GoCoder SDK
    if (self.goCoder != nil)
        self.goCoder.config = self.goCoderConfig;
    
//    self.blackAndWhiteVideoEffect = [[NSUserDefaults standardUserDefaults] boolForKey:BlackAndWhiteKey];
//    self.recordVideoLocally = [[NSUserDefaults standardUserDefaults] boolForKey:RecordVideoLocallyKey];
    
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

-(void)goLive{
    self.blackAndWhiteVideoEffect = [[NSUserDefaults standardUserDefaults] boolForKey:BlackAndWhiteKey];
    self.recordVideoLocally = [[NSUserDefaults standardUserDefaults] boolForKey:RecordVideoLocallyKey];
    self.broadcastStartTime = kCMTimeInvalid;
    self.timeLabel.hidden = YES;
    self.receivedGoCoderEventCodes = [NSMutableArray new];
    [WowzaGoCoder setLogLevel:WowzaGoCoderLogLevelVerbose];
    // Load or initialization the streaming configuration settings
    NSData *savedConfig = [[NSUserDefaults standardUserDefaults] objectForKey:SDKSampleSavedConfigKey];
    if (savedConfig) {
        self.goCoderConfig = [NSKeyedUnarchiver unarchiveObjectWithData:savedConfig];
    }
    else {
        self.goCoderConfig = [WowzaConfig new];
    }
    
    
    NSLog (@"WowzaGoCoderSDK version =\n major:%lu\n minor:%lu\n revision:%lu\n build:%lu\n short string: %@\n verbose string: %@",
           (unsigned long)[WZVersionInfo majorVersion],
           (unsigned long)[WZVersionInfo minorVersion],
           (unsigned long)[WZVersionInfo revision],
           (unsigned long)[WZVersionInfo buildNumber],
           [WZVersionInfo string],
           [WZVersionInfo verboseString]);
    
    NSLog (@"%@", [WZPlatformInfo string]);
    
    self.goCoder = nil;
    
    // Register the GoCoder SDK license key
    NSError *goCoderLicensingError = [WowzaGoCoder registerLicenseKey:SDKSampleAppLicenseKey];
    if (goCoderLicensingError != nil) {
        // Handle license key registration failure
        [self showAlertWithTitle:@"GoCoder SDK Licensing Error" error:goCoderLicensingError];
    }
    else {
        // Initialize the GoCoder SDK
        self.goCoder = [WowzaGoCoder sharedInstance];
        
        // Specify the view in which to display the camera preview
        if (self.goCoder != nil) {
            
            // Request camera and microphone permissions
            [WowzaGoCoder requestPermissionForType:WowzaGoCoderPermissionTypeCamera response:^(WowzaGoCoderCapturePermission permission) {
                NSLog(@"Camera permission is: %@", permission == WowzaGoCoderCapturePermissionAuthorized ? @"authorized" : @"denied");
            }];
            
            [WowzaGoCoder requestPermissionForType:WowzaGoCoderPermissionTypeMicrophone response:^(WowzaGoCoderCapturePermission permission) {
                NSLog(@"Microphone permission is: %@", permission == WowzaGoCoderCapturePermissionAuthorized ? @"authorized" : @"denied");
            }];
            
            [self.goCoder registerVideoSink:self];
            [self.goCoder registerAudioSink:self];
            [self.goCoder registerVideoEncoderSink:self];
            [self.goCoder registerAudioEncoderSink:self];
            
            self.goCoder.config = self.goCoderConfig;
            self.goCoder.cameraView = self.recorderPreview;
            
            // Start the camera preview
            self.goCoderCameraPreview = self.goCoder.cameraPreview;
            [self.goCoderCameraPreview startPreview];
        }
        
        // Update the UI controls
        [self updateUIControls];
    }
}

-(void)prepareGeoCoder{
    
    [WowzaGoCoder setLogLevel:WowzaGoCoderLogLevelDefault];
    
    // Load or initialization the streaming configuration settings
    NSData *savedConfig = [[NSUserDefaults standardUserDefaults] objectForKey:SDKSampleSavedConfigKey];
    if (savedConfig) {
        self.goCoderConfig = [NSKeyedUnarchiver unarchiveObjectWithData:savedConfig];
    }
    else {
        self.goCoderConfig = [WowzaConfig new];
    }
    
    
    NSLog (@"WowzaGoCoderSDK version =\n major:%lu\n minor:%lu\n revision:%lu\n build:%lu\n short string: %@\n verbose string: %@",
           (unsigned long)[WZVersionInfo majorVersion],
           (unsigned long)[WZVersionInfo minorVersion],
           (unsigned long)[WZVersionInfo revision],
           (unsigned long)[WZVersionInfo buildNumber],
           [WZVersionInfo string],
           [WZVersionInfo verboseString]);
    
    NSLog (@"%@", [WZPlatformInfo string]);
    
    self.goCoder = nil;
    
    // Register the GoCoder SDK license key
    NSError *goCoderLicensingError = [WowzaGoCoder registerLicenseKey:SDKSampleAppLicenseKey];
    if (goCoderLicensingError != nil) {
        // Handle license key registration failure
        
        NSLog(@"GoCoder SDK Licensing Error");
//        [CameraPreviewController showAlertWithTitle:@"GoCoder SDK Licensing Error" error:goCoderLicensingError presenter:self];
    }
    else {
        // Initialize the GoCoder SDK
        self.goCoder = [WowzaGoCoder sharedInstance];
        
        // Specify the view in which to display the camera preview
        if (self.goCoder != nil) {
            
            // Request camera and microphone permissions
            [WowzaGoCoder requestPermissionForType:WowzaGoCoderPermissionTypeCamera response:^(WowzaGoCoderCapturePermission permission) {
                NSLog(@"Camera permission is: %@", permission == WowzaGoCoderCapturePermissionAuthorized ? @"authorized" : @"denied");
            }];
            
            [WowzaGoCoder requestPermissionForType:WowzaGoCoderPermissionTypeMicrophone response:^(WowzaGoCoderCapturePermission permission) {
                NSLog(@"Microphone permission is: %@", permission == WowzaGoCoderCapturePermissionAuthorized ? @"authorized" : @"denied");
            }];
            
            [self.goCoder registerVideoSink:self];
            [self.goCoder registerAudioSink:self];
            [self.goCoder registerVideoEncoderSink:self];
            [self.goCoder registerAudioEncoderSink:self];
            
          //  [self.goCoder registerDataSink:self eventName:@"onTextData"];
            
            self.goCoder.config = self.goCoderConfig;
            self.goCoder.cameraView = recorderPreview;
            
            // Start the camera preview
            self.goCoderCameraPreview = self.goCoder.cameraPreview;
            [self.goCoderCameraPreview startPreview];
        }
        
        // Update the UI controls
        [self updateUIControls];
    }
    
}

-(void)terminateKeyboard:(UIGestureRecognizer *)gesture{
    [sendMsgTxt resignFirstResponder];
    if (sendMsgTxt.text.length == 0) {
        sendMsgTxt.text = @"Write Comment Here ...";
        sendMsgTxt.textColor = [UIColor darkGrayColor];
    }
    
    [UIView transitionWithView:commentsendHolder duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = commentsendHolder.frame;
        frame.origin.y = self.view.frame.size.height-commentsendHolder.frame.size.height;
        commentsendHolder.frame = frame;
    } completion:nil];
    [gHideKeyboard setHidden:YES];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (startLiveBtn.tag == 0) {
        return NO;
    }
    [gHideKeyboard setHidden:NO];
    if([textView.text isEqualToString:@"Write Comment Here ..."]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [UIView transitionWithView:commentsendHolder duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = commentsendHolder.frame;
        frame.origin.y = self.view.frame.size.height-216-commentsendHolder.frame.size.height;
        commentsendHolder.frame = frame;
    } completion:nil];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView transitionWithView:commentsendHolder duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = commentsendHolder.frame;
        frame.origin.y = self.view.frame.size.height-commentsendHolder.frame.size.height;
        commentsendHolder.frame = frame;
    } completion:nil];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(text.length>0){
        if(textView.text.length>=55){
            return NO;
        }
    }
    NSString *completeMsg = @"";
    if(textView.text.length>0){
        if(text.length>0){
            completeMsg = [NSString stringWithFormat:@"%@%@",textView.text,text];
        }else{
            completeMsg = [textView.text substringToIndex:textView.text.length-1];
        }
    }else{
        if(text.length>0){
            completeMsg = text;
        }
    }
    
    if(completeMsg.length>0){
        int height = [self returnSizeofLabel:completeMsg width:sendMsgTxt.frame.size.width];
        if(height>100){
            height = 100;
        }else if(height<30){
            height = 30;
        }
        
        CGRect frame = commentsendHolder.frame;
        frame.size.height = height+17;
        frame.origin.y = self.view.frame.size.height-216-frame.size.height;
        commentsendHolder.frame = frame;
        
        CGRect rFrame = backRound.frame;
        rFrame.size.height = height+7;
        
        backRound.frame = rFrame;
        
        
        CGRect tFrame = sendMsgTxt.frame;
        tFrame.size.height = height;
        sendMsgTxt.frame = tFrame;
    }else{
        int height = 30;
        
        CGRect frame = commentsendHolder.frame;
        frame.size.height = height+17;
        frame.origin.y = self.view.frame.size.height-216-frame.size.height;
        commentsendHolder.frame = frame;
        
        CGRect rFrame = backRound.frame;
        rFrame.size.height = height+7;
        
        backRound.frame = rFrame;
        
        CGRect tFrame = sendMsgTxt.frame;
        tFrame.size.height = height;
        sendMsgTxt.frame = tFrame;
    }
    return YES;
}

-(int)returnSizeofLabel:(NSString *)str width:(int)width{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    UIFont *labelFont = [UIFont fontWithName:@"Raleway-Regular" size:19];
    CGRect expectedLabelRect = [str boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: labelFont} context:nil];
    return expectedLabelRect.size.height;
}

-(int)returnSizeofCellLabel:(NSString *)str width:(int)width{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:19];
    CGRect expectedLabelRect = [str boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: labelFont} context:nil];
    return expectedLabelRect.size.height;
}

- (UIImage *)captureView {
    
    UIGraphicsBeginImageContextWithOptions(recorderPreview.bounds.size, NO, 1);
    [recorderPreview drawViewHierarchyInRect:recorderPreview.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(NSString *)randomString{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 9];
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    for (int i=0; i<9; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    return (NSString *)randomString;
}

//-(void)setupStream{
//    AXStreamInfo *streamInfo = [AXStreamInfo streamInfo];
//    streamInfo.useSecureConnection = NO;
//    streamInfo.serverAddress = @"rtmp.streamaxia.com";
//    streamInfo.applicationName = @"streamaxia";
//
//    streamname = [self randomString];
//    urlLbl.text = [NSString stringWithFormat:@"http://play.streamaxia.com/%@", streamname];
//
//    streamInfo.streamName = streamname;
//    streamInfo.username = @"";
//    streamInfo.password = @"";
//
//    AXRecorderSettings *settings = [AXRecorderSettings recorderSettings];
//    settings.videoOrientation = AXVideoOrientationPortrait;
//    settings.videoFrameResolution = AXVideoFrameResolutionStandard720p;
//    settings.videoBitrate = [[AXUtils utils] bitrateForResolution:settings.videoFrameResolution];
//    settings.keyFrameInterval = 0.5 * settings.frameRate;
//    // settings.videoFrameResolution = AXVideoFrameResolutionCustom;
//    [settings useCustomVideoFrameSize: AXVideoFrameSizeMake(self.view.frame.size.width, self.view.frame.size.width)];
//
//    AXRecorder *recorder = [AXRecorder recorderWithStreamInfo:streamInfo settings:settings];
//    recorder.recorderDelegate = self;
//    [recorder setupWithView:recorderPreview];
//    [recorder prepareToRecord];
//
//    recorderr = recorder;
//
//    AXError *error;
//
//    [recorder activateFeatureAdaptiveBitRateWithError:&error];
//    if(error){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Oops! Failed to initialize the stream, try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
//    }else{
//    }
//}

//-(void)recorder:(AXRecorder *)recorder didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromCaptureOutput:(AVCaptureOutput *)captureOutput{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (startLiveBtn.tag == 1) {
//            if (!isfetched) {
//                UIImage *sampleImg = [self imageFromSampleBuffer:sampleBuffer];
//                if (sampleImg) {
//                    // tempPre.image = sampleImg;
//                    [self PostLiveStream:sampleImg];
//                    isfetched = YES;
//                }
//            }
//        }
//    });
//}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (!imageBuffer) return nil;
    
    CIImage *ciimage = [CIImage imageWithCVImageBuffer:imageBuffer];
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:ciimage fromRect:ciimage.extent];
    UIImage *thumbImg = [UIImage imageWithCGImage:cgImage];
    
    return thumbImg;
    /*
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    NSLog(@"w: %zu h: %zu bytesPerRow:%zu", width, height, bytesPerRow);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress,
                                                 width,
                                                 height,
                                                 8,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little
                                                 | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage
                                         scale:1.0f
                                   orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);*/
}


-(IBAction)buttonPressed:(id)sender{
    if(sender==startLiveBtn){
        if(startLiveBtn.tag==0){
            
            startLiveBtn.tag=1;
            startLiveBtn.backgroundColor = [UIColor redColor];
            liveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(liveLblTimer) userInfo:nil repeats:YES];
            
            [self goLive];

//            [recorderr startStreamingWithCompletion:^(BOOL success, AXError *error) {
//
//                if (success) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSLog(@"*** DEMO *** The stream started with success: %@", success ? @"YES" : @"NO");
//                        [viewersCountLbl setHidden:NO];
//                        [commentsBtn setHidden:NO];
//                        [startLiveBtn setHidden:YES];
//
//                        /*NSURL *sourceURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://rtmp.streamaxia.com:1935/streamaxia/%@/playlist.m3u8", streamname]];
//                        NSLog(@"streaming url: %@", sourceURL);
//                        AVURLAsset *asset = [AVURLAsset assetWithURL:sourceURL];
//                        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//                        CMTime time = CMTimeMake(1, 1);
//                        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
//                        UIImage *thumbImg = [UIImage imageWithCGImage:imageRef];
//                        CGImageRelease(imageRef);
//                        */
//                        /*
//                        UIGraphicsBeginImageContextWithOptions(recorderPreview.bounds.size, recorderPreview.opaque, 0.0);
//                        [recorderPreview.layer renderInContext:UIGraphicsGetCurrentContext()];
//                        UIImage * thumbImg = UIGraphicsGetImageFromCurrentImageContext();
//                        UIGraphicsEndImageContext();
//                        */
//                        // UIImage * thumbImg = [self captureView];
//
//                        // [self PostLiveStream:thumbImg];
//                    });
//                } else {
//                    NSLog(@"*** DEMO *** Error: %@", error);
//                }
//            }];
        }else{
            startLiveBtn.backgroundColor = basicColor;
            startLiveBtn.tag=0;
            [liveTimer invalidate];
            liveTimer = nil;
            [liveLbl setHidden:YES];
//            [recorderr stopStreaming];
            [commentsBtn setHidden:NO];
            [self delLiveStream];
        }
    }else if(sender==cancelLivebtn){
        if(startLiveBtn.tag==1){
            startLiveBtn.backgroundColor = basicColor;
            startLiveBtn.tag=0;
            [liveTimer invalidate];
            liveTimer = nil;
            [liveLbl setHidden:YES];
//            [recorderr stopStreaming];
            
            [self.goCoder unregisterVideoSink:self];
            [self.goCoder unregisterAudioSink:self];
            [self.goCoder unregisterVideoEncoderSink:self];
            [self.goCoder unregisterAudioEncoderSink:self];
            
          //  [self.goCoder unregisterDataSink:self eventName:@"onTextData"];

            
            [self.goCoderCameraPreview stopPreview];

            
            [commentsBtn setHidden:NO];
            [self delLiveStream];
        } else {
            [liveTimer invalidate];
            liveTimer = nil;
            
            [self.goCoder unregisterVideoSink:self];
            [self.goCoder unregisterAudioSink:self];
            [self.goCoder unregisterVideoEncoderSink:self];
            [self.goCoder unregisterAudioEncoderSink:self];
       //     [self.goCoder unregisterDataSink:self eventName:@"onTextData"];

            
            [self.goCoderCameraPreview stopPreview];
            UIStoryboard *story = self.storyboard;
            UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
            __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            app.window.rootViewController = view;
        }
    }else if(sender==commentsBtn){
        [UIView transitionWithView:recorderPreview duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = recorderPreview.frame;
            frame.origin.x = self.view.frame.size.width-(self.view.frame.size.width/3);
            frame.origin.y = 0;
            frame.size.height = self.view.frame.size.height/3;
            frame.size.width = self.view.frame.size.width/3;
            recorderPreview.frame =frame;
            [startLiveBtn setHidden:YES];
            [urlLbl setHidden:YES];
            [commentsBtn setHidden:YES];
            CGRect fra = commentsHolder.frame;
            fra.size.height = self.view.frame.size.height;
            fra.size.width = self.view.frame.size.width;
            commentsHolder.frame = fra;
        } completion:nil];
        
    }else if(sender==sendMsgBtn){
        if(startLiveBtn.tag==0){
            return;
        }
        if(sendMsgTxt.text.length==0){
            return;
        }
        [sendCommentIcon setHidden:YES];
        [sendMsgIndicator setHidden:NO];
        [self.view setUserInteractionEnabled:NO];
        [self postCommentAPI];
        
    }else if(sender==switchCBtn){
        @try{
            if(switchCBtn.tag==0){
//                [recorderr switchToCamera:AXCameraFront withCompletion:^(BOOL success, AXError *error){
//                    if(!error){
//                        switchCBtn.tag=1;
//                    }
//                }];
            }else{
//                [recorderr switchToCamera:AXCameraBack withCompletion:^(BOOL success, AXError *error){
//                    if(!error){
//                        switchCBtn.tag=0;
//                    }
//                }];
            }
            
        }@catch(NSException *r){}
    }else if(sender==gHideKeyboard){
        [sendMsgTxt resignFirstResponder];
        if(sendMsgTxt.text.length==0){
            sendMsgTxt.text = @"Write Comment Here ...";
            sendMsgTxt.textColor = [UIColor darkGrayColor];
        }
        [UIView transitionWithView:commentsendHolder duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = commentsendHolder.frame;
            frame.origin.y = self.view.frame.size.height-commentsendHolder.frame.size.height;
            commentsendHolder.frame = frame;
        } completion:nil];
        [gHideKeyboard setHidden:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UIImageView *imgPic = (UIImageView *)[cell viewWithTag:100];
    UILabel *uName = (UILabel *)[cell viewWithTag:101];
    UILabel *comment  = (UILabel *)[cell viewWithTag:102];
    
    NSDictionary *commentInfo = commentsArr[indexPath.row];
    
    NSURL *imageUrl = [NSURL URLWithString:commentInfo[@"user_pic"]];
    [imgPic setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defpic.png"]];
    
    int height = [self returnSizeofCellLabel:commentInfo[@"comment_txt"] width:self.view.frame.size.width-73];
    if(height<30){
        height = 30;
    }
    
    CGRect commFrame = comment.frame;
    commFrame.size.height = height;
    comment.frame = commFrame;
    
    imgPic.layer.cornerRadius = imgPic.frame.size.height/2;
    imgPic.layer.masksToBounds = YES;
    [uName setText:commentInfo[@"user_name"]];
    [comment setText:commentInfo[@"comment_txt"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int height = [self returnSizeofCellLabel:commentsArr[indexPath.row][@"comment_txt"] width:self.view.frame.size.width-73];
    if(height<30){
        height = 30;
        return 72;
    }else{
        return 31+height+11;
    }
}

-(void)reloadTable{
    [self.view setUserInteractionEnabled:YES];
    
    [viewersCountLbl setText:[NSString stringWithFormat:@"Viewer(s): %@",viewer]];
    if([sendCommentIcon isHidden]){
        [sendCommentIcon setHidden:NO];
        [sendMsgIndicator setHidden:YES];
        sendMsgTxt.text = @"";
        [self buttonPressed:gHideKeyboard];
    }
    [commentTbl reloadData];
    if(commentsArr.count>0){
        [nocommentsLbl setHidden:YES];
    }else{
        [nocommentsLbl setHidden:NO];
    }
    //    [commentTbl setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}

-(void)fetchcommentsAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:@"get_comments.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"b_id=%@",[liveSData objectForKey:@"live_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                commentsArr = [result objectForKey:@"data"];
                viewer = [result objectForKey:@"viewerCount"];
                [self reloadTable];
            }else{
                viewer = [result objectForKey:@"viewerCount"];
                [self reloadTable];
            }
        }else{
            
        }
    }];
}

-(void)refetchComment{
    [self fetchcommentsAPI];
}

-(void)resetTxtView{
    int height = 30;
    
    CGRect frame = commentsendHolder.frame;
    frame.size.height = height+17;
    frame.origin.y = self.view.frame.size.height-216-frame.size.height;
    commentsendHolder.frame = frame;
    
    CGRect rFrame = backRound.frame;
    rFrame.size.height = height+7;
    
    backRound.frame = rFrame;
    
    CGRect tFrame = sendMsgTxt.frame;
    tFrame.size.height = height;
    sendMsgTxt.frame = tFrame;
}

-(void)postCommentAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"post_comment.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"broadcast_id=%@&comment_by=%@&comment_txt=%@",[liveSData objectForKey:@"live_id"],[app.userData objectForKey:@"user_id"],sendMsgTxt.text] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self resetTxtView];
                [self fetchcommentsAPI];
                
            }else{
                [self failed:@"Oops! Something went wrong, please send your comment again."];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please send your comment again."];
        }
    }];
}

-(void)failed:(NSString *)str{
    [sendCommentIcon setHidden:NO];
    [sendMsgIndicator setHidden:YES];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(void)resetPreview:(UIGestureRecognizer *)gesture{
    [UIView transitionWithView:recorderPreview duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = recorderPreview.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.height = self.view.frame.size.height;
        frame.size.width = self.view.frame.size.width;
        recorderPreview.frame = frame;
        [startLiveBtn setHidden:NO];
        [self.view endEditing:YES];
        [urlLbl setHidden:NO];
        [commentsBtn setHidden:NO];
        CGRect fra = commentsHolder.frame;
        fra.size.height = 0;
        fra.size.width = self.view.frame.size.width;
        commentsHolder.frame = fra;
    } completion:nil];
}

-(void)closedFeed{
    UIStoryboard *story = self.storyboard;
    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    app.window.rootViewController = view;
}

-(void)delLiveStream{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"delLive.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"streamid=%@",[liveSData objectForKey:@"live_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                app.isLiveCurrently = NO;
                [self closedFeed];
            }else{
                [self failedLive];
            }
        }else{
            
        }
    }];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if(app.isLiveCurrently){
        [app callDelete:[liveSData objectForKey:@"live_id"]];
    }
    [commentfetchtimer invalidate];
    commentfetchtimer = nil;
    
//    if (recorderr.isActive) {
//        [recorderr stopStreaming];
//    }
}

-(void)PostLiveStream:(UIImage *)img{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"addLivePost.php" forKey:@"API"];
    NSData *data = UIImagePNGRepresentation(img);
    NSString *base64 = [data base64EncodedStringWithOptions:0];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [dict setObject:[NSString stringWithFormat:@"streamname=%@&streamtitle=%@&streamcost=%@&user_id=%@&live_thumb=%@",streamname,liveTitle,liveCost,[app.userData objectForKey:@"user_id"],base64] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self setupTimer];
                app.isLiveCurrently = YES;
                liveSData = [result objectForKey:@"data"];
                [self fetchcommentsAPI];
            }else{
                [self failedLive];
            }
        }else{
            
        }
    }];
}

-(void)setupTimer{
    [commentfetchtimer  invalidate];
    commentfetchtimer = nil;
    commentfetchtimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refetchComment) userInfo:nil repeats:YES];
}

-(void)failedLive{
    [self buttonPressed:startLiveBtn];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Oops! Something went wrong, try again. If problem persists, contact us." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
    
}

-(void)liveLblTimer{
    
    if(liveLbl.isHidden){
        [liveLbl setHidden:NO];
    }else{
        [liveLbl setHidden:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WZStatusCallback Protocol Instance Methods

- (void) onWZStatus:(WZStatus *) goCoderStatus {
    // A successful status transition has been reported by the GoCoder SDK
    
    switch (goCoderStatus.state) {
            
        case WZStateIdle:
            self.timeLabel.hidden = YES;
            if (self.writeMP4 && self.mp4Writer.writing) {
                if (self.video_capture_queue) {
                    dispatch_async(self.video_capture_queue, ^{
                        [self.mp4Writer stopWriting];
                    });
                }
                else {
                    [self.mp4Writer stopWriting];
                }
            }
            self.writeMP4 = NO;
            break;
            
        case WZStateStarting:
            // A streaming broadcast session is starting up
            self.broadcastStartTime = kCMTimeInvalid;
            self.timeLabel.text = @"00:00";
            self.broadcastFrameCount = 0;
            break;
            
        case WZStateRunning:
            // A streaming broadcast session is running
            self.timeLabel.hidden = NO;
            self.writeMP4 = NO;
            if (self.recordVideoLocally) {
                self.mp4Writer = [MP4Writer new];
                self.writeMP4 = [self.mp4Writer prepareWithConfig:self.goCoderConfig];
                if (self.writeMP4) {
                    [self.mp4Writer startWriting];
                }
            }
            break;
            
        case WZStateStopping:
            // A streaming broadcast session is shutting down
            break;
            
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.goCoder.status.state == WZStateIdle || self.goCoder.status.state == WZStateRunning) {
            [self.broadcastButton setImage:[UIImage imageNamed:(_goCoder.status.state == WZStateIdle) ? @"start_button" : @"stop_button"] forState:UIControlStateNormal];
        }
        
        [self updateUIControls];
    });
}

- (void) onWZEvent:(WZStatus *) goCoderStatus {
    // If an event is reported by the GoCoder SDK, display an alert dialog describing the event,
    // but only if we haven't already shown an alert for this event
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BOOL haveSeenAlertForEvent = NO;
        [self.receivedGoCoderEventCodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([((NSNumber *)obj) isEqualToNumber:[NSNumber numberWithInteger:goCoderStatus.error.code]]) {
                haveSeenAlertForEvent = YES;
                *stop = YES;
            }
        }];
        if (!haveSeenAlertForEvent) {
            [self showAlertWithTitle:@"Live Streaming Event" status:goCoderStatus];
            [self.receivedGoCoderEventCodes addObject:[NSNumber numberWithInteger:goCoderStatus.error.code]];
        }
        
        [self updateUIControls];
    });
}

- (void) onWZError:(WZStatus *) goCoderStatus {
    // If an error is reported by the GoCoder SDK, display an alert dialog containing the error details
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertWithTitle:@"Live Streaming Error" status:goCoderStatus];
        
        [self updateUIControls];
    });
}

#pragma mark - WZVideoSink

#warning Don't implement this protocol unless your application makes use of it
- (void) videoFrameWasCaptured:(nonnull CVImageBufferRef)imageBuffer framePresentationTime:(CMTime)framePresentationTime frameDuration:(CMTime)frameDuration {
    if (self.goCoder.isStreaming) {
        
        if (self.blackAndWhiteVideoEffect) {
            // convert frame to b/w using CoreImage tonal filter
            CIImage *frameImage = [[CIImage alloc] initWithCVImageBuffer:imageBuffer];
            CIFilter *grayFilter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
            [grayFilter setValue:frameImage forKeyPath:@"inputImage"];
            frameImage = [grayFilter outputImage];
            
            CIContext * context = [CIContext contextWithOptions:nil];
            [context render:frameImage toCVPixelBuffer:imageBuffer];
        }
        
    }
}

- (void) videoCaptureInterruptionStarted {
    if (!self.goCoderConfig.backgroundBroadcastEnabled) {
        [self.goCoder endStreaming:self];
    }
}

- (void) videoCaptureUsingQueue:(nullable dispatch_queue_t)queue {
    self.video_capture_queue = queue;
}

#pragma mark - WZAudioSink

#warning Don't implement this protocol unless your application makes use of it
- (void) audioLevelDidChange:(float)level {
    //    NSLog(@"%@ %0.2f", @"Audio level did change", level);
}

#warning Don't implement this protocol unless your application makes use of it
- (void) audioPCMFrameWasCaptured:(nonnull const AudioStreamBasicDescription *)pcmASBD bufferList:(nonnull const AudioBufferList *)bufferList time:(CMTime)time sampleRate:(Float64)sampleRate {
    // The commented-out code below simply dampens the amplitude of the audio data.
    // It is intended as an example of how one would access and modify the audio sample data.
    
    //    int16_t *fdata = bufferList->mBuffers[0].mData;
    //
    //    for (int i = 0; i < bufferList->mBuffers[0].mDataByteSize/sizeof(*fdata); i++) {
    //        *fdata = (int16_t)(*fdata * 0.1);
    //        fdata++;
    //    }
}


#pragma mark - WZAudioEncoderSink

#warning Don't implement this protocol unless your application makes use of it
- (void) audioSampleWasEncoded:(nullable CMSampleBufferRef)data {
    if (self.writeMP4) {
        [self.mp4Writer appendAudioSample:data];
    }
}


#pragma mark - WZVideoEncoderSink

#warning Don't implement this protocol unless your application makes use of it
- (void) videoFrameWasEncoded:(nonnull CMSampleBufferRef)data {
    
    // update the broadcast time label
    if (CMTimeCompare(self.broadcastStartTime, kCMTimeInvalid) == 0) {
        self.broadcastStartTime = CMSampleBufferGetPresentationTimeStamp(data);
    }
    else {
        CMTime diff = CMTimeSubtract(CMSampleBufferGetPresentationTimeStamp(data), self.broadcastStartTime);
        Float64 seconds = CMTimeGetSeconds(diff);
        NSInteger duration = (NSInteger)seconds;
        
        NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld", (duration / 60), (duration % 60)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeLabel.text = timeString;
        });
        
    }
    
    if (self.writeMP4) {
        [self.mp4Writer appendVideoSample:data];
    }
    
    if (self.broadcastFrameCount++ % 60 == 0) {
        NSString *string = [NSString stringWithFormat:@"My string data at frame %lld", self.broadcastFrameCount];
        WZDataItem *myStringData = [WZDataItem itemWithString:string];
        WZDataMap *dataMap = [WZDataMap new];
        [dataMap setItem:myStringData forKey:@"my_string"];
        
        NSLog(@"%@", string);
        
        WZDataEvent *event = [[WZDataEvent alloc] initWithName:@"dataEvent" params:dataMap];
        
        [self.goCoder sendDataEvent:event];
    }
}

#pragma mark -

- (void) showAlertWithTitle:(NSString *)title status:(WZStatus *)status {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:title
                                                          message:status.description
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [alertDialog show];
}

- (void) showAlertWithTitle:(NSString *)title error:(NSError *)error {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:title
                                                          message:error.localizedDescription
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [alertDialog show];
}


#pragma mark - Instance Methods

// Update the state of the UI controls
- (void) updateUIControls {
    if (self.goCoder.status.state != WZStateIdle && self.goCoder.status.state != WZStateRunning) {
        // If a streaming broadcast session is in the process of starting up or shutting down,
        // disable the UI controls
        self.broadcastButton.enabled    = NO;
        self.torchButton.enabled        = NO;
        self.switchCameraButton.enabled = NO;
        self.settingsButton.enabled     = NO;
        self.micButton.hidden           = YES;
        self.micButton.enabled          = NO;
    } else {
        // Set the UI control state based on the streaming broadcast status, configuration,
        // and device capability
        self.broadcastButton.enabled    = YES;
        self.switchCameraButton.enabled = self.goCoderCameraPreview.cameras.count > 1;
        self.torchButton.enabled        = [self.goCoderCameraPreview.camera hasTorch];
        self.settingsButton.enabled     = !self.goCoder.isStreaming;
        // The mic icon should only be displayed while streaming and audio streaming has been enabled
        // in the GoCoder SDK configuration setiings
        self.micButton.enabled          = self.goCoder.isStreaming && self.goCoderConfig.audioEnabled;
        self.micButton.hidden           = !self.micButton.enabled;
    }
}

- (IBAction)settingBtnClicked:(id)sender {
    UIViewController *settingsNavigationController = [[UIStoryboard storyboardWithName:@"GoCoderSettings" bundle:nil] instantiateViewControllerWithIdentifier:@"settingsNavigationController"];
    
    SettingsViewController *settingsVC = (SettingsViewController *)(((UINavigationController *)settingsNavigationController).topViewController);
    [settingsVC addAllSections];
    
    SettingsViewModel *settingsModel = [[SettingsViewModel alloc] initWithSessionConfig:self.goCoderConfig];
    settingsModel.supportedPresetConfigs = self.goCoder.cameraPreview.camera.supportedPresetConfigs;
    settingsVC.viewModel = settingsModel;
    
    [self presentViewController:settingsNavigationController animated:YES completion:NULL];
}





@end

