//
//  RAVerificationViewController.h
//  OnCall
//
//  Created by Vinamrata Singal on 9/4/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RAVerificationViewController : UIViewController
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *dormChoice;
@property (nonatomic) NSString *role;
@property (nonatomic) NSString *phoneNumber;
- (IBAction)raVerificationSubmit:(id)sender;

@end
