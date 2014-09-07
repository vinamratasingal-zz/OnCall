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
{
    int numRecurrences;
}
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
    numRecurrences = 1;
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
//TODO: separate out functions like this into a calendar utility file
-(NSDate *) getNextWeekFrom: (NSDate*) date
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init] ;
    dayComponent.day = 7;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    return [theCalendar dateByAddingComponents:dayComponent toDate:date options:0];

}

-(void) saveAllShifts
{
    NSLog(@"saveallshiftscalled");
    PFUser *currentUser = [PFUser currentUser];
    
    
    NSDate * currStartDate = startDate.date;
    NSDate *currEndDate = endDate.date;
    NSMutableArray *shifts = [NSMutableArray arrayWithCapacity:numRecurrences];
    for(int i = 0; i < numRecurrences; i++)
    {
        PFObject *newShift = [PFObject objectWithClassName:@"Shift"];
        newShift[@"startDate"] = currStartDate;
        newShift[@"endDate"] = currEndDate;
        newShift[@"name"] = currentUser[@"Name"];
        newShift[@"phone_number"] = currentUser[@"phone_number"];
        newShift[@"dorm"] = currentUser[@"dorm"];
        
        currStartDate = [self getNextWeekFrom:currStartDate];
        currEndDate = [self getNextWeekFrom:currEndDate];
        [shifts addObject:newShift];
    }
    [PFObject saveAllInBackground:shifts block:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            //NSLog(@"block called");
            
            //as opposed to self.view.window.rootViewController
            UITabBarController* tabBar = (UITabBarController*) [[UIApplication sharedApplication] keyWindow].rootViewController;
            
            //safeish way to do it. Hopefully no other views will be navcontrollers as well
            //This is based on the assumption that we keep the viewcontroller hierarchy as-is.
            BOOL onlyOne = true;
            //NSLog(@"Num viewcontrollers: %d", [tabBar.viewControllers count]);
            for(UIViewController *vc in tabBar.viewControllers)
            {
                //NSLog(@"%s",[NSStringFromClass([vc class]) UTF8String]);
                if([vc isKindOfClass:[UINavigationController class]])
                {
                    
                    //NSLog(@"checkpoint ");
                    assert(onlyOne); //will fail if we have more than one vc in the tabbar that is a navigation controller
                    KalViewController* calendar = ((UINavigationController*)vc).viewControllers[0];
                    [calendar reloadData];
                    onlyOne = false;
                }
            }
        }
        else
        {
            @throw error;
        }
    }];
}

-(IBAction)submitAction:(id)sender {
    
    //validate valid range
    
    //add event to parse
    
    
    
    [self saveAllShifts];
    
    
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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    if ([segue.identifier isEqualToString:@"recurrSegue"]) {
        PickRecurringViewController *prvc = (PickRecurringViewController *)segue.destinationViewController;
        prvc.delegate = self;
    }
}
-(void) setNumRecurrences:(int) numRecurrence
{
    numRecurrences = numRecurrence + 1;
}

@end
