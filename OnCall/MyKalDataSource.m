//
//  MyKalDataSource.m
//  OnCall
//  
//  Current task: be able to add a task to the calendar, show a detailed view of a day.
//
//  Created by Michael Fang on 8/18/14.
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import "MyKalDataSource.h"
#import <EventKit/EventKit.h>
#import <Parse/Parse.h>

@implementation MyKalDataSource

- (id)init
{
    if ((self = [super init])) {
        
    }
    return self;
}


//Theses controls the table cells displayed at the bottom of a page for a day.
#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    
    //EKEvent *event = [self eventAtIndexPath:indexPath];
    NSString * name = eventsOnSelectedDay[indexPath.row][@"name"];
    NSDate *startDate = eventsOnSelectedDay[indexPath.row] [@"startDate"];
    NSString * startDateString = [self timeStringFromDate:startDate];
    NSDate *endDate = eventsOnSelectedDay[indexPath.row] [@"endDate"];
    NSString *endDateString = [self timeStringFromDate:endDate];
    NSMutableString *text = [NSMutableString stringWithCapacity: name.length + startDateString.length + endDateString.length];
    [text appendString:name];
    [text appendString:@": "];
    [text appendString:startDateString];
    [text appendString:@" - "];
    [text appendString:endDateString];
    cell.textLabel.numberOfLines = 0; // unlimited number of lines
    //[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    cell.textLabel.text = text;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventsOnSelectedDay count]; //testing
}

#pragma mark Date Manipulation functions


- (NSString*) timeStringFromDate: (NSDate*) date {
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"hh:mm a";
    return [timeFormatter stringFromDate: date];
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

//TODO: make sure this works
-(NSArray*) getDatesFromDate:(NSDate*)startDate toDate:(NSDate*)endDate
{
    NSInteger numDays = [self daysBetweenDate:startDate andDate:endDate];
    NSMutableArray * dates = [NSMutableArray arrayWithCapacity:numDays + 1];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    for(int i = 0; i <= numDays; i++)
    {
        //clunky way for adding days, then setting times to midnight (for Kal's sake)
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:i];
        NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:startDate options:0];
        NSDateComponents * comp = [gregorian components:( NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:nextDate];
        
        [comp setMinute:0];
        [comp setHour:0];
        
        [dates addObject:[gregorian dateFromComponents:comp]];
    }
    return dates;
}




#pragma mark KalDataSource protocol conformance

/**      This message will be sent to your dataSource whenever the calendar
*        switches to a different month. Your code should respond by
*        loading application data for the specified range of dates and sending the
*        loadedDataSource: callback message as soon as the appplication data
*        is ready and available in memory. If the lookup of your application
*        data is expensive, you should perform the lookup using an asynchronous
*        API (like NSURLConnection for web service resources) or in a background
*        thread.
*
*       What we want to do: get events from Parse (future schedule)
**/
- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    PFUser *currUser = [PFUser currentUser];
    if(currUser == nil) {
        [PFUser logOut];
        return; 
    }
    //query for all shifts with start OR end dates between fromDate and toDate
    PFQuery *queryStart = [PFQuery queryWithClassName:@"Shift"];
    [queryStart whereKey:@"startDate" greaterThanOrEqualTo:fromDate];
    [queryStart whereKey:@"startDate" lessThanOrEqualTo:toDate];
    [queryStart whereKey:@"dorm" equalTo:currUser[@"dorm"]];
    PFQuery *queryEnd = [PFQuery queryWithClassName:@"Shift"];
    [queryEnd whereKey:@"startDate" greaterThanOrEqualTo:fromDate];
    [queryEnd whereKey:@"startDate" lessThanOrEqualTo:toDate];
    [queryEnd whereKey:@"dorm" equalTo:currUser[@"dorm"]];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryStart, queryEnd]];
    [query orderByAscending:@"startDate"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *shiftList, NSError *error) {
        if (!error) {
            markedDays = [NSMutableArray arrayWithCapacity:[shiftList count]];
            // The find succeeded.
            NSLog(@"Successfully retrieved %d dates.", shiftList.count);
            // Do something with the found objects
            eventsInMonth = [[NSMutableDictionary alloc] init];
            
            for (PFObject *shift in shiftList) {
                //NSLog(@"%@", shift.objectId);
                NSArray *betweenDates = [self getDatesFromDate:shift[@"startDate"] toDate:shift[@"endDate"]];
                
                for(NSDate *date in betweenDates)
                {
                    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                                         dateStyle:NSDateFormatterShortStyle
                                                                         timeStyle:NSDateFormatterFullStyle];
                    if([eventsInMonth valueForKey:dateString] ==nil)
                    {
                        eventsInMonth[dateString] = [NSMutableArray arrayWithCapacity:1];
                    }
                    [eventsInMonth[dateString] addObject:shift];
                }
                
                [markedDays addObjectsFromArray:betweenDates];
            }
            
            [delegate loadedDataSource:self];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

/**
 This message will be sent to your dataSource immediately
 *        after you issue the loadedDataSource: callback message
 *        from the body of your presentingDatesFrom:to:delegate method.
 *        You should respond to this message by returning an array of NSDates
 *        for each day in the specified range which has associated application
 *        data.
 *
 *        If this message is received but the application data is not yet
 *        ready, your code should immediately return an empty NSArray.
 **/
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    return markedDays;
}
/**
 *        This message will be sent to your dataSource every time
 *        that the user taps a day on the calendar. You should respond
 *        to this message by updating the list from which you vend
 *        UITableViewCells.
 *
 *        If this message is received but the application data is not yet
 *        ready, your code should do nothing.
 *
 *          In our case: show the events for a single day.
 **/
- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSString* key = [NSDateFormatter localizedStringFromDate:fromDate
                                   dateStyle:NSDateFormatterShortStyle
                                   timeStyle:NSDateFormatterFullStyle];
    
    eventsOnSelectedDay = [NSArray arrayWithArray:eventsInMonth[key]];
    
}
/**
*    removeAllItems
*
*        This message will be sent before loadItemsFromDate:toDate
*        as well as any time that Kal wants to clear the table view
*        beneath the calendar (for example, when switching between months).
*        You should respond to this message by removing all objects
*        from the list from which you vend UITableViewCells.
**/
- (void)removeAllItems
{
    
}

@end
