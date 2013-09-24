//
//  MCDetailController.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCDetailController.h"

@interface MCDetailController ()
{
    Album *selectedAlbum;
}
@end

@implementation MCDetailController
{
    UIPopoverController *masterPopoverController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = selectedAlbum.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - delegate
-(void) didSelectAlbum:(Album *) album
{
    selectedAlbum = album;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"lol";
    //tempMusician = [self.authorNames objectAtIndex:indexPath.row];
    //cell.textLabel.text = tempMusician.name;
    
    return cell;
}


//- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
//{
//    barButtonItem.title = @"Все";
//    NSMutableArray *items = [[self.toolbar items] mutableCopy];
//    [items insertObject:barButtonItem atIndex:0];
//    [self.toolbar setItems:items animated:YES];
//    masterPopoverController = pc;
//}
//
//- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
//{
//    NSMutableArray *items = [[self.toolbar items] mutableCopy];
//    [items removeObject:button];
//    [self.toolbar setItems:items animated:YES];
//    masterPopoverController = nil;
//}


- (void)viewDidUnload {
    [self setImageCover:nil];
    [self setTableSongs:nil];
    [super viewDidUnload];
}
@end
