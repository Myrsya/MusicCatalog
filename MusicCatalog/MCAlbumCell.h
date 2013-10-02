//
//  MCAlbumCell.h
//  MusicCatalog
//
//  Created by Gavrina Maria on 02.10.13.
//  Copyright (c) 2013 Gavrina Maria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCAlbumCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageCover;
@property (strong, nonatomic) IBOutlet UILabel *labelAlbumName;

@end
