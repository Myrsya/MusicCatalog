//
//  MCMasterController.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCMasterController.h"

@interface MCMasterController ()
{
    NSArray *allMusicians;
    NSArray *allAlbums;
}
@end

@implementation MCMasterController

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

#pragma mark - protocol from modal view
-(void) didCreatedNewAlbum:(BOOL)result
{
    if (result)
    {
        allMusicians = [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] fetchAllMusicians];
        [self.masterTable reloadData];
    }
}

#pragma mark - Table view data source

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
    cell.textLabel.text = ((Album *)[allAlbums objectAtIndex:indexPath.row]).name;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setMasterTable:nil];
    [super viewDidUnload];
}
@end
