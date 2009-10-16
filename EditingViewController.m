//
//  EditingViewController.m
//  TimeClock
//
//  Created by Matthew Baker on 10/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditingViewController.h"

@implementation EditingViewController

@synthesize textField, editedObject, editedFieldKey, editedFieldName, datePicker, clientPicker, editType;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	// Set the title to the user-visible name of the field.
	self.title = editedFieldName;
	
	// Configure the save and cancel buttons.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
}


- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	[self enableControl:self.editType];
}

- (void)enableControl:(EditingViewControllerType)type {
	textField.hidden = type != EditingViewControllerTypeString &&
					   type != EditingViewControllerTypeDouble &&
					   type != EditingViewControllerTypePhone;
	datePicker.hidden = type != EditingViewControllerTypeDate;
	clientPicker.hidden = type != EditingViewControllerTypeClient;	
	
	// Configure the user interface according to state.
    if (type == EditingViewControllerTypeDate) {
		NSDate *date = [editedObject valueForKey:editedFieldKey];
        if (date == nil) date = [NSDate date];
        datePicker.date = date;
    }
	else if (type == EditingViewControllerTypeDouble) {
		NSNumber *number = [editedObject valueForKey:editedFieldKey];
		if (number == nil) textField.text = @"";
		else textField.text = [number stringValue];
		textField.placeholder = self.title;
		textField.keyboardType = UIKeyboardTypeNumberPad;
		[textField becomeFirstResponder];
	}
	else if (type == EditingViewControllerTypeClient) {
	}
	else if (type == EditingViewControllerTypePhone) {
		textField.text = [editedObject valueForKey:editedFieldKey];
		textField.placeholder = self.title;
		textField.keyboardType = UIKeyboardTypePhonePad;
        [textField becomeFirstResponder];
	}
	else {
        textField.text = [editedObject valueForKey:editedFieldKey];
		textField.placeholder = self.title;
		textField.keyboardType = UIKeyboardTypeDefault;
        [textField becomeFirstResponder];
    }
	
}

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)save {
	
	// Set the action name for the undo operation.
	NSUndoManager * undoManager = [[editedObject managedObjectContext] undoManager];
	[undoManager setActionName:[NSString stringWithFormat:@"%@", editedFieldName]];
	
    // Pass current value to the edited object, then pop.
    if (self.editType == EditingViewControllerTypeDate) {
        [editedObject setValue:datePicker.date forKey:editedFieldKey];
    }
	else if (self.editType == EditingViewControllerTypeDouble) {
		NSNumber *number = [NSNumber numberWithDouble:[textField.text doubleValue]];
		[editedObject setValue:number forKey:editedFieldKey];
	}
	else if (self.editType == EditingViewControllerTypeString) {
        [editedObject setValue:textField.text forKey:editedFieldKey];
    }
	
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancel {
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [textField release];
    [editedObject release];
    [editedFieldKey release];
    [editedFieldName release];
    [datePicker release];
	[super dealloc];
}


@end
