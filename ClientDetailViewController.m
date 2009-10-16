//
//  ClientDetailViewController.m
//  TimeClock
//
//  Created by Matthew Baker on 10/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ClientDetailViewController.h"
#import "EditingViewController.h"
#import "TimeEntry.h"

@implementation ClientDetailViewController

@synthesize client, dateFormatter, undoManager;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Configure the title, title bar, and table view.
	self.title = @"Info";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.tableView.allowsSelectionDuringEditing = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data.
    [self.tableView reloadData];
	[self updateRightBarButtonItemState];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
	// Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    [self.tableView reloadData];
	
	/*
	 When editing starts, create and set an undo manager to track edits. Then register as an observer of undo manager change notifications, so that if an undo or redo operation is performed, the table view can be reloaded.
	 When editing ends, de-register from the notification center and remove the undo manager, and save the changes.
	 */
	if (editing) {
		[self setUpUndoManager];
	}
	else {
		[self cleanUpUndoManager];
		// Save the changes.
		NSError *error;
		if (![client.managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
	}
}


- (void)viewDidUnload {
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	self.dateFormatter = nil;
}


- (void)updateRightBarButtonItemState {
	// Conditionally enable the right bar button item -- it should only be enabled if the book is in a valid state for saving.
    self.navigationItem.rightBarButtonItem.enabled = [client validateForUpdate:NULL];
}	


#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([client.entries count] > 0) return 2;
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 4 rows
	if (section == 0)
		return 4;
	return [client.entries count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) return @"Details";
	return @"Shifts";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"Index path row: %d", indexPath.row); 
	switch (indexPath.section) {
		case 0:
			return [self configureDetailsCell:tableView atIndexPath:indexPath];
			break;
		case 1:
			return [self configureTimeCell:tableView atIndexPath:indexPath];
			break;
		default:
			break;
	}
	
	return nil;
}

- (UITableViewCell *)configureDetailsCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {	
	static NSString *CellIdentifier = @"DetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	switch (indexPath.row) {
		case 0: 
			cell.textLabel.text = @"Name";
			cell.detailTextLabel.text = client.name;
			break;
		case 1: 
			cell.textLabel.text = @"Rate";
			cell.detailTextLabel.text = client.rate == nil ? @"" : [NSString stringWithFormat:@"$%@", client.rate];
			break;
		case 2:
			cell.textLabel.text = @"POC Name";
			cell.detailTextLabel.text = client.pocName;
			break;
		case 3:
			cell.textLabel.text = @"POC Phone";
			cell.detailTextLabel.text = client.pocPhone;
			break;		
		default:			
			break;
	}
	
    return cell;
}

- (UITableViewCell *)configureTimeCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"TimeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	// A date formatter for the time stamp
    NSDateFormatter *shortDate = [[NSDateFormatter alloc] init];
        [shortDate setTimeStyle:NSDateFormatterMediumStyle];
        [shortDate setDateStyle:NSDateFormatterShortStyle];
	
    // A number formatter for the latitude and longitude	
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:2];
	
	TimeEntry *entry = [[client.entries allObjects] objectAtIndex:indexPath.row];
	
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@", 
						   [shortDate stringFromDate:[entry inTime]],
						   [entry outTime] == nil ? @"" : [shortDate stringFromDate:[entry outTime]]];
    NSString *string = [NSString stringWithFormat:@"%@, %@hrs",
						entry.client.name,
						[numberFormatter stringFromNumber:[entry totalTime]]];
    cell.detailTextLabel.text = string;
	
	[numberFormatter release];
	[shortDate release];
	
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing or if you select the POC Phone cell
    return (self.editing || (indexPath.row == 3 && indexPath.section == 0)) ? indexPath : nil;
}

/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Cell selected");
	if (!self.editing) {
		if (indexPath.section == 0 && indexPath.row == 3) {
			NSString *number = [NSString stringWithFormat:@"tel://%@", client.pocPhone];
			NSLog(@"Calling %@", number);
			BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
			NSLog(@"Success: %d", success);
			[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
		return;
	}
	
    EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
    
    controller.editedObject = client;
    switch (indexPath.row) {
        case 0: {
            controller.editedFieldKey = @"name";
            controller.editedFieldName = NSLocalizedString(@"clientName", @"display name for client");
            controller.editType = EditingViewControllerTypeString;
        } break;
        case 1: {
            controller.editedFieldKey = @"rate";
			controller.editedFieldName = NSLocalizedString(@"clientRate", @"rate for client");
			controller.editType = EditingViewControllerTypeDouble;
        } break;
        case 2: {
            controller.editedFieldKey = @"pocName";
			controller.editedFieldName = NSLocalizedString(@"pocName", @"display name for POC");
			controller.editType = EditingViewControllerTypeString;
        } break;
		case 3: {
			controller.editedFieldKey = @"pocPhone";
			controller.editedFieldName = NSLocalizedString(@"pocPhone", @"display POC phone number");
			controller.editType = EditingViewControllerTypePhone;
		}
    }
	
    [self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}


#pragma mark -
#pragma mark Undo support

- (void)setUpUndoManager {
	/*
	 If the client's managed object context doesn't already have an undo manager, then create one and set it for the context and self.
	 The view controller needs to keep a reference to the undo manager it creates so that it can determine whether to remove the undo manager when editing finishes.
	 */
	if (client.managedObjectContext.undoManager == nil) {
		
		NSUndoManager *anUndoManager = [[NSUndoManager alloc] init];
		[anUndoManager setLevelsOfUndo:3];
		self.undoManager = anUndoManager;
		[anUndoManager release];
		
		client.managedObjectContext.undoManager = undoManager;
	}
	
	// Register as an observer of the client's context's undo manager.
	NSUndoManager *clientUndoManager = client.managedObjectContext.undoManager;
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:clientUndoManager];
	[dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:clientUndoManager];
}


- (void)cleanUpUndoManager {
	
	// Remove self as an observer.
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if (client.managedObjectContext.undoManager == undoManager) {
		client.managedObjectContext.undoManager = nil;
		self.undoManager = nil;
	}		
}


- (NSUndoManager *)undoManager {
	return client.managedObjectContext.undoManager;
}


- (void)undoManagerDidUndo:(NSNotification *)notification {
	[self.tableView reloadData];
	[self updateRightBarButtonItemState];
}


- (void)undoManagerDidRedo:(NSNotification *)notification {
	[self.tableView reloadData];
	[self updateRightBarButtonItemState];
}


/*
 The view controller must be first responder in order to be able to receive shake events for undo. It should resign first responder status when it disappears.
 */
- (BOOL)canBecomeFirstResponder {
	return YES;
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self resignFirstResponder];
}


#pragma mark -
#pragma mark Date Formatter

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [undoManager release];
    [dateFormatter release];
    [client release];
    [super dealloc];
}

@end

