//
//  RAVerificationViewController.h
//  OnCall
//
//  Created by Vinamrata Singal on 9/4/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RAVerificationViewControllerDelegate <NSObject>

-(void) didVerifyRA:(BOOL) didVerify; //to inform signup whether verification was successful

@end

@interface RAVerificationViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *dormChoice;
@property (nonatomic) NSString *role;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) id<RAVerificationViewControllerDelegate> delegate;

- (IBAction)raVerificationSubmit:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end
