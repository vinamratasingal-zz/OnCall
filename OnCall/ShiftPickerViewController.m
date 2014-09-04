//
//  ShiftPickerViewController.m
//  OnCall
//
//  Created by Michael Fang on 8/20/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "ShiftPickerViewController.h"
#import <Parse/Parse.h>
#import <Kal.h>

@interface ShiftPickerViewController ()

@end

@implementation ShiftPickerViewController
@synthesize startDate;
@synthesize endDate;

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
    // Custom initialization
    startDate.date = [[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval) 0 ];
    startDate.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval) 0 ];
    endDate.date = [[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval) 300 ];
    endDate.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval) 0 ];
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
    
    //validate valid range
    
    //add event to parse
    PFUser *currentUser = [PFUser currentUser];
    PFObject *newShift = [PFObject objectWithClassName:@"Shift"];
    newShift[@"startDate"] = startDate.date;
    newShift[@"endDate"] = endDate.date;
    newShift[@"name"] = currentUser[@"Name"];
    newShift[@"phone_number"] = currentUser[@"phone_number"];
    newShift[@"dorm"] = currentUser[@"dorm"];
    [newShift saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            UITabBarController* tabBar = (UITabBarController*) self.view.window.rootViewController;
            KalViewController* calendar = ((UINavigationController*)(tabBar.viewControllers[1])).viewControllers[0];
           
            [calendar reloadData];
            
        }
        else
        {
            @throw error;
        }
    }];
    
    
    //[calendar reloadData];
             
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (void) setDate:(NSDate*) date
{
    if([startDate.date compare:date] == NSOrderedAscending)   //startDate.date < date
    {
        startDate.date = date;
        endDate.date = date; //maybe set this to like 5 minute later

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
