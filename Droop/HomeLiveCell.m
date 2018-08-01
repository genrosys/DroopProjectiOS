//
//  HomeLiveCell.m
//  Droop
//
//  Created by Smart Pro on 2/14/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import "HomeLiveCell.h"
#import "LiveCollectionCell.h"
#import "AppDelegate.h"

@implementation HomeLiveCell

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.liveAry count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellLive" forIndexPath:indexPath];
    [cell configWithLive:self.liveAry[indexPath.row]];
    cell.usernameBtn.tag = 100 + indexPath.row;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.selStreamDict = self.liveAry[indexPath.row];
    UIViewController *view = [app.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"VIEWBROADCAST"];
    app.window.rootViewController = view;
}

@end
