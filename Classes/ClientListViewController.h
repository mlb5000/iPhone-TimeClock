//
//  ClientListViewController.h
//  TimeClock
//
//  Created by Matthew Baker on 10/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddClientViewController.h"
#import "PunchDialog.h"

@interface ClientListViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddClientViewControllerDelegate, PunchDialogDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;	    
	NSManagedObjectContext *addingManagedObjectContext;
	IBOutlet UIBarButtonItem *addButton;
}

@property (nonatomic, retain) UIBarButtonItem *addButton;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;

- (void)displayPunchDialogWithEntry:(TimeEntry *)entry;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)addClient;
- (void)saveState;

@end
