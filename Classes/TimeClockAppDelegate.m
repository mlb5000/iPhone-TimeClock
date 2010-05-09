//
//  TimeClockAppDelegate.m
//  TimeClock
//
//  Created by Matthew Baker on 10/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TimeClockAppDelegate.h"
#import "TimeListViewController.h"
#import "ClientListViewController.h"

@implementation TimeClockAppDelegate

@synthesize window;
@synthesize tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
	
	//Add Time list tab
	TimeListViewController *timeList = [[TimeListViewController alloc] init];
	timeList.title = @"TimeClock";
	timeList.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
	timeList.managedObjectContext = self.managedObjectContext;
	UINavigationController *navController = [[UINavigationController alloc] init];
	[navController pushViewController:timeList animated:NO];	
	[timeList release];
	
	//Add client list tab
	ClientListViewController *clientList = [[ClientListViewController alloc] initWithStyle:UITableViewStyleGrouped];
	clientList.managedObjectContext = self.managedObjectContext;
	clientList.title = @"Clients";
	clientList.tabBarItem.image = [UIImage imageNamed:@"group.png"];
	UINavigationController *clientNavController = [[UINavigationController alloc] init];
	[clientNavController pushViewController:clientList animated:NO];
	[clientList release];
	
	//Add Reports tab
	//Add Settings tab
	
	[controllers addObject:clientNavController];
	[controllers addObject:navController];
	[navController release];
	[clientNavController release];
	
    // Override point for customization after app launch
    UITabBarController *tempTabBarController = [[UITabBarController alloc] init];
	
	// Set the array of view controllers
	tempTabBarController.viewControllers = controllers;
	[controllers release];
	
	self.tabBarController = tempTabBarController;
	[tempTabBarController release];
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"TimeClock.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		NSLog(@"Cannot access persistent store.");
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[tabBarController release];
	[window release];
	[super dealloc];
}


@end

