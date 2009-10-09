//
//  Client.h
//  TimeClock
//
//  Created by Matthew Baker on 10/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class POC;

@interface Client :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) POC * poc;

@end



