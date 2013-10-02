//
//  MCViewSongController.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 25.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCViewSongControllerTable.h"

@interface MCViewSongControllerTable ()

@end

@implementation MCViewSongControllerTable

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title= self.selectedSong.name;
    self.textLyrics.text = self.selectedSong.lyrics;
    
    //textview
    CGRect frame = self.textLyrics.frame;
    frame.size.height = self.textLyrics.contentSize.height;
    self.textLyrics.frame = frame;
    
    //scrollview
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    contentRect.size.height+=20;
    self.scrollView.contentSize = contentRect.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
