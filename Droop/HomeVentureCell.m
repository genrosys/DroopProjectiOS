//
//  HomeVentureCell.m
//  Droop
//
//  Created by Smart Pro on 2/14/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import "HomeVentureCell.h"
#import "VentureCollectionCell.h"
#import "AppDelegate.h"

@implementation HomeVentureCell

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VentureCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellVenture" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *view = [app.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"VENTUREPRE"];
    app.window.rootViewController = view;
}

@end
