//
//  LogInViewController.h
//  OnCall
//
//  Created by Vinamrata Singal on 8/9/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController

- (IBAction)unwindToLogIn:(UIStoryboardSegue *)segue;
- (IBAction)submitUserCredentials:(id)sender;
- (IBAction)signup:(id)sender;

@end
