//
//  OCTabBarControllerDelegate.m
//  OnCall
//
//  Created by Michael Fang on 9/4/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "OCTabBarControllerDelegate.h"
#import <Kal.h>

#import "MainViewController.h"
#import "MyKalDataSource.h"
#import "NSDate+Convenience.h"
#import "otherDormRAViewController.h"

@interface OCTabBarControllerDelegate ()

@property (nonatomic, retain) id<KalDataSource> source;
@end



static OCTabBarControllerDelegate *theTabBarDelegate;

@implementation OCTabBarControllerDelegate
@synthesize source;
+ (OCTabBarControllerDelegate*) instance {
    if(theTabBarDelegate == nil)
    {
        theTabBarDelegate = [[OCTabBarControllerDelegate alloc] init];
    }
    return theTabBarDelegate;
}

- (NSArray*) getNewViewControllersForTabBar: (PFUser *)currUser
{
    MainViewController * mainView = [[MainViewController alloc ] initWithNibName:@"MainViewController" bundle:nil];
    
    otherDormRAViewController * otherDorms = [[otherDormRAViewController alloc] initWithNibName:@"otherDormRAViewController" bundle:nil];
    //PFUser *currUser = [PFUser currentUser];
    if(currUser == NULL) {
        [PFUser logOut];
        NSLog(@"derp derp derp");
    }
    if([currUser[@"role"] isEqualToString:@"RA"]) {
        
        source = [[MyKalDataSource alloc] init];
        KalViewController *calendar = [[KalViewController alloc] initWithSelectionMode:KalSelectionModeSingle];
        calendar.selectedDate = [NSDate dateStartOfDay:[[NSDate date] offsetDay:0]];
        calendar.dataSource = source;
        
        [calendar showAndSelectDate:[NSDate date]];
        UINavigationController* navController = [[UINavigationController alloc]
                                                 initWithRootViewController:calendar];
        return [NSArray arrayWithObjects: mainView, otherDorms, navController, nil];
    } else {
        return [NSArray arrayWithObjects: mainView, otherDorms, nil];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if([viewController isKindOfClass:[UINavigationController class]])
    {
        KalViewController *calendar = ((UINavigationController*)viewController).viewControllers[0]; //assuming only calendar is ever going to be in stack
        [calendar didSelectDate: calendar.selectedDate];
    }
}

@end
