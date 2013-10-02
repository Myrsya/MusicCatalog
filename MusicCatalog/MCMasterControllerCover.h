//
//  MCMasterControllerCover.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 02.10.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Musician.h"

@protocol ShowAlbumsDelegate <NSObject>

-(void) didSelectAuthor:(Musician *) musician;

@end

@interface MCMasterControllerCover : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *masterTable;
@property (nonatomic,retain) id<ShowAlbumsDelegate> delegateShowAlbums;

@end
