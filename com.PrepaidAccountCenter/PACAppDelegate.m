//
//  PACAppDelegate.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 6/7/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "PACAppDelegate.h"
#import "LoginViewController.h"

@implementation PACAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self.window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default_iPad_BG.png"]]];

    }
    else{
    [self.window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DefaultBG.png"]]];
    }
    //Default_iPad_BG
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        UIView *addStatusBar = [[UIView alloc] init];
//        addStatusBar.frame = CGRectMake(0, 0, 320, 20);
//        addStatusBar.backgroundColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1]; //change this to match your navigation bar
//        [self.window.rootViewController.view addSubview:addStatusBar];
//    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void) LogoutUser
{
    LoginViewController* login = [[LoginViewController alloc]init];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = nil;
	self.window.rootViewController = login;
    UIStoryboard *LoginStoryBoard_iphone =[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *userviewsVC =[LoginStoryBoard_iphone instantiateViewControllerWithIdentifier:@"LoginViewNavController"];
    userviewsVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    userviewsVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self.window.rootViewController presentViewController:userviewsVC animated:YES completion:nil];
	
}

@end
