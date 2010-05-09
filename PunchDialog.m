//
//  PunchDialog.m
//  TimeClock
//
//  Created by Matthew Baker on 10/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PunchDialog.h"


@implementation PunchDialog

@synthesize timeEntry, overtimeLabel, overtimeSwitch, breakButton, shiftButton, delegate;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (IBAction)shiftPunch {
	if (!overtimeSwitch.hidden) self.timeEntry.isOvertime = [NSNumber numberWithBool:overtimeSwitch.isOn];
	[self.timeEntry punchDay];
	[delegate punchDialogViewController:self didFinishWithCancel:NO];
}

- (IBAction)breakPunch {
	[self.timeEntry punchBreak:delegate.managedObjectContext];
	[delegate punchDialogViewController:self didFinishWithCancel:NO];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];	
	
	[self displayControls];
	[self setBreakButtonText];
	[self setShiftButtonText];
}

- (void)displayControls {
	//only display overtimeSwitch, and overtimeLabel if it is a new entry
	self.overtimeSwitch.hidden = self.timeEntry.currentState != TimeEntryStateNewEntry;
	self.overtimeLabel.hidden = self.overtimeSwitch.hidden;
	
	//only display break button when they are punched into a shift currently
	self.breakButton.hidden = (self.timeEntry.currentState != TimeEntryStateShiftBegun &&
						  self.timeEntry.currentState != TimeEntryStateBreakBegun &&
						  self.timeEntry.currentState != TimeEntryStateBreakEnded);
}

- (void)setBreakButtonText {
	switch (self.timeEntry.currentState) {
		case TimeEntryStateShiftBegun:
		case TimeEntryStateBreakEnded:
			[self.breakButton setTitle:@"Start Break" forState:UIControlStateNormal];
			break;
		case TimeEntryStateBreakBegun:
			[self.breakButton setTitle:@"End Break" forState:UIControlStateNormal];
			break;
		default:
			[self.breakButton setTitle:@"Error!" forState:UIControlStateNormal];
			break;
	}
}

- (void)setShiftButtonText {
	switch (self.timeEntry.currentState) {
		case TimeEntryStateNewEntry:
			[self.shiftButton setTitle:@"Begin Shift" forState:UIControlStateNormal];
			break;
		case TimeEntryStateBreakBegun:
		case TimeEntryStateBreakEnded:
		case TimeEntryStateShiftBegun:
			[self.shiftButton setTitle:@"End Shift" forState:UIControlStateNormal];
			break;
		default:
			[self.shiftButton setTitle:@"Error!" forState:UIControlStateNormal];
			break;
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction)cancel:(id)sender {
	[delegate punchDialogViewController:self didFinishWithCancel:YES];
}

- (void)dealloc {
    [super dealloc];
	[timeEntry release];
	[overtimeLabel release];
	[overtimeSwitch release];
	[breakButton release];
	[shiftButton release];
}


@end
