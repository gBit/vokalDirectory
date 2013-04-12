//
//  ViewController.m
//  vokalSpies
//
//  Created by gBit on 3/12/13.
//  Copyright (c) 2013 Oess Industries. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Person.h"

@interface ViewController ()
{
    NSString *spyName;
    NSArray *vokalSpies;
    NSArray *displayedSpies;
    NSString *currentSearchTerm;
    
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    __weak IBOutlet UITableView *vokalTableView;
    __weak IBOutlet UISearchBar *searchBar;
}

@end

@implementation ViewController

@synthesize myManagedObjectContext;

- (void)viewDidLoad
{
    currentSearchTerm = @"";
    
    AppDelegate *mmAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.myManagedObjectContext = mmAppDelegate.managedObjectContext;
    
    if (![self didIReceiveTheData]) {
        [self populateManagedObjectContext];
    }
    else
    {
        displayedSpies = [self allEntitiesNamed:@"Person"];
        [vokalTableView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    currentSearchTerm = searchText;
    
    [self getCurrentSpies];
    
    [vokalTableView reloadData];
    
}

#pragma mark - CRUD -
// CREATE
- (void)createPersonWithName:(NSString *)name andEmail:(NSString *)email andPhotoURL:(NSString *)photoURL
{
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:myManagedObjectContext];
    person.name = name;
    person.email = email;
    person.photoURL = photoURL;
    
    [self checkForSaveError];
    
}

// READ
- (Person *)getPersonNamed:(NSString *)name
{
    // coming back to this point later
    
    Person *person;
    return person;
}

// UPDATE
- (void)updatePerson:(Person *)person withPhotoURL:(NSString *)photoURL
{
    // person.photoURL = photoURL;
    // [person setValue:photoURL forKey:@"photoURL"];
    
    [person setPhotoURL:photoURL];
    [self checkForSaveError];
}

// DELETE
- (void)deletePerson:(Person *)person
{
    [myManagedObjectContext deleteObject:person];
    [self checkForSaveError];
}


# pragma mark - Data Retrieval -
- (void)populateManagedObjectContext
{
    NSString * vokalURLString = @"http://vokal-dev-test.herokuapp.com/api/members";
    NSURL *vokalURL = [NSURL URLWithString:vokalURLString];
    NSMutableURLRequest * vokalURLRequest = [NSMutableURLRequest requestWithURL:vokalURL];
    vokalURLRequest.HTTPMethod = @"GET";
    [NSURLConnection sendAsynchronousRequest:vokalURLRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^void (NSURLResponse * vokalResponse, NSData* vokalData, NSError * vokalError)
     {
         //Making sure we get an error or not
         if (vokalError)
         {
             NSLog(@"%@", vokalError.localizedDescription);
         }
         else
         {
             NSError *error;
             id jsonRawData = [NSJSONSerialization JSONObjectWithData:vokalData options:NSJSONReadingAllowFragments error:&error];
             NSArray *jsonArray = (NSArray *)jsonRawData;
             //NSLog(@"%@", jsonArray);
             
             for (NSDictionary *dictionary in jsonArray)
             {
                 [self createPersonWithName:[dictionary valueForKey:@"name"]
                                   andEmail:[dictionary valueForKey:@"email"]
                                andPhotoURL:[dictionary valueForKey:@"avatar_url"]];
             }
             
             [self checkForSaveError];
             
             displayedSpies = [self allEntitiesNamed:@"Person"];
             //displayedSpies = vokalSpies;
             [vokalTableView reloadData];
             [self iHaveReceivedTheData];
         }
         
     }];
}

-(NSArray *)allEntitiesNamed:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:myManagedObjectContext];
    NSError *error;
    
    fetchRequest.entity = entity;
    
    return [myManagedObjectContext executeFetchRequest:fetchRequest error:&error];
}

//
// This method returns an array of all the spies from the database
// while also filtering that result with what is in the searchbar
//
- (NSArray *)getCurrentSpies
{
    // set up the fetch
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:myManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSFetchedResultsController *fetchedResultsController;
    
    // manipulate the fetch
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name contains[c] '%@'",currentSearchTerm]];
    
    // evening hack bugfix: if the search string is blank, don't filter the results
    if ([currentSearchTerm isEqualToString:@""]) {
        predicate = nil;
    }
    
    // actually set the fetch request
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:myManagedObjectContext
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    
    // fetch!
    NSError *sadnessError;
    [fetchedResultsController performFetch:&sadnessError];
    
    // set results to display array
    displayedSpies = fetchedResultsController.fetchedObjects;
    
    
    //double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    // with if:
    //      longest: 2.234995
    //      shortest: 0.007987
    //
    // without:
    //      longest: 2.701998
    //      shortest: 0.717998
    
    
    //NSLog(@"%f", timePassed_ms);
    return displayedSpies;
}


#pragma mark - Data Checking -
- (void)iHaveReceivedTheData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"didIGetTheData"];
    
    [defaults synchronize];
}

- (BOOL)didIReceiveTheData
{
    // resets didIGetTheData to NO
    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"didIGetTheData"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL didIGetTheData = (BOOL)[defaults objectForKey:@"didIGetTheData"];
    return didIGetTheData;
}

- (void)checkForSaveError
{
    NSError *error;
    if (![myManagedObjectContext save:&error])
    {
        NSLog(@"failed to save: %@", [error userInfo]);
    }
}


#pragma mark - TableView -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (displayedSpies == nil ? 0 : displayedSpies.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [activityIndicator startAnimating];
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifierRolodex"];
    
    Person *spyRecord = [displayedSpies objectAtIndex:indexPath.row];
    
    // set name
    spyName = spyRecord.name;
    UIView *viewThatsALabel = [customCell viewWithTag:100];
    UILabel *spyNameLabel = (UILabel *)viewThatsALabel;
    spyNameLabel.text = spyName;
    
    // set email
    UIView * emailViewToLabel = [customCell viewWithTag:101];
    UILabel *spyEmailLabel = (UILabel *) emailViewToLabel;
    spyEmailLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
    spyEmailLabel.text = spyRecord.email;
    
    // set photo
    NSString *spyPictureString = spyRecord.photoURL;
    NSURL *spyPictureURL = [NSURL URLWithString:spyPictureString];
    NSData *spyPictureData = [NSData dataWithContentsOfURL:spyPictureURL];
    UIImage *spyPicture = [UIImage imageWithData:spyPictureData];
        
    UIView *spyPictureViewToImage = [customCell viewWithTag:102];
    UIImageView *spyPicture2display = (UIImageView *) spyPictureViewToImage;
    spyPicture2display.image = spyPicture;

    [activityIndicator stopAnimating];
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    Person *spyRecord = [displayedSpies objectAtIndex:[indexPath row]];
    
    NSString *currentSpyName = spyRecord.name;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:currentSpyName
                                                    message:@"Sorry, I'm on a mission"
                                                   delegate:self
                          
                                          cancelButtonTitle:@"Roger roger"
                                          otherButtonTitles: nil];;
    
    [alert show];
}

// We get a 'delete cell row' event here
// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get the object that will be deleted
    Person *spyRecord = [displayedSpies objectAtIndex:indexPath.row];
    
    // delete it from the database
    [self deletePerson:spyRecord];
    
    //update our tableview array of data to reflect the new change
    displayedSpies = [self getCurrentSpies];
    
    //remove the cell from view
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    //reload tableview
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
