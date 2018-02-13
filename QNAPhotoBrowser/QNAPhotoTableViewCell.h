//
//  QNAPhotoTableViewCell.h
//  QNAPhotoBrowser
//
//  Created by QueenaHuang on 14/2/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNAPhotoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;


@end
