//
//  VentureCollectionCell.m
//  Droop
//
//  Created by Smart Pro on 2/14/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import "VentureCollectionCell.h"
#import <UIImageView+AFNetworking.h>

@implementation VentureCollectionCell

- (void)configWithVenture:(NSDictionary *)ventureInfo
{
}

- (NSString *)suffixNumber:(NSNumber *)number
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

@end
