//
//  Album.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Musician, Song;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSString * coverURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) Musician *author;
@property (nonatomic, retain) NSSet *hasSong;

@end

@interface Album (CoreDataGeneratedAccessors)

- (void)addHasSongObject:(Song *)value;
- (void)removeHasSongObject:(Song *)value;
- (void)addHasSong:(NSSet *)values;
- (void)removeHasSong:(NSSet *)values;

@end
