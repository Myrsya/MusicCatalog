//
//  Song.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 01.10.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * lyrics;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Album *sourceAlbum;

@end
