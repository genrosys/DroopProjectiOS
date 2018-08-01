//
//  ChatViewController.h
//  Droop
//
//  Created by Smart Pro on 2/9/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MXRMessenger.h>

@interface ChatViewController : MXRMessengerViewController

@property (nonatomic, strong) MXRMessageCellFactory *cellFactory;

- (instancetype)initWithPerson:(NSDictionary *)personInfo;

@end
