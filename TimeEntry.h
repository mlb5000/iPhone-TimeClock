//
//  TimeEntry.h
//  TimeClock
//
//  Created by Matthew Baker on 10/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Client;

@interface TimeEntry :  NSManagedObject  
{
}

- (NSNumber *)totalTime;

@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * outTime;
@property (nonatomic, retain) NSDate * inTime;
@property (nonatomic, retain) Client * client;

@end



