//
//  TimeListViewController.h
//  TimeClock
//
//  Created by Matthew Baker on 10/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeListViewController : UIViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;	    
	NSManagedObjectContext *addingManagedObjectContext;	
	IBOutlet UIButton *punchButton;
	IBOutlet UITableView *tableView;
}

- (IBAction)punch:(id)sender;
- (void)punchIn;
- (void)punchOut;
- (void)turnOnEditing;
- (void)turnOffEditing;
- (void)initializePunchState;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIButton *punchButton;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
