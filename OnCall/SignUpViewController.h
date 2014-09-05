//
//  SignUpViewController.h
//  OnCall
//
//  Created by Vinamrata Singal on 8/9/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAVerificationViewController.h"

@interface SignUpViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, RAVerificationViewControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
- (IBAction)registrationConfirmation:(id)sender;
- (IBAction)unwindFromRAVerification:(UIStoryboardSegue *)segue;
@end
