//
//  RAVerificationViewController.m
//  OnCall
//
//  Created by Vinamrata Singal on 9/4/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "RAVerificationViewController.h"
#import <Parse/Parse.h>

@interface RAVerificationViewController () {
    NSString *code;
}
@property (weak, nonatomic) IBOutlet UITextField *raCodeField;

@end

@implementation RAVerificationViewController

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
    // Do any additional setup after loading the view.
    code = @"1234"; //TODO: CHANGE TO SOMETHING BETTER
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)raVerificationSubmit:(id)sender {
    if([_raCodeField.text isEqualToString:code]) {
        NSLog(@"The email is: %@", _email);
        //RA good to go, let's save him/her in our DB!
        PFUser* user = [PFUser user];
        user[@"role"] = self.role;
        user[@"Name"] = self.name;
        user.password = self.password;
        user.email = self.email;
        user.username = self.email;
        user[@"phone_number"] = self.phoneNumber;
        user[@"dorm"] = self.dormChoice;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                UIAlertView *savedInfo = [[UIAlertView alloc] initWithTitle:@"Please authenticate your email" message:@"Authenticate your email and login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [savedInfo show];
                [self performSegueWithIdentifier:@"successfulRACodeSubmit" sender:self]; //redirect back to login screen
            } else {
                NSString *errorString = [error userInfo][@"error"];
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Something went wrong..." message:errorString delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
                [errorAlert show];
                return;
            }
        }];
    } else {
        //show error because fail RA validation
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Wrong code" message:@"Please try again" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [errorAlert show];
    }
}
@end
