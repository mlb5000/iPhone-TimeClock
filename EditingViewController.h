//
//  EditingViewController.h
//  TimeClock
//
//  Created by Matthew Baker on 10/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

typedef enum {
    EditingViewControllerTypeString,
	EditingViewControllerTypeDouble,
	EditingViewControllerTypeDate,
	EditingViewControllerTypeClient,
	EditingViewControllerTypePhone
} EditingViewControllerType;

@interface EditingViewController : UIViewController {
	
	UITextField *textField;
	
    NSManagedObject *editedObject;
    NSString *editedFieldKey;
    NSString *editedFieldName;
	
	EditingViewControllerType editType;
	UIDatePicker *datePicker;
	UIPickerView *clientPicker;
}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UIPickerView *clientPicker;

@property (nonatomic, retain) NSManagedObject *editedObject;
@property (nonatomic, retain) NSString *editedFieldKey;
@property (nonatomic, retain) NSString *editedFieldName;

@property (nonatomic, assign) EditingViewControllerType editType;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

- (IBAction)cancel;
- (IBAction)save;
- (void)enableControl:(EditingViewControllerType)type;

@end
