//
//  CalendarLogic.h
//  Calendar
//
//  Created by Lloyd Bottomley on 29/04/10.
//  Copyright 2010 Savage Media Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CalendarLogicDelegate.h"

@interface CalendarLogic : NSObject {
	id <CalendarLogicDelegate> calendarLogicDelegate;
	NSDate *referenceDate;
}

@property (nonatomic, assign) id <CalendarLogicDelegate> calendarLogicDelegate;
@property (nonatomic, retain) NSDate *referenceDate;
@property (nonatomic, retain) NSDate *selectedDate;

@property (nonatomic, retain) NSDate *minimumDate;
@property (nonatomic, retain) NSDate *maximumDate;
@property (nonatomic, retain) NSArray *extraHighlightedDates;
@property (nonatomic, retain) NSArray *extraDisabledDates;
@property (nonatomic, retain) NSArray *rangeButtonDates;

- (id)initWithDelegate:(id <CalendarLogicDelegate>)aDelegate referenceDate:(NSDate *)aDate;

+ (NSDate *)dateForToday;
+ (NSDate *)dateForWeekday:(NSInteger)aWeekday 
					onWeek:(NSInteger)aWeek 
				   ofMonth:(NSInteger)aMonth 
					ofYear:(NSInteger)aYear;
+ (NSDate *)dateForWeekday:(NSInteger)aWeekday onWeek:(NSInteger)aWeek referenceDate:(NSDate *)aReferenceDate;

- (NSInteger)indexOfCalendarDate:(NSDate *)aDate;
- (NSInteger)distanceOfDateFromCurrentMonth:(NSDate *)aDate;

- (void)selectPreviousMonth;
- (void)selectNextMonth;

- (NSInteger)indexOfLastDateInCurrentMonth:(NSDate *)aDate;
- (NSInteger)indexOfFirstDateInCurrentMonth:(NSDate *)aDate;
- (BOOL)isDateHighlighted:(NSDate *)date;
- (BOOL)isDateDisabled:(NSDate *)date;

@end
