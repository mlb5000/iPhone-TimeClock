//
//  Client.h
//  TimeClock
//
//  Created by Matthew Baker on 10/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TimeEntry;

@interface Client :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * pocName;
@property (nonatomic, retain) NSString * pocPhone;
@property (nonatomic, retain) NSSet *entries;

@end

@interface Client (CoreDataGeneratedAccessors)
- (void)addEntriesObject:(TimeEntry *)value;
- (void)removeEntriesObject:(TimeEntry *)value;
- (void)addEntries:(NSSet *)value;
- (void)removeEntries:(NSSet *)value;

@end



