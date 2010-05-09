//
//  Break.h
//  TimeClock
//
//  Created by Matthew Baker on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Break :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * outTime;
@property (nonatomic, retain) NSDate * inTime;

- (void)startBreak;
- (void)endBreak;

@end



