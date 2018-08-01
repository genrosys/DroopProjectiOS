//
//  AppDelegate.m
//  Droop
//
//  Created by apple on 30/08/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize userData;
@synthesize thumbImg;
@synthesize selStreamDict;
@synthesize proUserID;
@synthesize selVentureDict;
@synthesize followArr;
@synthesize croppedImage;
@synthesize isLiveCurrently;
@synthesize database,databasePath;
@synthesize dToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    isLiveCurrently = NO;
    [Fabric with:@[[Crashlytics class]]];
    [self createTables];
    // Override point for customization after application launch.
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD setMaximumDismissTimeInterval:3.0];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setObject:@"" forKey:@"username"];   // This will compile fine
    [d setObject:@"" forKey:@"password"];
    [defaults registerDefaults:d];
    
    return YES;
}


- (void)getToken {
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if( !error ){
                // [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)removeViewer:(NSString *)str {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"removeViewer.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"live_id=%@",str] forKey:@"requestBody"];
    
    [self makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        NSLog(@"Result: %@", result);
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSString *message = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
    NSLog(@"%@", message);
    
    if (application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        if ([message rangeOfString:@"sent you a message" options:NSCaseInsensitiveSearch].length > 0) {
            
        } else {
            
        }
        
        //opened from a push notification when the app was on background
    } else {
        
        if ([message rangeOfString:@"sent you a message" options:NSCaseInsensitiveSearch].length > 0) {
            @try {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHCOUNTHOME" object:nil];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
            @try {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHPROCOUNT" object:nil];
            } @catch(NSException *r) {}
            
            @try {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"DISCOVERCOUNTRELOAD" object:nil];
            } @catch(NSException *r){}
            
            @try {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"CHATTHREADRELOAD" object:nil];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
            @try {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"MSGSRELOAD" object:nil];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }else{
            @try{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFETCHNOTIFICATION" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMENOTIFYCOUNT" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DISCOVERNOTIFYCOUNT" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MSGTHREADNOTIFYCOUNT" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PRONOTIFYSHOW" object:nil];
            }@catch(NSException *r){}
        }
        
    }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    app.dToken = [NSString stringWithFormat:@"%@", deviceToken];
    app.dToken = [app.dToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    app.dToken = [app.dToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    app.dToken = [app.dToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",app.dToken);
    NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)makeAPICall:(NSMutableDictionary *)request completionHandler:(void (^)(NSMutableDictionary *result, NSError *error))completionHandler {
    NSString *callto = [request objectForKey:@"API"];
    NSLog(@"pmh>>>%@",callto);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.droopllc.com/Droop1/%@", callto]]];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *requestBody = [request objectForKey:@"requestBody"];
    NSData *jsondata = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    
    [urlRequest setHTTPBody:jsondata];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask * dataTask = [manager dataTaskWithRequest:urlRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            
            if (completionHandler) {
                completionHandler(dict, nil);
            }
        } else {
            NSLog(@"%@", error.description);
            
            if (completionHandler) {
                completionHandler(nil, error);
            }
        }
    }];
    [dataTask resume];
    /*
    [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            if (completionHandler) {
                completionHandler(dict, nil);
            }
        } else {
            NSLog(@"%@", error.description);
            
            if (completionHandler) {
                completionHandler(nil, error);
            }
        }
    }];*/
}
/*
- (void)makeAPICall:(NSDictionary *)request completionHandler:(void (^)(NSMutableDictionary *result, NSError *error))completionHandler {
    
    NSString *urlString = [@"http://www.droopllc.com/Droop1" stringByAppendingPathComponent:request[@"API"]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *param in [request[@"requestBody"] componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if ([elts count] < 2) continue;
        [params setObject:elts[1] forKey:elts[0]];
    }
    
    NSDictionary *requestData = request[@"formData"];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (requestData) {
            [formData appendPartWithFormData:requestData[@"data"] name:requestData[@"name"]];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if (completionHandler) {
            completionHandler(dict, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.description);
        if (completionHandler) {
            completionHandler(nil, error);
        }
    }];
}
*/
- (NSMutableDictionary *)getSavedUser {
    NSMutableDictionary *arr = [[NSMutableDictionary alloc] init];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentdir = [documentPaths objectAtIndex:0];
    if (!databasePath) {
        databasePath = [[NSString alloc] initWithString:[documentdir stringByAppendingPathComponent:@"droopprivate.db"]];
    }
    
    sqlite3_stmt *statement;
    const char *dbPath = [databasePath UTF8String];
    if(sqlite3_open(dbPath, &database) == SQLITE_OK)
    {
        NSString *insertStatement = [NSString stringWithFormat:@"SELECT email,password FROM USERDETAIL"];
        const char *stmt = [insertStatement UTF8String];
        if(sqlite3_prepare_v2(database,stmt, -1,&statement,NULL)==SQLITE_OK)
        {
            if(sqlite3_step(statement)==SQLITE_ROW)
            {
                
                const char *objid = (char *)sqlite3_column_text(statement, 0);
                NSString *stobjId = [[NSString alloc]initWithUTF8String:objid];
                [arr setObject:stobjId forKey:@"username"];
                
                stobjId = nil;
                objid = nil;
                
                const char *objectid = (char *)sqlite3_column_text(statement, 1);
                NSString *stobjectId = [[NSString alloc]initWithUTF8String:objectid];
                [arr setObject:stobjectId forKey:@"password"];
            }
        }else{
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return arr;
}

- (BOOL)delUser {
    BOOL isSaved=NO;
    NSString *documentdir;
    NSArray *documentPaths;
    sqlite3_stmt *statement;
    documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentdir = [documentPaths objectAtIndex:0];
    if(!databasePath)
    {
        databasePath = [[NSString alloc]initWithString:[documentdir stringByAppendingPathComponent:@"droopprivate.db"]];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:databasePath]==YES)
    {
        const char *defaultPath = [databasePath UTF8String];
        if(sqlite3_open(defaultPath, &database)==SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM USERDETAIL"];
            const char *stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(database, stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                isSaved=YES;
            }else{}
        }
        sqlite3_close(database);
        fileManager = nil;
    }
    documentPaths = nil;
    documentdir = nil;
    return isSaved;
}

-(BOOL)saveuser:(NSMutableDictionary *)dict{
    BOOL isSaved=NO;
    NSString *documentdir;
    NSArray *documentPaths;
    sqlite3_stmt *statement;
    documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentdir = [documentPaths objectAtIndex:0];
    if(!databasePath)
    {
        databasePath = [[NSString alloc]initWithString:[documentdir stringByAppendingPathComponent:@"droopprivate.db"]];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:databasePath]==YES)
    {
        const char *defaultPath = [databasePath UTF8String];
        if(sqlite3_open(defaultPath, &database)==SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO USERDETAIL(email,password) VALUES(\"%@\",\"%@\")",[dict objectForKey:@"username"],[dict objectForKey:@"password"]];
            const char *stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(database, stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                isSaved=YES;
            }else{}
        }
        sqlite3_close(database);
        fileManager = nil;
    }
    documentPaths = nil;
    documentdir = nil;
    return isSaved;
}

- (void)callDelete:(NSString *)liveid{
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"delLive.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"streamid=%@", liveid] forKey:@"requestBody"];

    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if(result){
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"1"]){
                app.isLiveCurrently = NO;
            }else{
            }
        }else{
            
        }
    }];
}

-(void)createTables{
    
    NSString *documentdir;
    NSArray *documentPaths;
    
    documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentdir = [documentPaths objectAtIndex:0];
    if(!databasePath){
        databasePath = [[NSString alloc]initWithString:[documentdir stringByAppendingPathComponent:@"droopprivate.db"]];
    }
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    if([fileManager fileExistsAtPath:app.databasePath]==NO){
    
    const char *defaultPath = [databasePath UTF8String];
    char *errMsg;
    
    if(sqlite3_open(defaultPath, &database)==SQLITE_OK){
        
        const char *create_Query = "CREATE TABLE IF NOT EXISTS USERDETAIL(email TEXT, password TEXT)";
        
        if(sqlite3_exec(database, create_Query, NULL, NULL, &errMsg)!=SQLITE_OK){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Failed to create Table." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            alert = nil;
        }
        create_Query = nil;
        
        sqlite3_close(database);
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Failed to create Database." delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        if([[UIDevice currentDevice].systemVersion intValue]>6){
            [alert setTintColor:[UIColor colorWithRed:0.824 green:0.18 blue:0.231 alpha:1]];
        }
        [alert show];
        alert  = nil;
    }
    //    fileManager = nil;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

