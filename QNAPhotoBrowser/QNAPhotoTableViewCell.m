//
//  QNAPhotoTableViewCell.m
//  QNAPhotoBrowser
//
//  Created by QueenaHuang on 14/2/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

#import "QNAPhotoTableViewCell.h"
#import "Masonry.h"

@implementation QNAPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.descriptionTextView setScrollEnabled:NO];
    [self.descriptionTextView setEditable:NO];
    [self.descriptionTextView setSelectable:NO];

    [self.photoImageView setContentMode:UIViewContentModeScaleAspectFit];

    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);

    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(padding.right);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.equalTo(@150);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(padding.right);
        make.top.equalTo(self.photoImageView.mas_bottom).offset(padding.top);
        make.height.equalTo(@(CGRectGetHeight(self.titleLabel.frame)));
    }];

    [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(padding.right);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(padding.bottom);
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
