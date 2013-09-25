//
//  MCViewSongController.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 25.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface MCViewSongController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *textLyrics;

@property (strong, nonatomic) Song *selectedSong;

@end
