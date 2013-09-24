//
//  MCDetailController.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMasterController.h"

@interface MCDetailController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate, ShowAlbumDelegate>

//@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIImageView *imageCover;
@property (strong, nonatomic) IBOutlet UITableView *tableSongs;

@end
