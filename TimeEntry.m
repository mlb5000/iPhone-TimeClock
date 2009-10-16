// 
//  TimeEntry.m
//  TimeClock
//
//  Created by Matthew Baker on 10/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimeEntry.h"

#import "Break.h"
#import "Client.h"

@implementation TimeEntry 

@dynamic notes;
@dynamic outTime;
@dynamic inTime;
@dynamic client;
@dynamic breaks;
@dynamic isOvertime;

- (NSNumber *)totalTime {
	NSDate *endTime = self.outTime == nil ? [NSDate date] : self.outTime;
	return [NSNumber numberWithDouble:[endTime timeIntervalSinceDate:self.inTime]/3600];
}

- (void)punchDay {	
	switch (self.currentState) {
		case TimeEntryStateNewEntry:
			self.inTime = [NSDate date];
			break;
		case TimeEntryStateShiftBegun:
			self.outTime = [NSDate date];
			break;
		default:
			//change no state since this entry is closed
			break;
	}
}

- (void)punchBreak {	
	switch (self.currentState) {
		case TimeEntryStateShiftBegun:
			//start new break entry
			break;
		case TimeEntryStateBreakBegun:
			//end break entry
			break;
		default:
			//do nothing
			break;
	}
}

- (TimeEntryState)currentState {
	if (self.inTime == nil) return TimeEntryStateNewEntry;
	if ([self.breaks count] > 0) {
		
	}
	if (self.outTime == nil) return TimeEntryStateShiftBegun;
	return TimeEntryStateShiftEnded;
}

@end
