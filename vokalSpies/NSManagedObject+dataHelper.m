//
//  NSManagedObject+dataHelper.m
//  Feb20_vokalAPI
//
//  Created by spawrks on 3/12/13.
//  Copyright (c) 2013 Genius and Madness. All rights reserved.
//

#import "NSManagedObject+dataHelper.h"

@implementation NSManagedObject (dataHelper)
// Convenience method to fetch the array of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
//- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName
//                       withPredicate:(id)stringOrPredicate, ...
//{
//    NSEntityDescription *entity = [NSEntityDescription
//                                   entityForName:newEntityName inManagedObjectContext:self];
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entity];
//    
//    if (stringOrPredicate)
//    {
//        NSPredicate *predicate;
//        if ([stringOrPredicate isKindOfClass:[NSString class]])
//        {
//            va_list variadicArguments;
//            va_start(variadicArguments, stringOrPredicate);
//            predicate = [NSPredicate predicateWithFormat:stringOrPredicate
//                                               arguments:variadicArguments];
//            va_end(variadicArguments);
//        }
//        else
//        {
//            NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
//                      @"Second parameter passed to %s is of unexpected class %@",
//                      sel_getName(_cmd), [stringOrPredicate className]);
//            predicate = (NSPredicate *)stringOrPredicate;
//        }
//        [request setPredicate:predicate];
//    }
//    
//    NSError *error = nil;
//    NSArray *results = [self executeFetchRequest:request error:&error];
//    if (error != nil)
//    {
//        [NSException raise:NSGenericException format:[error description]];
//    }
//    
//    return [NSSet setWithArray:results];
//}
@end
