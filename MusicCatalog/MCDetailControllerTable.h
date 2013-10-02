//
//  MCDetailController.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMasterControllerTable.h"
#import "MCNewSongViewController.h"

@interface MCDetailControllerTable : UIViewController
<UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate, ShowAlbumDelegate, NewSong>

@property (strong, nonatomic) IBOutlet UIImageView *imageCover;
@property (strong, nonatomic) IBOutlet UITableView *tableSongs;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addSongButton;

@end
