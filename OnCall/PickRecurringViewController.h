//
//  PickRecurringViewController.h
//  OnCall
//
//  Created by Michael Fang on 9/5/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickRecurringViewControllerDelegate <NSObject>

-(void) setNumRecurrences:(int) numRecurrence;
@end

@interface PickRecurringViewController : UIViewController



@property IBOutlet UITextField *numRecurrence;
@property (retain) id<PickRecurringViewControllerDelegate> delegate;

@end
