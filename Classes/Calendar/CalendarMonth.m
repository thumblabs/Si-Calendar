//
//  CalendarMonth.m
//  Calendar
//
//  Created by Lloyd Bottomley on 29/04/10.
//  Copyright 2010 Savage Media Pty Ltd. All rights reserved.
//

#import "CalendarMonth.h"

#import "CalendarLogic.h"


#define kCalendarDayWidth	46.0f
#define kCalendarDayHeight	44.0f


@implementation CalendarMonth


#pragma mark -
#pragma mark Getters / setters

@synthesize calendarLogic;
@synthesize datesIndex;
@synthesize buttonsIndex;

@synthesize numberOfDaysInWeek;



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	calendarLogic = nil;
	self.datesIndex = nil;
	self.buttonsIndex = nil;
	
    [super dealloc];
}



#pragma mark -
#pragma mark Initialization

// Calendar object init
- (id)initWithFrame:(CGRect)frame logic:(CalendarLogic *)aLogic {
	
	// Size is static
	NSInteger numberOfWeeks = 5;
	frame.size.width = 320;
	frame.size.height = ((numberOfWeeks + 1) * kCalendarDayHeight) + 60;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];	
	NSDate *todayDate = [calendar dateFromComponents:components];
	
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor redColor]; // Red should show up fails.
		self.opaque = YES;
		self.clipsToBounds = NO;
		self.clearsContextBeforeDrawing = NO;
		
		UIImageView *headerBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CalendarBackground.png"]] autorelease];
		[headerBackground setFrame:CGRectMake(0, 0, 320, 60)];
		[self addSubview:headerBackground];
		
		UIImageView *calendarBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CalendarBackground.png"]] autorelease];
		[calendarBackground setFrame:CGRectMake(0, 60, 320, (numberOfWeeks + 1) * kCalendarDayHeight)];
		[self addSubview:calendarBackground];
		
		
		
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
		NSArray *daySymbols = [formatter shortWeekdaySymbols];
		self.numberOfDaysInWeek = [daySymbols count];
		
		
		UILabel *aLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
		aLabel.backgroundColor = [UIColor clearColor];
		aLabel.textAlignment = UITextAlignmentCenter;
		aLabel.font = [UIFont boldSystemFontOfSize:20];
		aLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarTitleColor.png"]];
		aLabel.shadowColor = [UIColor whiteColor];
		aLabel.shadowOffset = CGSizeMake(0, 1);
		
		[formatter setDateFormat:@"MMMM yyyy"];
		aLabel.text = [formatter stringFromDate:aLogic.referenceDate];
		[self addSubview:aLabel];
		
		
		UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, 59, 320, 1)] autorelease];
		lineView.backgroundColor = [UIColor lightGrayColor];
		[self addSubview:lineView];
		
		
		// Setup weekday names
		NSInteger firstWeekday = [calendar firstWeekday] - 1;
		for (NSInteger aWeekday = 0; aWeekday < numberOfDaysInWeek; aWeekday ++) {
 			NSInteger symbolIndex = aWeekday + firstWeekday;
			if (symbolIndex >= numberOfDaysInWeek) {
				symbolIndex -= numberOfDaysInWeek;
			}
			
			NSString *symbol = [daySymbols objectAtIndex:symbolIndex];
			CGFloat positionX = (aWeekday * kCalendarDayWidth) - 1;
			CGRect aFrame = CGRectMake(positionX, 40, kCalendarDayWidth, 20);
			
			aLabel = [[[UILabel alloc] initWithFrame:aFrame] autorelease];
			aLabel.backgroundColor = [UIColor clearColor];
			aLabel.textAlignment = UITextAlignmentCenter;
			aLabel.text = symbol;
			aLabel.textColor = [UIColor darkGrayColor];
			aLabel.font = [UIFont systemFontOfSize:12];
			aLabel.shadowColor = [UIColor whiteColor];
			aLabel.shadowOffset = CGSizeMake(0, 1);
			[self addSubview:aLabel];
		}
		
		// Build calendar buttons (6 weeks of 7 days)
		NSMutableArray *aDatesIndex = [[[NSMutableArray alloc] init] autorelease];
		NSMutableArray *aButtonsIndex = [[[NSMutableArray alloc] init] autorelease];
		
		for (NSInteger aWeek = 0; aWeek <= numberOfWeeks; aWeek ++) {
			CGFloat positionY = (aWeek * kCalendarDayHeight) + 60;
			
			for (NSInteger aWeekday = 1; aWeekday <= numberOfDaysInWeek; aWeekday ++) {
				CGFloat positionX = ((aWeekday - 1) * kCalendarDayWidth) - 1;
				CGRect dayFrame = CGRectMake(positionX, positionY, kCalendarDayWidth, kCalendarDayHeight);
				NSDate *dayDate = [CalendarLogic dateForWeekday:aWeekday 
														 onWeek:aWeek 
												  referenceDate:[aLogic referenceDate]];
				NSDateComponents *dayComponents = [calendar 
												   components:NSDayCalendarUnit fromDate:dayDate];
				
				UIColor *titleColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarTitleColor.png"]];
				if ([aLogic distanceOfDateFromCurrentMonth:dayDate] != 0) {
					titleColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarTitleDimColor.png"]];
				}
				
				UIButton *dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
				dayButton.opaque = YES;
				dayButton.clipsToBounds = NO;
				dayButton.clearsContextBeforeDrawing = NO;
				dayButton.frame = dayFrame;
				dayButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
				dayButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
				dayButton.tag = [aDatesIndex count];
				dayButton.adjustsImageWhenHighlighted = NO;
				dayButton.adjustsImageWhenDisabled = NO;
				dayButton.showsTouchWhenHighlighted = YES;
				
				
				// Normal
				[dayButton setTitle:[NSString stringWithFormat:@"%d", [dayComponents day]] 
						   forState:UIControlStateNormal];
				
				// Selected
				[dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
				[dayButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateSelected];
				
                // Disabled
                [dayButton setTitleColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarTitleDimColor.png"]] colorWithAlphaComponent:0.5]
                                forState:UIControlStateDisabled];
                [dayButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                
                if ([aLogic isDateDisabled:dayDate]) {
                    [dayButton setEnabled:NO];
                }
                else if ([aLogic.selectedDate timeIntervalSince1970] == [dayDate timeIntervalSince1970]) {
                    [dayButton setSelected:YES];
                    
                    CGRect selectedFrame = dayButton.frame;
                    if ([dayDate compare:todayDate] != NSOrderedSame) {
                        selectedFrame.origin.y = selectedFrame.origin.y - 1;
                        selectedFrame.size.width = kCalendarDayWidth + 1;
                        selectedFrame.size.height = kCalendarDayHeight + 1;
                    }
                    
                    dayButton.selected = YES;
                    dayButton.frame = selectedFrame;
                    [self bringSubviewToFront:dayButton];
                }
                if ([aLogic isDateHighlighted:dayDate]) {
                    if ([dayButton isEnabled]) {
                        [dayButton setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1]];
                    }
                    else {
                        [dayButton setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.05]];
                    }
                }
                if (aLogic.rangeButtonDates) {
                    for (NSDate *date in aLogic.rangeButtonDates) {
                        if ([date timeIntervalSince1970] == [dayDate timeIntervalSince1970]) {
                            if ([aLogic isDateHighlighted:dayDate]) {
                                [dayButton setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:161.0f/255.0f blue:237.0f/255.0f alpha:0.6]];
                            }
                            else {
                                [dayButton setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:161.0f/255.0f blue:237.0f/255.0f alpha:0.4]];
                            }
                        }
                    }
                }
				
                if ([dayDate compare:todayDate] != NSOrderedSame) {
                    // Normal
                    [dayButton setTitleColor:titleColor forState:UIControlStateNormal];
                    [dayButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [dayButton setBackgroundImage:[UIImage imageNamed:@"CalendarDayTile.png"] forState:UIControlStateNormal];
                    
                    // Selected
                    [dayButton setBackgroundImage:[UIImage imageNamed:@"CalendarDaySelected.png"] forState:UIControlStateSelected];
				}
                else {
					// Normal
					[dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
					[dayButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
					[dayButton setBackgroundImage:[UIImage imageNamed:@"CalendarDayToday.png"] forState:UIControlStateNormal];
					
					// Selected
					[dayButton setBackgroundImage:[UIImage imageNamed:@"CalendarDayTodaySelected.png"] forState:UIControlStateSelected];
				}

				
				[dayButton addTarget:self action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
				[self addSubview:dayButton];
				
				// Save
				[aDatesIndex addObject:dayDate];
				[aButtonsIndex addObject:dayButton];
			}
		}
		
		// save
		calendarLogic = aLogic;
		self.datesIndex = [[aDatesIndex copy] autorelease];
		self.buttonsIndex = [[aButtonsIndex copy] autorelease];
    }
    return self;
}



#pragma mark -
#pragma mark UI Controls

- (void)dayButtonPressed:(id)sender {
	[calendarLogic setReferenceDate:[datesIndex objectAtIndex:[sender tag]]];
}
- (void)selectButtonForDate:(NSDate *)aDate {
    
    if (calendarLogic.selectedDate) {
            
        NSInteger selectedButtonIndex;
        
        NSInteger monthOffset = [calendarLogic distanceOfDateFromCurrentMonth:calendarLogic.selectedDate];
        
        if (monthOffset > 0) {
            NSInteger lastDayIndex = [calendarLogic indexOfLastDateInCurrentMonth:aDate];
            selectedButtonIndex = lastDayIndex + monthOffset;
        }
        else if (monthOffset < 0) {
            NSInteger firstDayIndex = [calendarLogic indexOfFirstDateInCurrentMonth:aDate];
            selectedButtonIndex = firstDayIndex + monthOffset;
        }
        else {
            selectedButtonIndex = [calendarLogic indexOfCalendarDate:calendarLogic.selectedDate];
        }
        
        if (selectedButtonIndex >= 0 && selectedButtonIndex < [buttonsIndex count]) {
            
            NSDate *todayDate = [CalendarLogic dateForToday];
            UIButton *button = [buttonsIndex objectAtIndex:selectedButtonIndex];
            
            CGRect selectedFrame = button.frame;
            if ([calendarLogic.selectedDate compare:todayDate] != NSOrderedSame) {
                selectedFrame.origin.y = selectedFrame.origin.y + 1;
                selectedFrame.size.width = kCalendarDayWidth;
                selectedFrame.size.height = kCalendarDayHeight;
            }
            
            button.selected = NO;
            button.frame = selectedFrame;
        }
        
        calendarLogic.selectedDate = nil;
    }
    
	if (aDate != nil) {
		// Save
		calendarLogic.selectedDate = aDate;
		
        NSInteger selectedButtonIndex;
        
        NSInteger monthOffset = [calendarLogic distanceOfDateFromCurrentMonth:calendarLogic.selectedDate];
        if (monthOffset > 0) {
            NSInteger lastDayIndex = [calendarLogic indexOfLastDateInCurrentMonth:calendarLogic.referenceDate];
            selectedButtonIndex = lastDayIndex + monthOffset;
        }
        else {
            selectedButtonIndex = [calendarLogic indexOfCalendarDate:calendarLogic.selectedDate];
        }
        
        if (selectedButtonIndex >= 0 && selectedButtonIndex < [buttonsIndex count]) {
            UIButton *button = [buttonsIndex objectAtIndex:selectedButtonIndex];
            
            NSDate *todayDate = [CalendarLogic dateForToday];
            CGRect selectedFrame = button.frame;
            if ([aDate compare:todayDate] != NSOrderedSame) {
                selectedFrame.origin.y = selectedFrame.origin.y - 1;
                selectedFrame.size.width = kCalendarDayWidth + 1;
                selectedFrame.size.height = kCalendarDayHeight + 1;
            }
            
            button.selected = YES;
            button.frame = selectedFrame;
            [self bringSubviewToFront:button];
        }
	}
}
- (void)selectButtonsInRangeStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    if (calendarLogic.rangeButtonDates) {
        
        //deselect all selected
        for (NSDate *rangeButtonDate in calendarLogic.rangeButtonDates) {
            
            NSInteger rangeButtonIndex;
            
            NSInteger monthOffset = [calendarLogic distanceOfDateFromCurrentMonth:rangeButtonDate];
            if (monthOffset < 0) {
                NSInteger firstDayIndex = [calendarLogic indexOfFirstDateInCurrentMonth:calendarLogic.referenceDate];
                rangeButtonIndex = firstDayIndex + monthOffset;
            }
            else if (monthOffset > 0) {
                NSInteger lastDayIndex = [calendarLogic indexOfLastDateInCurrentMonth:calendarLogic.referenceDate];
                rangeButtonIndex = lastDayIndex + monthOffset;
            }
            else {
                rangeButtonIndex = [calendarLogic indexOfCalendarDate:rangeButtonDate];
            }
            
            if (rangeButtonIndex >= 0 && rangeButtonIndex < [buttonsIndex count]) {
                UIButton *button = [buttonsIndex objectAtIndex:rangeButtonIndex];
                
                if ([calendarLogic isDateHighlighted:rangeButtonDate]) {
                    [button setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2]];
                }
                else {
                    [button setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
        
        calendarLogic.rangeButtonDates = nil;
    }
    
    NSMutableArray *rangeButtonDates = [NSMutableArray new];
    
    NSDate *currentDate = startDate;
    while ([currentDate timeIntervalSince1970] < [endDate timeIntervalSince1970]) {
        
        NSInteger rangeButtonIndex;
        
        NSInteger monthOffset = [calendarLogic distanceOfDateFromCurrentMonth:currentDate];
        if (monthOffset < 0) {
            NSInteger firstDayIndex = [calendarLogic indexOfFirstDateInCurrentMonth:calendarLogic.referenceDate];
            rangeButtonIndex = firstDayIndex + monthOffset;
        }
        else {
            rangeButtonIndex = [calendarLogic indexOfCalendarDate:currentDate];
        }
        
        if (rangeButtonIndex >= 0 && rangeButtonIndex < [buttonsIndex count]) {
            UIButton *button = [buttonsIndex objectAtIndex:rangeButtonIndex];
            
            if ([calendarLogic isDateHighlighted:currentDate]) {
                [button setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:161.0f/255.0f blue:237.0f/255.0f alpha:0.6]];
            }
            else {
                [button setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:161.0f/255.0f blue:237.0f/255.0f alpha:0.4]];
            }
        }
        
        [rangeButtonDates addObject:currentDate];
        
        currentDate = [currentDate dateByAddingTimeInterval:60*60*24]; //add 1 day
    }
    
    calendarLogic.rangeButtonDates = rangeButtonDates;
}


@end
