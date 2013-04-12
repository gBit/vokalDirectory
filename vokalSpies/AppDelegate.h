//
//  AppDelegate.h
//  vokalSpies
//
//  Created by gBit on 3/12/13.
//  Copyright (c) 2013 Oess Industries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h> 

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persitentStoreCoordinator;
    NSManagedObjectContext *managedObjectContext;
}
@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
