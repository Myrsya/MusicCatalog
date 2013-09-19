//
//  MCMasterController.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@protocol AlbumDelegate <NSObject>

-(void) didSelectAlbum:(Album *) album;

@end

@interface MCMasterController : UITableViewController

@property (nonatomic,retain) id<AlbumDelegate> delegate;

@end
