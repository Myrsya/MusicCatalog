//
//  MCAppDelegate.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 11.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCAppDelegate.h"
#import "MCDetailController.h"
#import "MCMasterController.h"

@implementation MCAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    UISplitViewController *splitViewController = (UISplitViewController *) self.window.rootViewController;
    UINavigationController *navigationControllerDetail = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (MCDetailController *)navigationControllerDetail.topViewController;
    
    UINavigationController *navigationControllerMaster = [splitViewController.viewControllers objectAtIndex:0];
    ((MCMasterController *)navigationControllerMaster.topViewController).delegateShowAlbum = (MCDetailController *)navigationControllerDetail.topViewController;
    
    return YES;
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

-(BOOL)createAlbumWithName:(NSString *)paramName year:(NSNumber *)paramYear
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
    newAlbum.coverURL = @"nana";
    
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

-(BOOL)addAlbumWithName:(NSString *)albumName ForMusicianWithName:(NSString *)musicianName
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
    NSMutableSet *albums = [musician mutableSetValueForKey:@"albums"];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Album"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", albumName];
    
    Album *album = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    if (error != nil)
    {
        NSLog(@"Failed to get Album!");
        error = nil;
        return NO;
    }
    
    [albums addObject:album];
    
    return [self saveContext];
}

-(BOOL)removeAlbum:(Album *)album ForMusician:(Musician *)musician
{
    NSMutableSet *albums = [musician mutableSetValueForKey:@"albums"];
    [albums removeObject:album];
    
    return [self saveContext];
}

-(BOOL)addSongWithName:(NSString *)songName ForAlbumWithName:(NSString *)albumName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Album"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", albumName];
    
    NSError *error;
    Album *album = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    if (error != nil)
    {
        NSLog(@"Failed to get Album!");
        error = nil;
        return NO;
    }
    NSMutableSet *songs = [album mutableSetValueForKey:@"hasSong"];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Song"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", songName];
    
    Song *song = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    if (error != nil)
    {
        NSLog(@"Failed to get Song!");
        error = nil;
        return NO;
    }
    
    [songs addObject:song];
    
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

-(NSArray *)fetchAllSongsForAlbum:(NSString *)albumName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Album"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", albumName];
    
    NSError *error;
    Album *album = [[[self managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    if (error)
    {
        NSLog(@" %@ ", [error localizedDescription]);
        return nil;
    }
    return [album.hasSong allObjects];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
