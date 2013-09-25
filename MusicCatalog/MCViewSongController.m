//
//  MCViewSongController.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 25.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCViewSongController.h"

@interface MCViewSongController ()

@end

@implementation MCViewSongController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title= self.selectedSong.name;
    self.textLyrics.text = self.selectedSong.lyrics;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
