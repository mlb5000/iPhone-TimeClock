//
//  AddClientViewController.m
//  TimeClock
//
//  Created by Matthew Baker on 10/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddClientViewController.h"

@implementation AddClientViewController

@synthesize client, delegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"New Client";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																						   target:self action:@selector(cancel:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																							target:self action:@selector(save:)] autorelease];
	
	// Set up the undo manager and set editing state to YES.
	[self setUpUndoManager];
	self.editing = YES;
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
	[super viewDidUnload];
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	[self cleanUpUndoManager];	
}

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)cancel:(id)sender {
	[delegate addClientViewController:self didFinishWithSave:NO];
}

- (IBAction)save:(id)sender {
	[delegate addClientViewController:self didFinishWithSave:YES];
}

- (void)dealloc {
    [super dealloc];
}


@end
