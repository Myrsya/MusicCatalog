//
//  MCNewAlbumViewController.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCNewAlbumViewController.h"

@interface MCNewAlbumViewController ()
{
    bool keyboardIsShown;
    float originalScrollOffsetY;
    Musician *tempMusician;
    Album *tempAlbum;
}
@end

@implementation MCNewAlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //for keyboard
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    //backgoundTap
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.scrollview addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Keyboard and scrollview handle

-(BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

-(void)keyboardDidShow:(NSNotification *) notification
{
    if (keyboardIsShown) return;
    
    NSDictionary* info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float keyboardHeight = kbSize.width;
    float viewHeight = self.view.frame.size.width;
    originalScrollOffsetY = self.scrollview.contentOffset.y;
    [self.scrollview setContentOffset:CGPointMake(0.0,viewHeight - keyboardHeight) animated:YES];
    
    keyboardIsShown = YES;
}

-(void)keyboardDidHide:(NSNotification *) notification
{
    [self.scrollview setContentOffset:CGPointMake(0.0, originalScrollOffsetY) animated:YES];
    keyboardIsShown = NO;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)backgroundTap:(id)sender
{
    [self.textName resignFirstResponder];
    [self.textYear resignFirstResponder];
    [self.textAuthor resignFirstResponder];
}

//manageAuthorInput
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.textAuthor)
    {
        //new Author, show keyboard
        if (self.switchAuthor.on)
        {
            return YES;
        }
        //old Author, show popover
        else
        {
            if (self.authorPicker == nil)
            {
                self.authorPicker = [[AuthorPickerViewController alloc] initWithStyle:UITableViewStylePlain];
                self.authorPicker.delegateAuthorPicker = self;
            }
            if (self.authorPickerPopover == nil)
            {
                self.authorPickerPopover = [[UIPopoverController alloc] initWithContentViewController:self.authorPicker];
                [self.authorPickerPopover presentPopoverFromRect:textField.frame  inView:self.contentView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            }
            else
            {
                [self.authorPickerPopover dismissPopoverAnimated:YES];
                self.authorPickerPopover = nil;
            }
            return NO;
        }
    }
    else return YES;
}

-(void)selectedAuthor:(Musician *)selectedMusician
{
    tempMusician = selectedMusician;
    self.textAuthor.text = selectedMusician.name;
    
    if (self.authorPickerPopover)
    {
        [self.authorPickerPopover dismissPopoverAnimated:YES];
        self.authorPickerPopover = nil;
    }
}

#pragma mark - Buttons handle
-(IBAction)cancelPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)savePressed:(id)sender
{
    //save musician if it is new
    if (self.switchAuthor.on)
    {
        [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] createMusicianWithName:self.textAuthor.text];
    }
    //save album
    [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] createAlbumWithName:self.textName.text year:[NSNumber numberWithInt:[self.textYear.text intValue]]];
    [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] addAlbumWithName:self.textName.text ForMusicianWithName:self.textAuthor.text];
    
    if (self.delegateNewAlbum != nil) {
        [self.delegateNewAlbum didCreatedNewAlbum:YES];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
