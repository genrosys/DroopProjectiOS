//
//  DualCollectionCell.m
//  Droop
//
//  Created by Smart Pro on 2/14/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import "DualCollectionCell.h"
#import <UIImageView+AFNetworking.h>
#import <UIButton+AFNetworking.h>

@implementation DualCollectionCell

- (void)configWithDual:(NSDictionary *)dualInfo
{
    [self layoutIfNeeded];
    
 
    
    CGRect fra = self.thumbImg.frame;
    fra.size.width = self.frame.size.width;// - 57;
    fra.size.height = self.frame.size.width;//self.linkedProfileBtn.frame.origin.y - 10 - self.thumbImg.frame.origin.y;
    self.thumbImg.frame = fra;
    
    self.usernameLbl.text = dualInfo[@"dual_posted_name"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd MMM, yyyy";
    NSString *currD = [formatter stringFromDate:[NSDate date]];
    
    NSString *dualTime = dualInfo[@"dual_date"];
    NSDate *dualD = [formatter dateFromString:dualTime];
    
    if ([currD isEqualToString:dualTime]) {
        self.timestampLbl.text = dualInfo[@"dual_time"];
    } else {
        NSInteger daysdiff = [self daysBetweenDate:dualD andDate:[NSDate date]];
        if (daysdiff <= 7) {
            self.timestampLbl.text = [NSString stringWithFormat:@"%d DAYS AGO", (int)daysdiff];
        }else{
            self.timestampLbl.text = dualTime;
        }
    }
    
    self.captionTxt.text = dualInfo[@"dual_caption"];
    
    NSURL *imageUrl = [NSURL URLWithString:dualInfo[@"dual_image"]];
    [self.thumbImg setImageWithURL:imageUrl];
    
    NSURL *postedUrl = [NSURL URLWithString:dualInfo[@"dual_posted_pic"]];
    [self.profileBtn setBackgroundImageForState:UIControlStateNormal withURL:postedUrl placeholderImage:[UIImage imageNamed:@"defpic.png"]];

    NSString *dualLinkedTo = dualInfo[@"dual_linked_to"];
    if (![dualLinkedTo isEqualToString:@"-1"]) {
        NSURL *linkedUrl = [NSURL URLWithString:dualInfo[@"dual_linked_profile_pic"]];
        [self.linkedProfileBtn setBackgroundImageForState:UIControlStateNormal withURL:linkedUrl placeholderImage:[UIImage imageNamed:@"defpic.png"]];
        
        CGRect frame = self.captionTxt.frame;
        frame.origin.x = self.linkedProfileBtn.frame.origin.x + self.linkedProfileBtn.frame.size.width;// + 50;
        frame.origin.y = self.linkedNameLbl.frame.origin.y + self.linkedNameLbl.frame.size.height+10; //serge
        frame.size.width = self.thumbImg.frame.size.width - (self.linkedProfileBtn.frame.size.width + 5);
        self.captionTxt.frame = frame;
        
        CGRect f = self.timestampLbl.frame;
        f.origin.y = self.captionTxt.frame.origin.y + self.captionTxt.frame.size.height - 5;
        f.origin.x = self.linkedProfileBtn.frame.origin.x + self.linkedProfileBtn.frame.size.width + 5;
        self.timestampLbl.frame = f;
        
        self.linkedNameLbl.text = dualInfo[@"dual_linked_name"];
        
        [self.linkedProfileBtn setHidden:NO];
        [self.linkedNameLbl setHidden:NO];
    } else {
        CGRect frame = self.captionTxt.frame;
        frame.origin.x = self.thumbImg.frame.origin.x +10;
        frame.origin.y = self.thumbImg.frame.origin.y + self.thumbImg.frame.size.height + 10;
        frame.size.width = self.thumbImg.frame.size.width;
        self.captionTxt.frame = frame;
        
        CGRect f = self.timestampLbl.frame;
         f.origin.x = self.linkedProfileBtn.frame.origin.x + self.linkedProfileBtn.frame.size.width + 5;
        f.origin.y = self.captionTxt.frame.origin.y + self.captionTxt.frame.size.height +10;        
  //      f.origin.x = self.thumbImg.frame.origin.x+15;
        self.timestampLbl.frame = f;
        
        [self.linkedProfileBtn setHidden:YES];
        [self.linkedNameLbl setHidden:YES];
    }
}

- (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end
