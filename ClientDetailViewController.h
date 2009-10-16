//
//  ClientDetailViewController.h
//  TimeClock
//
//  Created by Matthew Baker on 10/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@interface ClientDetailViewController : UITableViewController {
    Client *client;
	NSDateFormatter *dateFormatter;
	NSUndoManager *undoManager;
}

@property (nonatomic, retain) Client *client;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSUndoManager *undoManager;

- (void)setUpUndoManager;
- (void)cleanUpUndoManager;
- (void)updateRightBarButtonItemState;
- (UITableViewCell *)configureTimeCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)configureDetailsCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end
