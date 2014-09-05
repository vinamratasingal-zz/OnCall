//
//  MainViewController.m
//  OnCall
//
//  Created by Michael Fang on 8/19/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "MainViewController.h"
#import <Parse/Parse.h>

@interface MainViewController () {
    NSString *raOnCallPhone;
}
@property (weak, nonatomic) IBOutlet UILabel *raOnCallField;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberRAField;
@property (weak, nonatomic) IBOutlet UILabel *currentDorm;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Dashboard";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    //check login
    NSDate *date = [NSDate date];
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser == nil) {
        [PFUser logOut];
        [self showLogin];
    }
    NSString* currDorm;
    if(currentUser != NULL) {
        currDorm = currentUser[@"dorm"];
        if(currDorm == nil)
            [PFUser logOut];
    } else {
        currDorm = @"Please login to see this";
    }
    _currentDorm.text = currDorm;
    PFQuery *query = [PFQuery queryWithClassName:@"Shift"];
    [query whereKey:@"startDate" lessThanOrEqualTo:date];
    [query whereKey:@"endDate" greaterThan:date];
    [query whereKey: @"dorm" equalTo:currDorm];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            if([objects count] == 0) {
                self.raOnCallField.text = @"None";
                self.phoneNumberRAField.text = @"N/A";
                raOnCallPhone = @"N/A";
            } else {
                for(PFObject *object in objects) {
                    NSString *onCallRAName = [object objectForKey:@"name"];
                    NSString *onCallRAPhone = [object objectForKey:@"phone_number"];
                    NSLog(@"RA name is: %@", onCallRAName);
                    NSLog(@"RA phone is: %@",  onCallRAPhone);
                    raOnCallPhone = onCallRAPhone;
                    self.raOnCallField.text = onCallRAName;
                    self.phoneNumberRAField.text = onCallRAPhone;
                }
            }
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
    if ([currentUser[@"role"] isEqualToString:@"RA"]) {
        // do stuff with the RA i.e. show scheduling tab and who is on call
    } else if ([currentUser[@"role"] isEqualToString:@"Resident"]) {
        //do stuff with the Resident i.e. just show who's on call and have them be called.
    } else {
        [self showLogin];
    }
}


-(void) showLogin {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

-(IBAction)onLogout:(id)sender
{
    [PFUser logOut];
    [self showLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callRAButton:(id)sender {
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:raOnCallPhone];
    if ([raOnCallPhone isEqualToString:@"N/A"]) {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Uh oh" message:@"Couldn't place that call" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [error show];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

- (IBAction)messageRAButton:(id)sender {
    NSString *stringURL = [@"sms:" stringByAppendingString:raOnCallPhone];
    NSURL *url = [NSURL URLWithString:stringURL];
    if ([raOnCallPhone isEqualToString:@"N/A"]) {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Uh oh" message:@"Couldn't place that call" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [error show];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end
