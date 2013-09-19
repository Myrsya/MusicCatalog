//
//  MCAppDelegate.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 11.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCAppDelegate.h"
#import "Album.h"
#import "Musician.h"
#import "Song.h"

@implementation MCAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    UISplitViewController *splitViewController = (UISplitViewController *) self.window.rootViewController;
    splitViewController.delegate = [splitViewController.viewControllers lastObject];
    
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
    
    Musician *newMusician = (Musician *)[NSEntityDescription insertNewObjectForEntityForName:@"Musician" inManagedObjectContext:_managedObjectContext];
    if (newMusician == nil)
    {
        NSLog(@"Failed to create Musician!");
        return NO;
    }
    
    newMusician.name = paramName;
    
    return [self saveContext];
}


-(BOOL)addAlbum:(Album *)album ForMusician:(Musician *)musician
{
    NSMutableSet *albums = [musician mutableSetValueForKey:@"albums"];
    [albums addObject:album];
    
    return [self saveContext];
}

-(BOOL)removeAlbum:(Album *)album ForMusician:(Musician *)musician
{
    NSMutableSet *albums = [musician mutableSetValueForKey:@"albums"];
    [albums removeObject:album];
    
    return [self saveContext];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
   //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    //NSURL *storeURL = [NSURL fileURLWithPath: [documentDirectory stringByAppendingPathComponent:databaseFileName]];
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
