//
//  AppDelegate.m
//  OnCall
//
//  Created by Vinamrata Singal on 8/9/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <Kal/Kal.h>
#import "NSDate+Convenience.h"
#import "MyKalDataSource.h"
#import "MainViewController.h"

@interface AppDelegate ()

@property (nonatomic, retain) id<KalDataSource> source;
@end

@implementation AppDelegate
@synthesize source;
@synthesize tabBarController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[Parse setApplicationId:@"3XFtjNttrOYIq1C8kPOB7N5E207BAoo450tr01gU" clientKey:@"c5S83cGhGgCs23dNDREePY6YbuE7UKKv6y1TKfAT"];
    
    [Parse setApplicationId:@"8kVjXhqaOEAywzk6lwAJJZQpqPCKaMVglcncdIK0" clientKey:@"3jpGMZIAlOVoiEp8DflogqIRZ87pCAlHYlqOd4Vk"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    MainViewController * mainView = [[MainViewController alloc ] initWithNibName:@"MainViewController" bundle:nil];
    
    source = [[MyKalDataSource alloc] init];
    KalViewController *calendar = [[KalViewController alloc] initWithSelectionMode:KalSelectionModeSingle];
    calendar.selectedDate = [NSDate dateStartOfDay:[[NSDate date] offsetDay:0]];
    calendar.dataSource = source;
    
    [calendar showAndSelectDate:[NSDate date]];
    
    UINavigationController* navController = [[UINavigationController alloc]
                                             initWithRootViewController:calendar];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects: mainView, mainView, navController, nil];
    
    self.window.rootViewController = self.tabBarController;
    tabBarController.delegate = self;
    
    [self.window makeKeyAndVisible];
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

#pragma mark UITabBarControllerDelegate Methods 

- (BOOL)tabBarController:(UITabBarController *)tBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSUInteger tabIndex = [tBarController.viewControllers indexOfObject:viewController];
    
    if (viewController == [tBarController.viewControllers objectAtIndex:tabIndex] ) {
        return YES;
    }
    
    return NO;
    
}



@end
