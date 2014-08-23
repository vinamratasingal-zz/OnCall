//
//  MyKalDataSource.h
//  OnCall
//
//  Created by Michael Fang on 8/18/14. Mostly taken from EventKitDataSource from the NativeCal sample app. 
//  Copyright (c) 2014 Team OnCall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kal.h"

@interface MyKalDataSource : NSObject <KalDataSource>
{
    NSMutableDictionary *eventsInMonth;            // An array corresponding to the collection of dates shown, with each      element at index i being a list of events for day i
    
    NSArray *eventsOnSelectedDay;
    
    NSMutableArray *markedDays;
}


@end
