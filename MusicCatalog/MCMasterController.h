//
//  MCMasterController.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAppDelegate.h"
#import "MCNewAlbumViewController.h"

@protocol ShowAlbumDelegate <NSObject>

-(void) didSelectAlbum:(Album *) album;

@end

@interface MCMasterController : UITableViewController <NewAlbum>

@property (strong, nonatomic) IBOutlet UITableView *masterTable;
@property (nonatomic,retain) id<ShowAlbumDelegate> delegate;

@end
