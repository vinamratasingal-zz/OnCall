//
//  OCTabBarControllerDelegate.h
//  OnCall
//
//  Created by Michael Fang on 9/4/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface OCTabBarControllerDelegate : NSObject <UITabBarControllerDelegate>

+ (OCTabBarControllerDelegate*) instance;

- (NSArray*) getNewViewControllersForTabBar: (PFUser *)user; //maybe this should be a + function? (the source has to be retained, though)

@end
