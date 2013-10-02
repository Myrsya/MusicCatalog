//
//  MCDetailController.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCDetailControllerTable.h"
#import "MCViewSongControllerTable.h"
#import "MCAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@interface MCDetailControllerTable ()
{
    Album *selectedAlbum;
    NSArray *albumSongs;
}
@end

@implementation MCDetailControllerTable
{
    UIPopoverController *masterPopoverController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableSongs setHidden:YES];
    [self.imageCover setHidden:YES];
    
    //appearance
    self.tableSongs.layer.cornerRadius = 8.0;
    self.tableSongs.layer.borderColor = [UIColor grayColor].CGColor;
    self.tableSongs.layer.borderWidth = 1.5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableSongs reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"newSong"])
    {
        MCNewSongViewController *newSongViewController = [segue destinationViewController];
        [newSongViewController setEditAlbum:selectedAlbum];
        newSongViewController.delegateNewSong =self;
    }
    if ([[segue identifier] isEqualToString:@"viewSong"])
    {
        NSIndexPath *indexPath = [self.tableSongs indexPathForSelectedRow];
        
        MCViewSongControllerTable *viewSongController = [segue destinationViewController];
        [viewSongController setSelectedSong:[albumSongs objectAtIndex:indexPath.row] ];
    }
}

-(void)configureView
{
    //tableview
    CGRect frame = self.tableSongs.frame;
    frame.size.height = self.tableSongs.contentSize.height;
    self.tableSongs.frame = frame;
    
    //scrollview
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    contentRect.size.height+=20;
    self.scrollView.contentSize = contentRect.size;
    
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
}

#pragma mark - delegates
-(void) didSelectAlbum:(Album *) album
{
    selectedAlbum = album;
    
    [self.tableSongs setHidden:NO];
    [self.imageCover setHidden:NO];
    [self.addSongButton setEnabled:YES];
    
    //reload view content
    self.navigationItem.title = selectedAlbum.name;
    albumSongs = [selectedAlbum.songs allObjects];
    
    [self.tableSongs reloadData];
    
    //load image
    if ([selectedAlbum.coverURL length] > 0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:selectedAlbum.coverURL];
        self.imageCover.image = [UIImage imageWithContentsOfFile:filePath];
    }
    else
    {
        //no cover
        self.imageCover.image = [UIImage imageNamed:@"cover_small.png"];
    }
    [self configureView];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) didCreatedNewSong:(BOOL)result
{
    albumSongs = [selectedAlbum.songs allObjects];
    [self.tableSongs reloadData];
    [self configureView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [albumSongs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = ((Song *)[albumSongs objectAtIndex:indexPath.row]).name;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Song *aSong =(Song *)[albumSongs objectAtIndex:indexPath.row];
        
        [tableView beginUpdates];
        
        [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] removeSong:aSong ForAlbum:selectedAlbum];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        albumSongs = [selectedAlbum.songs allObjects];
        
        [tableView endUpdates];
        [self.tableSongs reloadData];
        [self configureView];
    }
}

#pragma mark - split view

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{   
    barButtonItem.title = @"Все";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    masterPopoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    masterPopoverController = nil;
}


- (void)viewDidUnload {
    [self setImageCover:nil];
    [self setTableSongs:nil];
    [super viewDidUnload];
}
@end
