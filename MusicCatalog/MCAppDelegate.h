//
//  MCAppDelegate.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 11.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Album.h"
#import "Musician.h"
#import "Song.h"

@interface MCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(BOOL)saveContext;
-(BOOL)createMusicianWithName:(NSString *)paramName;
-(BOOL)createAlbumWithName:(NSString *)paramName year:(NSNumber *)paramYear;
-(BOOL)createSongWithName:(NSString *)paramName lyrics:(NSString *)paramText;

-(BOOL)addAlbumWithName:(NSString *)albumName ForMusicianWithName:(NSString *)musicianName;
-(BOOL)removeAlbum:(Album *)album ForMusician:(Musician *)musician;
-(BOOL)addSongWithName:(NSString *)songName ForAlbumWithName:(NSString *)albumName;

-(NSArray *)fetchAllMusicians;
-(NSArray *)fetchAllSongsForAlbum:(NSString *)albumName;

@end
