//
//  MCNewAlbumViewController.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorPickerViewController.h"

@protocol NewAlbum <NSObject>

-(void) didCreatedNewAlbum:(BOOL)result;

@end

@interface MCNewAlbumViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, AuthorPickerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UITextField *textYear;
@property (strong, nonatomic) IBOutlet UISwitch *switchAuthor;
@property (strong, nonatomic) IBOutlet UITextField *textAuthor;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) AuthorPickerViewController *authorPicker;
@property (nonatomic, strong) UIPopoverController *authorPickerPopover;

@property (nonatomic,retain) id<NewAlbum> delegateNewAlbum;

-(IBAction)savePressed:(id)sender;
-(IBAction)cancelPressed:(id)sender;

@end
