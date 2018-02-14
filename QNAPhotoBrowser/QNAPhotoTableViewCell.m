//
//  QNAPhotoTableViewCell.m
//  QNAPhotoBrowser
//
//  Created by QueenaHuang on 14/2/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

#import "QNAPhotoTableViewCell.h"

@implementation QNAPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.descriptionTextView setScrollEnabled:NO];
    [self.descriptionTextView setEditable:NO];
    [self.descriptionTextView setSelectable:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
