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
    [self.view setBackgroundColor:[UIColor clearColor]];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    code = @"1234"; //TODO: CHANGE TO SOMETHING BETTER
}

-(void) viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)raVerificationSubmit:(id)sender {
    if([_raCodeField.text isEqualToString:code]) {
        NSLog(@"The email is: %@", _email);
        //RA good to go, let's save him/her in our DB!
        
        [self.delegate didVerifyRA:YES];
        [self dismissViewControllerAnimated:NO completion:nil];

    } else {
        //show error because fail RA validation
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Wrong code" message:@"Please try again" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [errorAlert show];
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

//-(IBAction)backButtonPressed:(id)sender
//{
//    [self.delegate didVerifyRA:NO];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}




@end
