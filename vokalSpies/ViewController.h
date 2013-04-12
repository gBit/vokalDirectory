//
//  ViewController.h
//  vokalSpies
//
//  Created by gBit on 3/12/13.
//  Copyright (c) 2013 Oess Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSManagedObjectContext *myManagedObjectContext;

@end
