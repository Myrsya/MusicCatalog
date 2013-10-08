//
//  MCMasterControllerCover.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 02.10.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCMasterControllerCover.h"
#import "MCAppDelegate.h"
#import "MCMasterSongsControllerCover.h"

@interface MCMasterControllerCover ()
{
    NSArray *allMusicians;
}
@end

@implementation MCMasterControllerCover

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    allMusicians = [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] fetchAllMusicians];
    [self.masterTable reloadData];
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //set delegate from detail to new master (to fetch songs)
    if ([[segue identifier] isEqualToString:@"masterMusiciansToSongs"])
    {
        MCMasterSongsControllerCover *masterSongsControllerCover = [segue destinationViewController];
        MCDetailControllerCover *detailControllerCover = [((UINavigationController *)[self.splitViewController.viewControllers lastObject]).viewControllers objectAtIndex:0];
        
        detailControllerCover.delegateShowSongs = masterSongsControllerCover;
    }
    //new album delegate
    if ([[segue identifier] isEqualToString:@"newAlbum"])
    {
        MCNewAlbumViewController *newAlbumViewController = [segue destinationViewController];
        newAlbumViewController.delegateNewAlbum = self;
    }
}

#pragma mark - delegates

-(void) didCreatedNewAlbum:(BOOL)result
{
    if (result)
    {
        allMusicians = [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] fetchAllMusicians];
        if (self.delegateShowAlbums != nil)
        {
            [self.delegateShowAlbums didSelectAuthor:(Musician *)[allMusicians objectAtIndex:self.masterTable.indexPathForSelectedRow.row]];
        }
        
        NSIndexPath *ipath = [self.masterTable indexPathForSelectedRow];
        [self.masterTable reloadData];
        [self.masterTable selectRowAtIndexPath:ipath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allMusicians count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = ((Musician *)[allMusicians objectAtIndex:indexPath.row]).name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d)", [((Musician *)[allMusicians objectAtIndex:indexPath.row]).albums count]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegateShowAlbums != nil)
    {
        [self.delegateShowAlbums didSelectAuthor:(Musician *)[allMusicians objectAtIndex:indexPath.row]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Musician *aMusician = (Musician *)[allMusicians objectAtIndex:indexPath.row];
        
        [self.masterTable beginUpdates];
        
        //removeMusician and all albums
        [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] removeMusician:aMusician];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        allMusicians = [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] fetchAllMusicians];
        [self.masterTable endUpdates];
        [tableView reloadData];
    }
}

@end
