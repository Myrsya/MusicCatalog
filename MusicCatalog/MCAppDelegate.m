//
//  MCAppDelegate.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 11.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCAppDelegate.h"
#import "MCDetailControllerTable.h"
#import "MCMasterControllerTable.h"
#import "MCDetailControllerCover.h"
#import "MCMasterControllerCover.h"

@implementation MCAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //load settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *apearanceSetting = [defaults objectForKey:@"appearance"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *viewController;
    
    //table apearance
    if ([apearanceSetting isEqual:@"1"])
    {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"splitTable"];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
        
        UISplitViewController *splitViewController = (UISplitViewController *) self.window.rootViewController;
        UINavigationController *navigationControllerDetail = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (MCDetailControllerTable *)navigationControllerDetail.topViewController;
        
        UINavigationController *navigationControllerMaster = [splitViewController.viewControllers objectAtIndex:0];
        ((MCMasterControllerTable *)navigationControllerMaster.topViewController).delegateShowAlbum = (MCDetailControllerTable *)navigationControllerDetail.topViewController;
    }
    //cover apearance
    else
    {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"splitCover"];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
        
        UISplitViewController *splitViewController = (UISplitViewController *) self.window.rootViewController;
        UINavigationController *navigationControllerDetail = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (MCDetailControllerCover *)navigationControllerDetail.topViewController;
        
        UINavigationController *navigationControllerMaster = [splitViewController.viewControllers objectAtIndex:0];
        ((MCMasterControllerCover *)navigationControllerMaster.topViewController).delegateShowAlbums = (MCDetailControllerCover *)navigationControllerDetail.topViewController;
    }

}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"catalog.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"database %@ ", [error localizedDescription]);
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - methods for DB

-(BOOL)saveContext
{
    NSError *error = nil;
    [_managedObjectContext save:&error];
    if (error)
    {
        NSLog(@"save %@ ", [error localizedDescription]);
        return NO;
    }
    return YES;
}

-(BOOL)createMusicianWithName:(NSString *)paramName
{
    if ([paramName length] == 0)
    {
        NSLog(@"You did not type Musician name!");
        return NO;
    }
    
    Musician *newMusician = (Musician *)[NSEntityDescription insertNewObjectForEntityForName:@"Musician" inManagedObjectContext:[self managedObjectContext]];
    if (newMusician == nil)
    {
        NSLog(@"Failed to create Musician!");
        return NO;
    }
    
    newMusician.name = paramName;
    
    return [self saveContext];
}

-(BOOL)createAlbumWithName:(NSString *)paramName year:(NSNumber *)paramYear imageURL:(NSString *)imageURL
{
    if ([paramName length] == 0)
    {
        NSLog(@"You did not type Album name!");
        return NO;
    }
    
    Album *newAlbum = (Album*)[NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:[self managedObjectContext]];
    if (newAlbum == nil)
    {
        NSLog(@"Failed to create Album!");
        return NO;
    }
    
    newAlbum.name = paramName;
    newAlbum.year = paramYear;
    newAlbum.coverURL = imageURL;
    
    return [self saveContext];
}

-(BOOL)createSongWithName:(NSString *)paramName lyrics:(NSString *)paramText
{
    if ([paramName length] == 0)
    {
        NSLog(@"You did not type Song name!");
        return NO;
    }
    
    Song *newSong = (Song*)[NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:[self managedObjectContext]];
    if (newSong == nil)
    {
        NSLog(@"Failed to create Song!");
        return NO;
    }
    
    newSong.name = paramName;
    newSong.lyrics = paramText;
    
    return [self saveContext];
}

-(BOOL)addAlbumWithName:(NSString *)albumName forMusicianWithName:(NSString *)musicianName
{    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Musician"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", musicianName];
    
    
    NSError *error;
    Musician *musician = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    if (error != nil)
    {
        NSLog(@"Failed to get Musician!");
        error = nil;
        return NO;
    }
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Album"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", albumName];
    
    error = nil;
    Album *album = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    if (error != nil)
    {
        NSLog(@"Failed to get Album!");
        error = nil;
        return NO;
    }
    
    [musician addAlbumsObject:album];
    
    return [self saveContext];
}

-(BOOL)addSongWithName:(NSString *)songName ForAlbum:(Album *)album
{    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Song"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", songName];
    
    NSError *error= nil;
    Song *song = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    if (error != nil)
    {
        NSLog(@"Failed to get Song!");
        error = nil;
        return NO;
    }
    
    [album addSongsObject:song];
    
    return [self saveContext];
}

-(BOOL)removeMusician:(Musician *)musician
{
    [self.managedObjectContext deleteObject:musician];
    return [self saveContext];
}

-(BOOL)removeAlbum:(Album *)album ForMusician:(Musician *)musician
{
    [musician removeAlbumsObject:album];
    return [self saveContext];
}

-(BOOL)removeSong:(Song *)song ForAlbum:(Album *)album
{
    [album removeSongsObject:song];
    return [self saveContext];
}

-(NSArray *)fetchAllMusicians
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Musician"];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *allMusicians = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@" %@ ", [error localizedDescription]);
        return nil;
    }
    return allMusicians;
}

-(BOOL)musicianNameIsFree:(NSString *)musicianName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Musician"];
    NSPredicate *nameComparison = [NSPredicate predicateWithFormat:@"name = %@", musicianName];
    request.predicate = nameComparison;
    
    NSError *error;
    NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if ([array count] > 0)
        return NO;
    else
        return YES;
}

-(BOOL)albumNameIsFree:(NSString *)albumName owner:(Musician *)musician
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Album"];
    NSPredicate *nameComparison = [NSPredicate predicateWithFormat:@"name = %@", albumName];
    NSPredicate *ownerComparrison = [NSPredicate predicateWithFormat:@"author = %@", musician.name];
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:nameComparison, ownerComparrison, nil]];
    
    NSError *error;
    NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if ([array count] > 0)
        return NO;
    else
        return YES;
}

-(BOOL)songNameIsFree:(NSString *)songName owner:(Album *)album
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Song"];
    NSPredicate *nameComparison = [NSPredicate predicateWithFormat:@"name = %@", songName];
    NSPredicate *ownerComparrison = [NSPredicate predicateWithFormat:@"sourceAlbum = %@", album];
    //NSLog(album.author.name);
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:nameComparison, ownerComparrison, nil]];
    //request.predicate = ownerComparrison;
    
    NSError *error;
    NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if ([array count] > 0)
        return NO;
    else
        return YES;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
