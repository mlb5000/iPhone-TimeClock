//
//  TimeEntry.h
//  TimeClock
//
//  Created by Matthew Baker on 10/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef enum {
	TimeEntryStateNewEntry,
	TimeEntryStateShiftBegun,
	TimeEntryStateShiftEnded,
	TimeEntryStateBreakBegun,
	TimeEntryStateBreakEnded
} TimeEntryState;

typedef enum {
	TimeEntryPunchTypeNewEntry,
	TimeEntryPunchTypeBeginDay,
	TimeEntryPunchTypeEndDay,
	TImeEntryPunchTypeBeginBreak,
	TimeEntryPunchTypeEndBreak,
	TimeEntryPunchTypeBeginOvertime,
	TimeEntryPunchTypeEndOvertime
} TimeEntryPunchType;

@class Break, Client;

@interface TimeEntry :  NSManagedObject  
{
}

- (NSNumber *)totalTime;
//forIsExplicitOvertime makes this entry time and a half from beginning to end
//overtime resulting from more than 40 hours in a week is calculated someplace else
- (void)punchDay;
- (void)punchBreak:(NSManagedObjectContext *)managedObjectContext;
 
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * outTime;
@property (nonatomic, retain) NSDate * inTime;
@property (nonatomic, retain) Client * client;
@property (nonatomic, retain) NSSet *breaks;
@property (nonatomic, retain) NSNumber * isOvertime;
@property (nonatomic, readonly) TimeEntryState currentState;

@end

@interface TimeEntry (CoreDataGeneratedAccessors)
- (void)addBreaksObject:(Break *)value;
- (void)removeBreaksObject:(Break *)value;
- (void)addBreaks:(NSSet *)value;
- (void)removeBreaks:(NSSet *)value;

@end



