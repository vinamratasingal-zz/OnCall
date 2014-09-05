//
//  SignUpViewController.m
//  OnCall
//
//  Created by Vinamrata Singal on 8/9/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "SignUpViewController.h"
#import "LogInViewController.h"
#import "RAVerificationViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController () {
    NSArray *_pickerData;
    NSArray *_dormData;
    BOOL shouldDismiss;
}
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailOneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordOneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTwoField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UIPickerView *rolePickerChoice;
@property (weak, nonatomic) IBOutlet UIPickerView *dormPickerChoice;

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    _phoneNumberField.keyboardType = UIKeyboardTypeNamePhonePad;
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    self.rolePickerChoice.tag = 1;
    self.dormPickerChoice.tag = 2;
    _pickerData = @[@"RA", @"Resident"];
    _dormData = @[@"Crothers", @"Junipero", @"Paloma"];
    self.rolePickerChoice.dataSource = self;
    self.rolePickerChoice.delegate = self;
    self.dormPickerChoice.delegate = self;
    self.dormPickerChoice.dataSource = self;
    shouldDismiss = NO;

}
-(void) viewDidAppear:(BOOL)animated
{
    if(shouldDismiss)
        [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"signUpToRAVerification"]) {
        RAVerificationViewController *ravc = (RAVerificationViewController *)segue.destinationViewController;
        ravc.delegate = self;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    //recheck validations to make sure segue happens properly
    if(_nameField.text.length == 0 || _emailOneField.text.length == 0 || _passwordOneField.text.length == 0 || _passwordTwoField.text.length == 0) {
        return FALSE;
    }
    //email validation
    NSString *email = _emailOneField.text;
    if([email rangeOfString:@"@stanford.edu"].location == NSNotFound) {
        return FALSE;
    }
    //make sure the two passwords given match
    if(![_passwordOneField.text isEqualToString:_passwordTwoField.text]) {
        return FALSE;
    }
    //correct digits for phone number
    if(_phoneNumberField.text.length != 10) {
        return FALSE;
    }
    return TRUE;
}

- (BOOL)validateData {
    if(_nameField.text.length == 0 || _emailOneField.text.length == 0 || _passwordOneField.text.length == 0 || _passwordTwoField.text.length == 0) {
        UIAlertView *someEmptyFieldError = [[UIAlertView alloc] initWithTitle:@"Couldn't sign up" message:@"Please make sure all the fields were supplied" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [someEmptyFieldError show];
        return FALSE;
    }
    //email validation
    NSString *email = _emailOneField.text;
    if([email rangeOfString:@"@stanford.edu"].location == NSNotFound) {
        UIAlertView *noUsernameOrPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Invalid email" message:@"You must specify a stanford.edu email address" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [noUsernameOrPasswordAlert show];
        return FALSE;
    }
    //make sure the two passwords given match
    if(![_passwordOneField.text isEqualToString:_passwordTwoField.text]) {
        UIAlertView *passwordMismatch = [[UIAlertView alloc] initWithTitle:@"Password mismatch" message:@"Please make sure you correctly entered the same password in both fields" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [passwordMismatch show];
        return FALSE;
    }
    //correct digits for phone number
    if(_phoneNumberField.text.length != 10) {
        UIAlertView *wrongPhoneLength = [[UIAlertView alloc] initWithTitle:@"Phone Number Invalid" message:@"Please make sure you enter 10 digits for the phone number" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [wrongPhoneLength show];
        return FALSE;
    }
    return TRUE;
}

- (IBAction)registrationConfirmation:(id)sender {
    if([self validateData]) {
        NSInteger roleRow = [_rolePickerChoice selectedRowInComponent:0];
        NSString *role = [self pickerView: _rolePickerChoice titleForRow:roleRow forComponent:1];
        if([role isEqualToString: @"Resident"]) {
            
            [self submitUserInformation];
        } else {
            //RA, so let's validate dis ish
            [self performSegueWithIdentifier:@"signUpToRAVerification" sender:self];
            //shouldDismiss = YES;
        }
    }
}

-(void) submitUserInformation
{
    PFUser* user = [PFUser user];
    NSInteger roleRow = [_rolePickerChoice selectedRowInComponent:0];
    NSString *role = [self pickerView: _rolePickerChoice titleForRow:roleRow forComponent:1];
    user[@"role"] = role;
    NSString *email = _emailOneField.text;
    user[@"Name"] = _nameField.text;
    user.password = _passwordTwoField.text;
    user.email = email;
    user.username = email;
    user[@"phone_number"] = _phoneNumberField.text;
    NSInteger dormRow = [_dormPickerChoice selectedRowInComponent:0];
    NSString *dormChoice = [self pickerView: _dormPickerChoice titleForRow:dormRow forComponent:1];
    user[@"dorm"] = dormChoice;
    //entry is validated, so let's go ahead and load it in our DB
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            UIAlertView *savedInfo = [[UIAlertView alloc] initWithTitle:@"Please authenticate your email" message:@"Authenticate your email and login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [savedInfo show];
            //[self performSegueWithIdentifier:@"successfulRegisterSegue" sender:self];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Something went wrong..." message:errorString delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
            [errorAlert show];
            return;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == 1) {
        return _pickerData.count;
    } else {
        return _dormData.count;
    }
}

// The data to return for the row and component (column) that's being passed in
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView.tag == 1) {
        return [_pickerData objectAtIndex:row];
    } else {
        return [_dormData objectAtIndex:row];
    }
}

- (IBAction)unwindFromRAVerification:(UIStoryboardSegue *)segue {
    
}

#pragma ravc delegate methods

-(void) didVerifyRA:(BOOL) didVerify
{
    if(didVerify)
    {
        [self submitUserInformation];
    }
    
}

#pragma alertviewdelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //redirect back to login screen
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
