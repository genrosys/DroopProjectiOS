//
//  addpostSetup.m
//  Droop
//
//  Created by apple on 12/09/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "addpostSetup.h"
#import "AppDelegate.h"
@interface addpostSetup ()

@end

@implementation addpostSetup
@synthesize selectPostTypeV,selectPostTypePop,selectPostTypeDone,typeLiveSell,typeDualPost,typeAdVenture;
@synthesize liveCheck,dualPostCheck,adVentureCheck;
@synthesize liveSetTitleV,liveSetTitlePop,liveSetTitleDone,liveSetTitleTxt;
@synthesize liveSetPriceV,liveSetPricePop,liveSetPriceTxt,liveSetPriceDone;
@synthesize freeSwitchLive;
@synthesize addpostSetupBack;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectPostTypeDone.layer.cornerRadius = selectPostTypeDone.frame.size.height/2;
    selectPostTypeDone.layer.masksToBounds = YES;
    
    selectPostTypePop.layer.cornerRadius = 10;
    selectPostTypePop.layer.masksToBounds = YES;
    
    liveSetTitlePop.layer.cornerRadius = 10;
    liveSetTitlePop.layer.masksToBounds = YES;
    
    liveSetTitleDone.layer.cornerRadius = liveSetTitleDone.frame.size.height/2;
    liveSetTitleDone.layer.masksToBounds = YES;
    
    liveSetPricePop.layer.cornerRadius = 10;
    liveSetPricePop.layer.masksToBounds = YES;
    
    liveSetPriceDone.layer.cornerRadius = liveSetPriceDone.frame.size.height/2;
    liveSetPriceDone.layer.masksToBounds = YES;
    [self buttonPressed:selectPostTypeDone];
    
    NSMutableAttributedString *pAttr = [[NSMutableAttributedString alloc]initWithString:liveSetPriceTxt.placeholder];
    [pAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, liveSetPriceTxt.placeholder.length)];
    liveSetPriceTxt.attributedPlaceholder = pAttr;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:liveSetTitleTxt.placeholder];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, liveSetTitleTxt.placeholder.length)];
    liveSetTitleTxt.attributedPlaceholder = attr;
    
    CGRect frame = liveSetTitleV.frame;
    frame.origin.x = self.view.frame.size.width;
    frame.size.width = self.view.frame.size.width;
    liveSetTitleV.frame = frame;
    
    CGRect fr = liveSetPriceV.frame;
    fr.origin.x = self.view.frame.size.width;
    fr.size.width = self.view.frame.size.width;
    liveSetPriceV.frame =fr;
    
    UITapGestureRecognizer *hideKeyboardTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    hideKeyboardTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:hideKeyboardTap];
    
    // Do any additional setup after loading the view.
}

-(void)hideKeyboard:(UIGestureRecognizerState *)gesture{
    [self.view endEditing:YES];
}
-(IBAction)switchchanged:(UISwitch *)swit{
    if(swit.isOn){
        [liveSetPriceTxt setUserInteractionEnabled:NO];
        liveSetPriceTxt.text = @"";
        
    }else{
       [liveSetPriceTxt setUserInteractionEnabled:YES];
    }
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==typeDualPost){
        dualPostCheck.image = [UIImage imageNamed:@"checkdron.png"];
        liveCheck.image = [UIImage imageNamed:@"checkdroff.png"];
        adVentureCheck.image = [UIImage imageNamed:@"checkdroff.png"];
    }else if(sender==typeAdVenture){
        adVentureCheck.image = [UIImage imageNamed:@"checkdron.png"];
        liveCheck.image = [UIImage imageNamed:@"checkdroff.png"];
        dualPostCheck.image = [UIImage imageNamed:@"checkdroff.png"];
    }else if(sender==typeLiveSell){
        liveCheck.image = [UIImage imageNamed:@"checkdron.png"];
        adVentureCheck.image = [UIImage imageNamed:@"checkdroff.png"];
        dualPostCheck.image = [UIImage imageNamed:@"checkdroff.png"];
    }else if(sender==selectPostTypeDone){
        
        [UIView transitionWithView:selectPostTypeV duration:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frmae =selectPostTypeV.frame;
            frmae.origin.x = -selectPostTypeV.frame.size.width;
            selectPostTypeV.frame = frmae;
        }completion:^(BOOL finished){
            [UIView transitionWithView:liveSetTitleV duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                CGRect frame = liveSetTitleV.frame;
                frame.origin.x = 0;
                liveSetTitleV.frame = frame;
            }completion:^(BOOL finished){
                [liveSetTitleTxt becomeFirstResponder];
            }];
        }];
        
    }else if(sender==liveSetTitleDone){
        [UIView transitionWithView:liveSetTitleV duration:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frmae =liveSetTitleV.frame;
            frmae.origin.x = -liveSetTitleV.frame.size.width;
            liveSetTitleV.frame = frmae;
        }completion:^(BOOL finished){
            [UIView transitionWithView:liveSetPriceV duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                CGRect frame = liveSetPriceV.frame;
                frame.origin.x = 0;
                liveSetPriceV.frame = frame;
            }completion:^(BOOL finished){
                [liveSetPriceTxt becomeFirstResponder];
            }];
        }];
        
        
    }else if(sender==addpostSetupBack){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(sender==liveSetPriceDone){
        [self.view endEditing:YES];
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"GOLIVESCR"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        view.title = [NSString stringWithFormat:@"%@#%@",liveSetTitleTxt.text,liveSetPriceTxt.text];
        app.window.rootViewController = view;
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
