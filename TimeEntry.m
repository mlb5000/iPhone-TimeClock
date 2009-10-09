// 
//  TimeEntry.m
//  TimeClock
//
//  Created by Matthew Baker on 10/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimeEntry.h"

#import "Client.h"

@implementation TimeEntry 

@dynamic notes;
@dynamic outTime;
@dynamic inTime;
@dynamic client;

- (NSNumber *)totalTime {
	return [NSNumber numberWithDouble:[self.outTime timeIntervalSinceDate:self.inTime]];
}

@end
