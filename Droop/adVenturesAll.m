//
//  adVenturesAll.m
//  Droop
//
//  Created by Himanshu Sharma on 25/11/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "adVenturesAll.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>

@interface adVenturesAll ()

@end

@implementation adVenturesAll

@synthesize adVentureAllColl,adventureAllBack,adventureAllPost,adventureAllSearchTxt;
@synthesize adventureAllheadV;
@synthesize advNoLbl;
NSMutableArray *advAllArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    adventureAllheadV.layer.cornerRadius = adventureAllheadV.frame.size.height/2;
    adventureAllheadV.layer.masksToBounds = YES;
    [self getVentures];
    // Do any additional setup after loading the view.
}

-(void)callSearchVentureAPI{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"searchventure.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"search_txt=%@",adventureAllSearchTxt.text] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                advAllArr = [result objectForKey:@"data"];
                [self reloadVentureCollections];
            }else{
                [self noventuresFound];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    advAllArr = [[NSMutableArray alloc]init];
    [adVentureAllColl reloadData];
    if(textField.text.length>0){
        [self callSearchVentureAPI];
    }else{
        [self getVentures];
    }
    [textField resignFirstResponder];
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((collectionView.frame.size.width-2)/2, ((collectionView.frame.size.width-2)/2)+57);
    return size;
}

-(void)reloadVentureCollections{
    [advNoLbl setHidden:YES];
    [adVentureAllColl setHidden:NO];
    [adVentureAllColl reloadData];
}

-(void)getVentures{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"getVentures.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"user_id=%@",[app.userData objectForKey:@"user_id"]] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result.count>0){
            NSString *status = [result objectForKey:@"status"];
            if([status isEqualToString:@"1"]){
                advAllArr = [result objectForKey:@"data"];
                [self reloadVentureCollections];
            }else{
                [self noventuresFound];
            }
        }else{
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return advAllArr.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.selVentureDict = [advAllArr objectAtIndex:indexPath.row];
    UIStoryboard *story = self.storyboard;
    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"VENTUREPRE"];
    view.title = @"ALL";
    app.window.rootViewController = view;
}

-(IBAction)buttonPressed:(id)sender{
    if(sender==adventureAllBack){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"HOME"];
        __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.window.rootViewController = view;
    }else if(sender==adventureAllPost){
        UIStoryboard *story = self.storyboard;
        UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ADDPOSTSETUP"];
        [self presentViewController:view animated:YES completion:nil];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellVenture" forIndexPath:indexPath];
    
    UIImageView *mainImg = (UIImageView *)[cell viewWithTag:100];
    UILabel *ventureLbl  = (UILabel *)[cell viewWithTag:102];
    UILabel *userLbl = (UILabel *)[cell viewWithTag:103];
    UILabel *countLLbl = (UILabel *)[cell viewWithTag:685];
    
    NSDictionary *ventureInfo = advAllArr[indexPath.row];
    
    NSString *numberViewsStr = ventureInfo[@"views_count"];
    int numberViews = [numberViewsStr intValue];
    if(numberViews<999){
        countLLbl.text = [NSString stringWithFormat:@"%d View(s)",numberViews];
    }else{
        countLLbl.text = [NSString stringWithFormat:@"%@ View(s)",[self suffixNumber:[NSNumber numberWithInt:numberViews]]];
    }
    
    userLbl.text = ventureInfo[@"user_name"];
    ventureLbl.text = ventureInfo[@"venture_title"];
    [mainImg setImageWithURL:[NSURL URLWithString:ventureInfo[@"venture_thumb"]]];
    
    return cell;
}

-(NSString*) suffixNumber:(NSNumber*)number
{
    if (!number)
        return @"";
    
    long long num = [number longLongValue];
    
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log10l(num) / 3.f); //log10l(1000));
    
    NSArray* units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    return [NSString stringWithFormat:@"%@%.1f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}

-(void)noventuresFound{
    [advNoLbl setHidden:NO];
    [adVentureAllColl setHidden:YES];
}

-(void)failed:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    alert = nil;
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
