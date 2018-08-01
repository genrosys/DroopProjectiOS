//
//  finaliseDual.m
//  Droop
//
//  Created by Himanshu Sharma on 23/10/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "finaliseDual.h"
#import "AppDelegate.h"
#import "Utils.h"
#import <UIImageView+AFNetworking.h>

@interface finaliseDual ()

@end

@implementation finaliseDual

@synthesize dualCancel,imgdual;
@synthesize dualScroller,bottomHolder,peersColl;//,followerColl;
@synthesize postDualConfBtn;
@synthesize postDualIndicator;
@synthesize finalImgSel;
@synthesize shutterHolderView;
@synthesize captionDTxt;
@synthesize dHideKeyboard;
@synthesize addCaptionHeader;
@synthesize dualHeaderLbl;
@synthesize switchButtond,switchicond,flashButtond,flashicond,photoLibraryicon,photolibrarybtn,dshutterBtn;
LLSimpleCamera *dCamera;
BOOL ispeersel;
int selFriend;
BOOL isshown;


NSMutableArray *peersArr, *pfollowersArr;
UIImage *cropImg;

ALAssetsLibrary *library;
NSArray *imageArray;
NSMutableArray *mutableArray;
static int count = 0;
int bhHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isshown = NO;
    selFriend = -1;
    ispeersel = NO;
    
    CGRect frame = imgdual.frame;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.width;
    imgdual.frame = frame;
    
    finalImgSel.frame = frame;
    
    CGRect shframe = shutterHolderView.frame;
    shframe.origin.y = frame.size.height-shutterHolderView.frame.size.height;
    shutterHolderView.frame = shframe;
    
    CGRect f = bottomHolder.frame;
    f.origin.y = self.view.frame.size.width;
    bottomHolder.frame = f;
    
    bhHeight = bottomHolder.frame.size.height;
    //****** INSTA STYLE CAMERA VIEW INITIALISATION AND SETTING UP UI
    
    
    
    dCamera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetPhoto  position:LLCameraPositionRear videoEnabled:NO];
    
    CGRect fframe =[imgdual bounds];
    dCamera.view.frame = fframe;
    [imgdual addSubview:dCamera.view];
    //    [dCamera attachToViewController:self withFrame:screenRect];
    [dCamera start];
    [dCamera updateFlashMode:LLCameraFlashOn];
    //********* ENDS HERE **********
    
    
    postDualConfBtn.layer.cornerRadius = postDualConfBtn.frame.size.height/2;
    postDualConfBtn.layer.masksToBounds = YES;

    dualScroller.contentSize = CGSizeMake(dualScroller.frame.size.width, bottomHolder.frame.origin.y+bottomHolder.frame.size.height);
    
    [self getFollowing];
    // Do any additional setup after loading the view.
}

-(IBAction)showGallery:(UIButton *)btn{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [picker setAllowsEditing:YES];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    cropImg = [info objectForKey:UIImagePickerControllerEditedImage];
    finalImgSel.image = cropImg;
    [finalImgSel setHidden:NO];
    [shutterHolderView setHidden:YES];
    [flashicond setHidden:YES];
    [flashButtond setHidden:YES];
    [switchicond setHidden:YES];
    [switchButtond setHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getAllPictures
{
    imageArray=[[NSArray alloc] init];
    mutableArray =[[NSMutableArray alloc]init];
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                
                [library assetForURL:url
                         resultBlock:^(ALAsset *asset) {
                             [mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                             
                             if ([mutableArray count]==count)
                             {
                                 imageArray=[[NSArray alloc] initWithArray:mutableArray];
                                 [self allPhotosCollected:imageArray];
                             }
                         }
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
                
            }
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [assetGroups addObject:group];
            count=(int)[group numberOfAssets];
        }
    };
    
    assetGroups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
}

-(void)allPhotosCollected:(NSArray*)imgArray
{
    //write your code here after getting all the photos from library...
    NSLog(@"all pictures are %@", imgArray);
}

-(IBAction)switchButtonTapped:(UIButton *)btn{
    if (btn.tag==0) {
        btn.tag = 1;
        [dCamera stop];
        [dCamera.view removeFromSuperview];
        dCamera = nil;
        dCamera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetPhoto  position:LLCameraPositionFront videoEnabled:NO];
        CGRect fframe =[imgdual bounds];
        dCamera.view.frame = fframe;
        [imgdual addSubview:dCamera.view];
        
        [flashicond setHidden:YES];
        [flashButtond setHidden:YES];
        //    [dCamera attachToViewController:self withFrame:screenRect];
        [dCamera start];
    }else if(btn.tag==1){
        btn.tag = 0;
        [dCamera stop];
        [dCamera.view removeFromSuperview];
        dCamera = nil;
        dCamera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetPhoto  position:LLCameraPositionRear videoEnabled:NO];
        if(flashButtond.tag==0){
            [dCamera updateFlashMode:LLCameraFlashOn];
        }
        
        CGRect fframe =[imgdual bounds];
        dCamera.view.frame = fframe;
        [imgdual addSubview:dCamera.view];
        [flashicond setHidden:NO];
        [flashButtond setHidden:NO];
        //    [dCamera attachToViewController:self withFrame:screenRect];
        [dCamera start];
    }
}

-(IBAction)flashbuttontapped:(UIButton *)btn{
    if(btn.tag==0){
        
        BOOL done = [dCamera updateFlashMode:LLCameraFlashOff];
        if(done){
            btn.tag=1;
            [flashicond setImage:[UIImage imageNamed:@"cflashoff.png"]];
        }
    }else if(btn.tag==1){
        BOOL done = [dCamera updateFlashMode:LLCameraFlashOn];
        if(done){
            btn.tag=0;
            [flashicond setImage:[UIImage imageNamed:@"cflashon.png"]];
        }
    }
}

-(void)postDualAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSData *picData = UIImagePNGRepresentation([Utils imageWithImage:cropImg scaledToSize:CGSizeMake(375, 375)]);
    NSString *base64 = [picData base64EncodedStringWithOptions:0];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSMutableDictionary *linkedD ;
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    formatter.dateFormat = @"dd MMM, yyyy";
    NSString *dateDual = [formatter stringFromDate:[NSDate date]];
    formatter.dateFormat = @"hh:mm a";
    NSString *timeDual = [formatter stringFromDate:[NSDate date]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"post_dualPost.php" forKey:@"API"];
    NSString *strC = [captionDTxt.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if([captionDTxt.text containsString:@"Enter Caption Here"])
    {
        strC = @"";
    }

    if(selFriend!=-1){
        if(ispeersel){
            
            linkedD = [peersArr objectAtIndex:selFriend];
        }else{
            linkedD = [pfollowersArr objectAtIndex:selFriend];
        }
        [dict setObject:[NSString stringWithFormat:@"dual_pic=%@&user_id=%@&user_name=%@&user_pic=%@&dual_linked_to=%@&dual_linked_name=%@&dual_linked_propic=%@&dualP_title=%@&dual_date=%@&dual_time=%@", base64, [app.userData objectForKey:@"user_id"], [app.userData objectForKey:@"user_name"], [app.userData objectForKey:@"user_pic"], [linkedD objectForKey:@"user_id"], [linkedD objectForKey:@"user_name"], [linkedD objectForKey:@"user_pic"], @"Not Provided", dateDual, timeDual] forKey:@"requestBody"];
    }else{
        [dict setObject:[NSString stringWithFormat:@"dual_pic=%@&user_id=%@&user_name=%@&user_pic=%@&dualP_title=%@&dual_linked_to=%@&dual_linked_name=%@&dual_linked_propic=%@&dual_date=%@&dual_time=%@",base64,[app.userData objectForKey:@"user_id"],[app.userData objectForKey:@"user_name"],[app.userData objectForKey:@"user_pic"],strC,@"-1",@"NA",@"NA",dateDual,timeDual] forKey:@"requestBody"];
    }
    
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count > 0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                [self dualPostedSuccedd];
            }else{
                [self dualPostedFailed:@"Oops! Seems like something went wrong, please try again."];
            }
        }else{
            //Connection issue
            [self dualPostedFailed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(void)dualPostedSuccedd{
    [self buttonPressed:dualCancel];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Dual posted Successfully!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(void)dualPostedFailed:(NSString *)str{
    [self.view setUserInteractionEnabled:YES];
    [postDualIndicator setHidden:YES];
    [postDualConfBtn setTitle:@"Share" forState:UIControlStateNormal];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

-(void)getFollowing{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getFollowers.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];
    
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                pfollowersArr = [result objectForKey:@"followers"];
                peersArr = [result objectForKey:@"following"];
                [self reloadCollection];
            }
        }else{
            
        }
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if(collectionView==peersColl){
        UIImageView *proSImg = (UIImageView *)[cell viewWithTag:990];
        UIImageView *sTickIcon = (UIImageView *)[cell viewWithTag:101];
        
        [proSImg setImageWithURL:[NSURL URLWithString:peersArr[indexPath.row][@"user_pic"]]];
        sTickIcon.hidden = !(ispeersel && indexPath.row == selFriend);
    }else{
        UIImageView *proSImg = (UIImageView *)[cell viewWithTag:990];
        UIImageView *sTickIcon = (UIImageView *)[cell viewWithTag:101];
        
        [proSImg setImageWithURL:[NSURL URLWithString:pfollowersArr[indexPath.row][@"user_pic"]]];
        sTickIcon.hidden = !(!ispeersel && indexPath.row == selFriend);
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    return size;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView==peersColl){
        return peersArr.count;
    }else{
        return pfollowersArr.count;
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"Enter Caption Here ..."]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [dHideKeyboard setHidden:NO];
    CGRect frame = dualScroller.frame;
//    frame.size.height = self.view.frame.size.height-216;
    frame.origin.y =  frame.origin.y-216;
    dualScroller.frame = frame;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGRect frame = dualScroller.frame;
    frame.size.height = self.view.frame.size.height-216;
    dualScroller.frame = frame;
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(text.length>0){
        if(textView.text.length>=255){
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
        int height = [self returnSizeofLabel:completeMsg width:captionDTxt.frame.size.width];
        if(height>100){
            height = 100;
        }else if(height<30){
            height = 30;
        }
        if(height>30){
            CGRect bHF = bottomHolder.frame;
            bHF.size.height = bhHeight+height;
            bottomHolder.frame = bHF;
        }else{
            CGRect bHF = bottomHolder.frame;
            bHF.size.height = bhHeight;
            bottomHolder.frame = bHF;
        }
        CGRect tFrame = captionDTxt.frame;
        tFrame.size.height = height;
        captionDTxt.frame = tFrame;
    }else{
        int height = 30;
        if(height>30){
            CGRect bHF = bottomHolder.frame;
            bHF.size.height = bhHeight+height;
            bottomHolder.frame = bHF;
        }else{
            CGRect bHF = bottomHolder.frame;
            bHF.size.height = bhHeight;
            bottomHolder.frame = bHF;
        }
        CGRect tFrame = captionDTxt.frame;
        tFrame.size.height = height;
        captionDTxt.frame = tFrame;
    }
    
    dualScroller.contentSize = CGSizeMake(dualScroller.frame.size.width, bottomHolder.frame.origin.y+bottomHolder.frame.size.height+10);
    return YES;
}



-(int)returnSizeofLabel:(NSString *)str width:(int)width{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    // CGSize expectedLabelSize = [str sizeWithFont:[UIFont fontWithName:@"Raleway-Medium" size:17] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    UIFont *labelFont = [UIFont fontWithName:@"Raleway-Medium" size:17];
    CGRect expectedLabelRect = [str boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: labelFont} context:nil];
    return expectedLabelRect.size.height;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    CGRect frame = dualScroller.frame;
    frame.size.height = self.view.frame.size.height;
    dualScroller.frame = frame;
    return YES;
}
// hide caption lbn
-(void)reassignView{
    
    [captionDTxt setHidden:YES];
    [addCaptionHeader setHidden:YES];
    
    CGRect frame = bottomHolder.frame;
    frame.size.height = bottomHolder.frame.size.height - (dualHeaderLbl.frame.origin.y-10);
    bottomHolder.frame =frame;
    
    dualScroller.contentSize = CGSizeMake(dualScroller.frame.size.width, bottomHolder.frame.origin.y+bottomHolder.frame.size.height+10);
}
//show caption lbn
-(void)setupViewback{
    [captionDTxt setHidden:NO];
    [addCaptionHeader setHidden:NO];
    
    CGRect frame = bottomHolder.frame;
    frame.size.height = captionDTxt.frame.origin.y+captionDTxt.frame.size.height+20 + postDualConfBtn.frame.origin.y+postDualConfBtn.frame.size.height+100;
    bottomHolder.frame = frame;
    
    dualScroller.contentSize = CGSizeMake(dualScroller.frame.size.width, bottomHolder.frame.origin.y+bottomHolder.frame.size.height+10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView==peersColl){
        if(ispeersel){
            if(selFriend==(int)indexPath.row){
                selFriend = -1;
                [self setupViewback];
            }else{
                ispeersel = YES;
                selFriend = (int)indexPath.row;
                [self reassignView];
            }
        }else{
            ispeersel = YES;
            selFriend = (int)indexPath.row;
            [self reassignView];
            
        }
    }else{
        if(!ispeersel){
            if(selFriend==(int)indexPath.row){
                selFriend=-1;
                
            }else{
                ispeersel = NO;
                selFriend = (int)indexPath.row;
                [self reassignView];
            }
        }else{
            ispeersel = NO;
            selFriend = (int)indexPath.row;
            [self reassignView];
        }
    }
    [peersColl reloadData];
  //  [followerColl reloadData];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)reloadCollection{
    [peersColl reloadData];
  //  [followerColl reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    if(!isshown){
    //    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //
    //    UIImage *image = app.croppedImage;
    //    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    //    imageCropVC.cropMode = RSKImageCropModeSquare;
    //    imageCropVC.delegate = self;
    //    [self presentViewController:imageCropVC animated:NO completion:nil];
    //        isshown = YES;
    //    }
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle {
    cropImg = croppedImage;
    //    imgdual.image = cropImg;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller{
    [self buttonPressed:dualCancel];
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==dualCancel){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.window.rootViewController = view;
    }else if(sender==postDualConfBtn){
        /*NSString *msg = @"";
        if(selFriend==-1){
            if(captionDTxt.text.length==0 || [captionDTxt.text isEqualToString:@"Enter Caption Here ..."]){
                msg = @"Oops! Please enter a caption for your Dual, tell us what its about.";
            }
        }
        if(msg.length>0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            return;
        }*/
        [self.view endEditing:YES];
        CGRect frame = dualScroller.frame;
        frame.size.height = self.view.frame.size.height;
        dualScroller.frame = frame;
        [self.view setUserInteractionEnabled:NO];
        [postDualIndicator setHidden:NO];
        [postDualConfBtn setTitle:@"" forState:UIControlStateNormal];
        [self postDualAPI];
    }else if(sender==dshutterBtn){
        [dCamera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
            if(!error) {
                cropImg = image;
                finalImgSel.image = image;
                [finalImgSel setHidden:NO];
                [shutterHolderView setHidden:YES];
                [flashicond setHidden:YES];
                [flashButtond setHidden:YES];
                [switchicond setHidden:YES];
                [switchButtond setHidden:YES];
            }
            else {
                NSLog(@"An error has occured: %@", error);
            }
        } exactSeenImage:YES];
    }else if(sender==dHideKeyboard){
        [dHideKeyboard setHidden:YES];
        if(captionDTxt.text.length==0){
            captionDTxt.text = @"Enter Caption Here ...";
            captionDTxt.textColor = [UIColor darkGrayColor];
        }
        [captionDTxt resignFirstResponder];
        CGRect frame = dualScroller.frame;
        //frame.size.height = self.view.frame.size.height;
        frame.origin.y = 0;
        dualScroller.frame = frame;
    }
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
