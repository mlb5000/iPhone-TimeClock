//
//  TimeListViewController.m
//  TimeClock
//
//  Created by Matthew Baker on 10/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimeListViewController.h"
#import "TimeDetailViewController.h"
#import "TimeEntry.h"
#import "Client.h"

#define PUNCH_IN @"Punch In"
#define PUNCH_OUT @"Punch Out"

@implementation TimeListViewController

@synthesize fetchedResultsController, managedObjectContext, addingManagedObjectContext, tableView, punchButton;

- (IBAction)punch:(id)sender {	
	if ([[fetchedResultsController fetchedObjects] count] > 0) {
		TimeEntry *timeToUpdate = (TimeEntry *)[[fetchedResultsController fetchedObjects] objectAtIndex:0];
		if (timeToUpdate.currentState == TimeEntryStateShiftBegun) {
			[self punchOut];
			return;
		}
	}
	
	[self punchIn];
}

- (void)punchOut {
	TimeEntry *timeToUpdate = (TimeEntry *)[[fetchedResultsController fetchedObjects] objectAtIndex:0];
	[timeToUpdate punchDay];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	[self.punchButton setTitle:PUNCH_IN forState:UIControlStateNormal];
}

- (void)punchIn {
	// Create a new managed object context for the time entry -- set its persistent store coordinator to the same as that from the fetched results controller's context.
	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	self.addingManagedObjectContext = addingContext;
	[addingContext release];
	
	[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
	
	TimeEntry *newTime = (TimeEntry *)[NSEntityDescription insertNewObjectForEntityForName:@"TimeEntry" inManagedObjectContext:self.addingManagedObjectContext];
	[newTime punchDay];
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(userPunchedIn:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
	
	NSError *error;
	if (![addingManagedObjectContext save:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
	
	// Release the adding managed object context.
	self.addingManagedObjectContext = nil;
	[self.punchButton setTitle:PUNCH_OUT forState:UIControlStateNormal];
}

- (void)userPunchedIn:(NSNotification *)saveNotification {
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
	[self resignFirstResponder];
	[super viewDidDisappear:animated];
}

- (void)viewWillAppear {
	[self.tableView reloadData];	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"TimeClock";
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(turnOnEditing)];

	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	[self initializePunchState];
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventTypeMotion && event.type == UIEventSubtypeMotionShake) {
		NSLog(@"%@ motionEnded", [NSDate date]);
		//[self punch:self];
	}
}

- (void)turnOnEditing {
	[self.navigationItem.rightBarButtonItem release];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(turnOffEditing)];
	[self.tableView setEditing:YES animated:YES];
}

- (void)turnOffEditing {
	[self.navigationItem.rightBarButtonItem release];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(turnOnEditing)];
	[self.tableView setEditing:NO animated:YES];
}

- (void)initializePunchState {
	if ([[fetchedResultsController fetchedObjects] count] > 0) {
		TimeEntry *lastEntry = (TimeEntry *)[[fetchedResultsController fetchedObjects] objectAtIndex:0];
		if (lastEntry.currentState == TimeEntryStateShiftBegun) {
			[self.punchButton setTitle:PUNCH_OUT forState:UIControlStateNormal];
			return;
		}
	}
	
	[self.punchButton setTitle:PUNCH_IN forState:UIControlStateNormal];	
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
	self.punchButton = nil;
	self.tableView = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureCell:cell atIndexPath:indexPath];	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Create and push a detail view controller.
	TimeDetailViewController *detailViewController = [[TimeDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    TimeEntry *selectedEntry = (TimeEntry *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    // Pass the selected entry to the new view controller.
    detailViewController.entry = selectedEntry;
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
}

 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	 // Return NO if you do not want the specified item to be editable.
	 return YES;
 }

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }   
}

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	 // Return NO if you do not want the item to be re-orderable.
	 return NO;
 }

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}


#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the TimeEntry entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeEntry" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *punchTimes = [[NSSortDescriptor alloc] initWithKey:@"inTime" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:punchTimes, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[punchTimes release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}  

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	// A date formatter for the time stamp
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
	
    // A number formatter for the latitude and longitude	
    static NSNumberFormatter *numberFormatter = nil;	
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:2];
    }
	
	TimeEntry *entry = [fetchedResultsController objectAtIndexPath:indexPath];
	
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@", 
						   [dateFormatter stringFromDate:[entry inTime]],
						   [entry outTime] == nil ? @"" : [dateFormatter stringFromDate:[entry outTime]]];
    NSString *string = [NSString stringWithFormat:@"%@, %@hrs",
						entry.client.name,
						[numberFormatter stringFromNumber:[entry totalTime]]];
    cell.detailTextLabel.text = string;
}


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	NSLog(@"didChangeObject called.");
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self initializePunchState];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			[self initializePunchState];
			break;
			
		case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			// Reloading the section inserts a new row and ensures that titles are updated appropriately.
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {	
			
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	[addingManagedObjectContext release];
	[punchButton release];
	[tableView release];
    [super dealloc];
}


@end

