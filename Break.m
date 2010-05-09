// 
//  Break.m
//  TimeClock
//
//  Created by Matthew Baker on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Break.h"


@implementation Break 

@dynamic outTime;
@dynamic inTime;

- (void)startBreak {
	self.inTime = [NSDate date];
}

- (void)endBreak {
	self.outTime = [NSDate date];
}

@end
