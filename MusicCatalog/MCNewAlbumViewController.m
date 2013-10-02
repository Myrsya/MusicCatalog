//
//  MCNewAlbumViewController.m
//  MusicCatalog
//
//  Created by Gavrina Maria on 19.09.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import "MCNewAlbumViewController.h"
#import "MCAppDelegate.h"

@interface MCNewAlbumViewController ()
{
    BOOL keyboardIsShown;
    float originalScrollOffsetY;
    NSString *imageName;
    Musician *tempMusician;
    Album *tempAlbum;
    
    UIPopoverController *popOverImagePick;
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
    
    //imageTap
    self.coverImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.coverImage addGestureRecognizer:imageTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - image picker
- (IBAction)imageTapped:(id)sender {
    UIImagePickerController *picker;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        popOverImagePick = [[UIPopoverController alloc] initWithContentViewController:picker];
        [popOverImagePick presentPopoverFromRect:self.coverImage.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSData *pngData = UIImagePNGRepresentation(pickedImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    imageName = [NSString stringWithFormat:@"%@.png", guid];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName];
    [pngData writeToFile:filePath atomically:YES];
    
    self.coverImage.image = [[UIImage alloc] initWithContentsOfFile:filePath];
    
    return;
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
                self.authorPicker.contentSizeForViewInPopover=CGSizeMake(200, 300);
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)savePressed:(id)sender
{
    //check if musucian name is not empty
    if (![self.textAuthor.text length] > 0)
    {
        UIAlertView *alertName = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Автор обязателен!"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertName show];
    }
    else
    {
        //save musician if it is new
        if (self.switchAuthor.on)
        {
            //check if musician name is unique
            if ([(MCAppDelegate *)[[UIApplication sharedApplication] delegate] musicianNameIsFree:self.textAuthor.text])
            {
                [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] createMusicianWithName:self.textAuthor.text];
            }
            else
            {
                UIAlertView *alertName = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Такой автор уже существует!"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertName show];
            }
        }
        //check that year is number or empty
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setAllowsFloats:NO];
        NSNumber *resultYear = [numberFormatter numberFromString:self.textYear.text];
        
        if ([self.textYear.text length] > 0 && resultYear == nil)
        {
            UIAlertView *alertYear = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Год не является числом!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertYear show];
        }
        else
        {
            //check that album name is unique && not empty
            if (![self.textName.text length] > 0)
            {
                UIAlertView *alertName = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Название обязательно!"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertName show];
            }
            else
            {
                //last check
                BOOL temp = [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] albumNameIsFree:self.textName.text owner:tempMusician];
                if (temp)
                {
                    //save album
                    [(MCAppDelegate *)[[UIApplication sharedApplication] delegate]
                     createAlbumWithName:self.textName.text
                     year:[NSNumber numberWithInt:[self.textYear.text intValue]]
                     imageURL:imageName];
                    [(MCAppDelegate *)[[UIApplication sharedApplication] delegate] addAlbumWithName:self.textName.text forMusicianWithName:self.textAuthor.text];
                    
                    //notify delegate
                    if (self.delegateNewAlbum != nil)
                    {
                        [self.delegateNewAlbum didCreatedNewAlbum:YES];
                    }
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    UIAlertView *alertName = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Такое название уже существует!"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertName show];
                }
            }
        }
    }
}
@end
