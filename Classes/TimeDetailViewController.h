//
//  TimeDetailViewController.h
//  TimeClock
//
//  Created by Matthew Baker on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeEntry.h"

@interface TimeDetailViewController : UITableViewController {
    TimeEntry *entry;
	NSDateFormatter *dateFormatter;
	NSUndoManager *undoManager;
}

@property (nonatomic, retain) TimeEntry *entry;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSUndoManager *undoManager;

- (void)setUpUndoManager;
- (void)cleanUpUndoManager;
- (void)updateRightBarButtonItemState;

@end
