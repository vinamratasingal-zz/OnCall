//
//  LogInViewController.m
//  OnCall
//
//  Created by Vinamrata Singal on 8/9/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "LogInViewController.h"

#import <Parse/Parse.h>
#import "Kal.h"
#import "NSDate+Convenience.h"
#import "MyKalDataSource.h"


@interface LogInViewController ()
{
    id<KalDataSource> source;
}
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
    //self.scrollView.contentSize = CGSizeMake(0, 701);
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
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
            if(![[user objectForKey:@"emailVerified"] boolValue]) {
                [user refresh];
                if (![[user objectForKey:@"emailVerified"] boolValue]) {
                    UIAlertView *missingAuthAlert = [[UIAlertView alloc] initWithTitle:@"Missing email authentication" message:@"Please authenticate your email and try again" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
                    [missingAuthAlert show];
                    return;
                }
            }
            //TODO: Actually make this do something useful
            //UIAlertView *loggedinAlert = [[UIAlertView alloc] initWithTitle:@"Whee logged in" message:@"YOU GO GIRL" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
            //[loggedinAlert show];
    
            [self dismissViewControllerAnimated:YES completion:^{ }];
    
            
        } else {
            UIAlertView *invalidLogin = [[UIAlertView alloc] initWithTitle:@"Username/password not found" message:@"Either the username or password you supplied was wrong, please try again" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
            [invalidLogin show];
        }
    }];

    
    
}

- (IBAction)signup:(id)sender
{
    
}

@end
