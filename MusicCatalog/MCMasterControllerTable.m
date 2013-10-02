//
//  MCMasterController.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCMasterControllerTable.h"
#import "MCAppDelegate.h"

@interface MCMasterControllerTable ()
{
    NSArray *allMusicians;
    NSArray *allAlbums;
}
@end

@implementation MCMasterControllerTable

- (void)viewDidLoad
{
    [super viewDidLoad];
    allMusicians = [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] fetchAllMusicians];
    [self.masterTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"newAlbum"])
    {
        MCNewAlbumViewController *newAlbumViewController = [segue destinationViewController];
        newAlbumViewController.delegateNewAlbum =self;
    }
}

#pragma mark - delegates
-(void) didCreatedNewAlbum:(BOOL)result
{
    if (result)
    {
        allMusicians = [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] fetchAllMusicians];
        [self.masterTable reloadData];
    }
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allMusicians count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((Musician *)[allMusicians objectAtIndex:section]).albums count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ((Musician *)[allMusicians objectAtIndex:section]).name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    allAlbums = [((Musician *)[allMusicians objectAtIndex:indexPath.section]).albums allObjects];
    Album *anAlbum = ((Album *)[allAlbums objectAtIndex:indexPath.row]);
    
    if (![anAlbum.year isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ / %@", anAlbum.name, anAlbum.year];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", anAlbum.name];
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d)", [((Album *)[allAlbums objectAtIndex:indexPath.row]).songs count]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Musician *aMusician = (Musician *)[allMusicians objectAtIndex:indexPath.section];
        allAlbums = [aMusician.albums allObjects];
        Album *anAlbum = ((Album *)[allAlbums objectAtIndex:indexPath.row]);
        
        [tableView beginUpdates];
        //removeAlbum
        [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] removeAlbum:anAlbum ForMusician:aMusician];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //if Album was last - remove Musicians
        if ([allAlbums count] == 1)
        {
            [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] removeMusician:aMusician];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        allMusicians = [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] fetchAllMusicians];
        [tableView endUpdates];
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegateShowAlbum != nil) {
        allAlbums = [((Musician *)[allMusicians objectAtIndex:indexPath.section]).albums allObjects];
        [self.delegateShowAlbum didSelectAlbum:[allAlbums objectAtIndex:indexPath.row]];
    }
}

- (void)viewDidUnload {
    [self setMasterTable:nil];
    [super viewDidUnload];
}
@end
