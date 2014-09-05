//
//  otherDormRAViewController.m
//  OnCall
//
//  Created by Vinamrata Singal on 9/4/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "otherDormRAViewController.h"
#import <Parse/Parse.h>

@interface otherDormRAViewController () {
    NSArray *dormPickerData;
    NSString *raOnCallPhone;
}
@property (weak, nonatomic) IBOutlet UIPickerView *dormPicker;
@property (weak, nonatomic) IBOutlet UILabel *raOnCall;
@property (weak, nonatomic) IBOutlet UILabel *phoneOfOnCallRA;

@end

@implementation otherDormRAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Other Dorms";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dormPickerData = @[@"Crothers", @"Junipero", @"Paloma"];
    self.dormPicker.dataSource = self;
    self.dormPicker.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showLogin {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self showLogin];
}

- (IBAction)checkOtherDormInfo:(id)sender {
    NSInteger dormRow = [self.dormPicker selectedRowInComponent:0];
    NSString *dorm = [self pickerView: self.dormPicker titleForRow:dormRow forComponent:1];
    //get the On-Call RA for that dorm
    NSDate *date = [NSDate date];
    PFQuery *query = [PFQuery queryWithClassName:@"Shift"];
    [query whereKey:@"startDate" lessThanOrEqualTo:date];
    [query whereKey:@"endDate" greaterThan:date];
    [query whereKey: @"dorm" equalTo:dorm];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            if([objects count] == 0) {
                self.raOnCall.text = @"None";
                self.phoneOfOnCallRA.text = @"N/A";
            } else {
                for(PFObject *object in objects) {
                    NSString *onCallRAName = [object objectForKey:@"name"];
                    NSString *onCallRAPhone = [object objectForKey:@"phone_number"];
                    NSLog(@"RA name is: %@", onCallRAName);
                    NSLog(@"RA phone is: %@",  onCallRAPhone);
                    raOnCallPhone = onCallRAPhone;
                    self.raOnCall.text = onCallRAName;
                    self.phoneOfOnCallRA.text = onCallRAPhone;
                }
            }
            
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (IBAction)callOnCallRA:(id)sender {
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:raOnCallPhone];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Uh oh" message:@"Couldn't place that call" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [error show];
    }
}

- (IBAction)textOnCallRa:(id)sender {
    NSString *stringURL = [@"sms:" stringByAppendingString:raOnCallPhone];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dormPickerData.count;
}

// The data to return for the row and component (column) that's being passed in
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [dormPickerData objectAtIndex:row];
}

@end
