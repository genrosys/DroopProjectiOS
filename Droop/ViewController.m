//
//  ViewController.m
//  Droop
//
//  Created by apple on 30/08/17.
//  Copyright © 2017 pixatra. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(moveNext) withObject:nil afterDelay:3];
}

- (void)successLogin {
    UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"HOME"];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = view;
}

- (void)failed:(NSString *)str {
    [self.view setUserInteractionEnabled:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN"];
    app.window.rootViewController = view;
}

- (void)callLoginAPI:(NSMutableDictionary *)savedUser {
    
    __unsafe_unretained AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"login.php" forKey:@"API"];
    [dict setObject:[NSString stringWithFormat:@"username=%@&password=%@", [savedUser objectForKey:@"username"], [savedUser objectForKey:@"password"]] forKey:@"requestBody"];
    [app makeAPICall:dict completionHandler:^(NSMutableDictionary *result, NSError *error) {
        if (result.count > 0) {
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"1"]){
                app.userData = [result objectForKey:@"data"];
                [self successLogin];
            } else {
                [self failed:@"Oops! Something went wrong, please try again. If problem persists, contact us."];
            }
        } else {
            [self failed:@"Oops! Seems like a connection issue, please check and try again."];
        }
    }];
}

- (void)moveNext {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *savedUser = [app getSavedUser];
    if (savedUser.count > 0) {
        [self callLoginAPI:savedUser];
    } else {
        UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN"];
        app.window.rootViewController = view;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

