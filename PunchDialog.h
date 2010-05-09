//
//  PunchDialog.h
//  TimeClock
//
//  Created by Matthew Baker on 10/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "TimeEntry.h"

@protocol PunchDialogDelegate;

@interface PunchDialog : UIViewController {
	IBOutlet UISwitch *overtimeSwitch;
	IBOutlet UILabel *overtimeLabel;
	IBOutlet UIButton *breakButton;
	IBOutlet UIButton *shiftButton;
	TimeEntry *timeEntry;
	id <PunchDialogDelegate> delegate;
}

@property (nonatomic, retain) TimeEntry *timeEntry;
@property (nonatomic, retain) UISwitch *overtimeSwitch;
@property (nonatomic, retain) UILabel *overtimeLabel;
@property (nonatomic, retain) UIButton *breakButton;
@property (nonatomic, retain) UIButton *shiftButton;
@property (nonatomic, assign) id <PunchDialogDelegate> delegate;

- (IBAction)breakPunch;
- (IBAction)shiftPunch;

- (IBAction)cancel:(id)sender;
- (void)displayControls;
- (void)setShiftButtonText;
- (void)setBreakButtonText;

@end

@protocol PunchDialogDelegate
- (void)punchDialogViewController:(PunchDialog *)controller didFinishWithCancel:(BOOL)cancel;
- (NSManagedObjectContext *)managedObjectContext;
@end