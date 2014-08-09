//
//  LogInViewController.m
//  OnCall
//
//  Created by Vinamrata Singal on 8/9/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LogInViewController

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
    _passwordField.secureTextEntry = YES;
    self.scrollView.contentSize = CGSizeMake(0, 701);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToLogIn:(UIStoryboardSegue *)segue {
}

- (IBAction)submitUserCredentials:(id)sender {
    if(_usernameField.text.length == 0 || _passwordField.text.length == 0) {
        UIAlertView *noUsernameOrPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't log in" message:@"Please make sure both username and password were supplied" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [noUsernameOrPasswordAlert show];
        return;
    }
    NSString *username = _usernameField.text;
    NSString *password = _passwordField.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            //TODO: Actually make this do something useful
            UIAlertView *loggedinAlert = [[UIAlertView alloc] initWithTitle:@"Whee logged in" message:@"YOU GO GIRL" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
            [loggedinAlert show];
        } else {
            UIAlertView *invalidLogin = [[UIAlertView alloc] initWithTitle:@"Username/password not found" message:@"Either the username or password you supplied was wrong, please try again" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
            [invalidLogin show];
        }
    }];
}

@end
