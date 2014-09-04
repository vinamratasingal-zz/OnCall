//
//  SignUpViewController.m
//  OnCall
//
//  Created by Vinamrata Singal on 8/9/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "SignUpViewController.h"
#import "LogInViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController () {
    NSArray *_pickerData;
    NSArray *_dormData;
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

}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

//Makes sure that after successful sign up, user is lead back to the login screen
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"returnToLogin" sender:self];
    }
    
}

- (IBAction)registrationConfirmation:(id)sender {
    //make sure all fields are non-empty
    if(_nameField.text.length == 0 || _emailOneField.text.length == 0 || _passwordOneField.text.length == 0 || _passwordTwoField.text.length == 0) {
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
    user[@"Name"] = _nameField.text;
    user.password = _passwordTwoField.text;
    user.email = email;
    user.username = email;
    user[@"phone_number"] = _phoneNumberField.text;
    NSInteger roleRow = [_rolePickerChoice selectedRowInComponent:0];
    NSString *roleChoice = [self pickerView: _rolePickerChoice titleForRow:roleRow forComponent:1];
    user[@"role"] = roleChoice;
    NSInteger dormRow = [_dormPickerChoice selectedRowInComponent:0];
    NSString *dormChoice = [self pickerView: _dormPickerChoice titleForRow:dormRow forComponent:1];
    user[@"dorm"] = dormChoice;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            UIAlertView *savedInfo = [[UIAlertView alloc] initWithTitle:@"Please authenticate your email" message:@"Authenticate your email and login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [savedInfo show];
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
@end
