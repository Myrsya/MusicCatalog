//
//  Song.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * lyrics;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *sourceAlbum;

@end
