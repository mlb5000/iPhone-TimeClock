//
//  AddClientViewController.h
//  TimeClock
//
//  Created by Matthew Baker on 10/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientDetailViewController.h"

@protocol AddClientViewControllerDelegate;

@interface AddClientViewController : ClientDetailViewController {
	id <AddClientViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <AddClientViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol AddClientViewControllerDelegate
- (void)addClientViewController:(AddClientViewController *)controller didFinishWithSave:(BOOL)save;
@end