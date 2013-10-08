//
//  Film.h
//  MovieCatalog
//
//  Created by Mary Gavrina on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Film : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * fdescription;
@property (nonatomic, retain) NSString * image_name;

@end
