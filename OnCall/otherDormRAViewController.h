//
//  otherDormRAViewController.h
//  OnCall
//
//  Created by Vinamrata Singal on 9/4/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface otherDormRAViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)logout:(id)sender;
- (IBAction)checkOtherDormInfo:(id)sender;
- (IBAction)callOnCallRA:(id)sender;
- (IBAction)textOnCallRa:(id)sender;
-(void) showLogin; 

@end
