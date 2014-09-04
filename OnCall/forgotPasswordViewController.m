//
//  forgotPasswordViewController.m
//  OnCall
//
//  Created by Vinamrata Singal on 9/4/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "forgotPasswordViewController.h"
#import <Parse/Parse.h>

@interface forgotPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

@implementation forgotPasswordViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        [self performSegueWithIdentifier:@"unwindToLogin" sender:self];
    }
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


- (IBAction)recoverPassword:(id)sender {
    [PFUser requestPasswordResetForEmailInBackground:self.emailField.text];
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Check your email" message:@"Please check your email to reset your password" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
    [success show];
    //[self performSegueWithIdentifier:@"unwindToLogin" sender:self];
}
@end
