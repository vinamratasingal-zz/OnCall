//
//  ShiftPickerViewController.h
//  OnCall
//
//  Created by Michael Fang on 8/20/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShiftPickerViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIDatePicker* startDate;
@property (nonatomic, retain) IBOutlet UIDatePicker* endDate;

- (void) setDate:(NSDate*) date;


@end
