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
-(BOOL)createAlbumWithName:(NSString *)paramName year:(NSNumber *)paramYear imageURL:(NSString *)imageURL;
-(BOOL)createSongWithName:(NSString *)paramName lyrics:(NSString *)paramText;

-(BOOL)addAlbumWithName:(NSString *)albumName forMusicianWithName:(NSString *)musicianName;
-(BOOL)addSongWithName:(NSString *)songName ForAlbum:(Album *)album;

-(BOOL)removeMusician:(Musician *)musician;
-(BOOL)removeAlbum:(Album *)album ForMusician:(Musician *)musician;
-(BOOL)removeSong:(Song *)song ForAlbum:(Album *)album;

-(BOOL)musicianNameIsFree:(NSString *)musicianName;
-(BOOL)albumNameIsFree:(NSString *)albumName owner:(Musician *)musician;
-(BOOL)songNameIsFree:(NSString *)songName owner:(Album *)album;

-(NSArray *)fetchAllMusicians;

@end
