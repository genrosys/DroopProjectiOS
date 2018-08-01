 //
//  AppDelegate.h
//  Droop
//
//  Created by apple on 30/08/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate> {
    NSMutableDictionary *userData;
    UIImage *thumbImg;
    NSString *proUserID;
    NSMutableDictionary *selStreamDict;
    NSMutableDictionary *selVentureDict;
    NSMutableArray *followArr;
    UIImage *croppedImage;
    BOOL isLiveCurrently;
    sqlite3 *database;
    NSString *databasePath;
    NSString *dToken;
}

@property (nonatomic) NSString *dToken;
@property (nonatomic) sqlite3 *database;
@property (nonatomic) NSString *databasePath;
@property (nonatomic) BOOL isLiveCurrently;
@property (nonatomic) UIImage *croppedImage;
@property (nonatomic) NSMutableArray *followArr;
@property (nonatomic) NSMutableDictionary *selVentureDict;
@property (nonatomic) NSString *proUserID;
@property (nonatomic) NSMutableDictionary *selStreamDict;
@property (nonatomic) UIImage *thumbImg;
@property (nonatomic) NSMutableDictionary *userData;
@property (strong, nonatomic) UIWindow *window;

- (void)makeAPICall:(NSDictionary *)request completionHandler:(void (^)(NSMutableDictionary *result, NSError *error))completionHandler;
- (NSMutableDictionary *)getSavedUser;
- (BOOL)delUser;
- (BOOL)saveuser:(NSMutableDictionary *)dict;
- (void)getToken;
- (void)removeViewer:(NSString *)str;
- (void)callDelete:(NSString *)liveid;

@end

