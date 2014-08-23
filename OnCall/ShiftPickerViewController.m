//
//  ShiftPickerViewController.m
//  OnCall
//
//  Created by Michael Fang on 8/20/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "ShiftPickerViewController.h"
#import <Parse/Parse.h>

@interface ShiftPickerViewController ()

@end

@implementation ShiftPickerViewController
@synthesize startDate;
@synthesize endDate;

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
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [startDate setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //takes care of a weird problem with the size of the date picker
    [startDate addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[startDate(==162)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(startDate)]];
    [endDate setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    [endDate addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[endDate(==162)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(endDate)]];
}

-(IBAction)submitAction:(id)sender {
    
    //add event to parse
    PFObject *newShift = [PFObject objectWithClassName:@"Shift"];
    newShift[@"startDate"] = startDate.date;
    newShift[@"endDate"] = endDate.date;
    newShift[@"name"] = @"test"; //TODO: add user's name
    [newShift saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
