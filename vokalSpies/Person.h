//
//  Person.h
//  vokalSpies
//
//  Created by gBit on 3/12/13.
//  Copyright (c) 2013 Oess Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * photoURL;

@end
