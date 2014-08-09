//
//  SignUpViewController.m
//  OnCall
//
//  Created by Vinamrata Singal on 8/9/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailOneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordOneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTwoField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _passwordOneField.secureTextEntry = YES;
    _passwordTwoField.secureTextEntry = YES;
    self.scrollView.contentSize = CGSizeMake(0, 701);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registrationConfirmation:(id)sender {
    //make sure all fields are non-empty
    if(_usernameField.text.length == 0 || _emailOneField.text.length == 0 || _passwordOneField.text.length == 0 || _passwordTwoField.text.length == 0) {
        UIAlertView *someEmptyFieldError = [[UIAlertView alloc] initWithTitle:@"Couldn't sign up" message:@"Please make sure all the fields were supplied" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [someEmptyFieldError show];
        return; 
    }
    //email validation
    NSString *email = _emailOneField.text;
    if([email rangeOfString:@"@stanford.edu"].location == NSNotFound) {
        UIAlertView *noUsernameOrPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Invalid email" message:@"You must specify a stanford.edu email address" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [noUsernameOrPasswordAlert show];
        return;
    }
    //make sure the two passwords given match
    if(![_passwordOneField.text isEqualToString:_passwordTwoField.text]) {
        UIAlertView *passwordMismatch = [[UIAlertView alloc] initWithTitle:@"Password mismatch" message:@"Please make sure you correctly entered the same password in both fields" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [passwordMismatch show];
        return;
    }
    //entry is validated, so let's go ahead and load it in our DB
    PFUser *user = [PFUser user];
    user.username = _usernameField.text;
    user.password = _passwordTwoField.text;
    user.email = email;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //TODO: tell user to check their email if not verified
            UIAlertView *savedInfo = [[UIAlertView alloc] initWithTitle:@"Whee saved" message:@"YOU GO GIRL" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
            [savedInfo show];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Something went wrong..." message:errorString delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
            [errorAlert show];
        }
    }];
}
@end
