//
//  QNAPhotoBrowserTableViewController.m
//  QNAPhotoBrowser
//
//  Created by QueenaHuang on 14/2/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

#import "QNAPhotoBrowserTableViewController.h"
#import "QNAPhotoTableViewCell.h"
#import "QNADataManager.h"
#import "QNAPhotoRecord.h"
#import "Masonry.h"

static NSString *QNAPhotoCellIdentifier = @"PhotoCellIdentifier";


@interface QNAPhotoBrowserTableViewController ()

@property (nonatomic, strong) NSArray *aryData;
@property (nonatomic, strong) QNADataManager *dataManager;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation QNAPhotoBrowserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.dataManager = [[QNADataManager alloc] init];
    self.imageCache = [[NSCache alloc] init];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        [self.dataManager requestJSONData:^(NSString *title, NSArray *results) {
            dispatch_async(dispatch_get_main_queue(), ^{

                self.navigationItem.title = title;
                self.aryData = results;

                [self.tableView reloadData];
            });
        }];

    });

    [self setUpRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.aryData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    QNAPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QNAPhotoCellIdentifier forIndexPath:indexPath];

    QNAPhotoRecord *record = [self.aryData objectAtIndex: indexPath.row];

    cell.titleLabel.text = (record.photoName) ? record.photoName: @"None";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *description = [NSString stringWithFormat:@"%@", record.photoDescription];

    cell.descriptionTextView.text = (record.photoDescription) ? description : @"None";

    cell.photoImageView.image = [UIImage imageNamed:@"defaultImage"];


    // Using cache to save image.
    UIImage *image = [self.imageCache objectForKey:record.photoURLString];

    if (image) {
        NSLog(@"Use cache");
        cell.photoImageView.image = image;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

            NSURL *url = [[NSURL alloc] initWithString:record.photoURLString];
            NSData *data = [NSData dataWithContentsOfURL:url];

            dispatch_async(dispatch_get_main_queue(), ^{
                if (!data) {
                    cell.photoImageView.image = [UIImage imageNamed:@"imageError"];
                } else {
                    UIImage *image = [UIImage imageWithData: data];
                    [self.imageCache setObject:image forKey:record.photoURLString];

                    NSLog(@"Svae cache");
                    cell.photoImageView.image = image;
                }

            });
        });
    }

    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);

    // For iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        CGFloat space = CGRectGetWidth([UIScreen mainScreen].bounds)/3;

        padding = UIEdgeInsetsMake(10, space, -10, -space);
    }

    [cell.photoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(padding.left);
        make.right.equalTo(cell.contentView.mas_right).offset(padding.right);
        make.top.equalTo(cell.contentView.mas_top).offset(padding.top);
        make.height.equalTo(@150);
    }];

    [cell.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(padding.left);
        make.right.equalTo(cell.contentView.mas_right).offset(padding.right);
        make.top.equalTo(cell.photoImageView.mas_bottom).offset(padding.top);
        make.height.equalTo(@(CGRectGetHeight(cell.titleLabel.frame)));
    }];

    [cell.descriptionTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(padding.left);
        make.right.equalTo(cell.contentView.mas_right).offset(padding.right);
        make.top.equalTo(cell.titleLabel.mas_bottom);
        make.bottom.equalTo(cell.contentView.mas_bottom).offset(padding.bottom);
    }];

    [cell setNeedsDisplay];
    [cell layoutIfNeeded];

    return cell;
}

#pragma mark - UI

- (void)setUpRefreshControl {

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - Action Handler

- (void)refreshTable
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - UIViewControllerRotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        [self.tableView reloadData];
    } completion:nil];

}

@end
