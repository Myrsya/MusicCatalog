//
//  MCMasterControllerCover.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 02.10.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCMasterControllerCover.h"
#import "MCAppDelegate.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];\
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog([segue identifier]);
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

@end
