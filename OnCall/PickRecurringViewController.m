//
//  PickRecurringViewController.m
//  OnCall
//
//  Barebones VC for selecting options - should add more

//  Created by Michael Fang on 9/5/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "PickRecurringViewController.h"

@interface PickRecurringViewController ()

@end

@implementation PickRecurringViewController

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
    [self.view setBackgroundColor:[UIColor clearColor]];

    // Do any additional setup after loading the view.
    _numRecurrence.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submit:(id)sender
{
    [self.delegate setNumRecurrences:[_numRecurrence.text intValue]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
