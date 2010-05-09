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
		case TimeEntryStateBreakBegun:
		case TimeEntryStateBreakEnded:
			self.outTime = [NSDate date];
			break;
		default:
			//change no state since this entry is closed
			break;
	}
}

- (void)punchBreak:(NSManagedObjectContext *)managedObjectContext {	
	Break *breakEntry = nil;
	switch (self.currentState) {
		case TimeEntryStateShiftBegun:
		case TimeEntryStateBreakEnded:
			//start new break entry
			breakEntry = (Break *)[NSEntityDescription insertNewObjectForEntityForName:@"Break" inManagedObjectContext:managedObjectContext];
			[breakEntry startBreak];
			[self addBreaksObject:breakEntry];
			break;
		case TimeEntryStateBreakBegun:
			breakEntry = (Break *)[[self.breaks allObjects] objectAtIndex:0];
			[breakEntry endBreak];
			break;
		default:
			//do nothing
			return;
	}
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
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
