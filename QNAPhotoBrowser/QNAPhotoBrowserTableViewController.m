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
static NSInteger QNAMaxNum = 5;


@interface QNAPhotoBrowserTableViewController ()

@property (nonatomic, strong) NSArray *aryData;
@property (nonatomic, strong) QNADataManager *dataManager;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation QNAPhotoBrowserTableViewController
@synthesize refreshControl = _refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 150;

    self.dataManager = [[QNADataManager alloc] init];
    self.imageCache = [[NSCache alloc] init];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        [self.dataManager requestJSONData:0 limit:QNAMaxNum completion:^(NSString *title, NSArray *results) {
            dispatch_async(dispatch_get_main_queue(), ^{

                self.navigationItem.title = title;
                self.aryData = results;

                [self.tableView reloadData];
            });
        }];

    });

    [self setUpRefreshControl];
    [self setUpNavigationUI];
}

- (void)appendItems {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        [self.dataManager requestJSONData:self.aryData.count limit:QNAMaxNum completion:^(NSString *title, NSArray *results) {

            dispatch_async(dispatch_get_main_queue(), ^{

                [self.activityIndicator stopAnimating];
                [self.refreshControl endRefreshing];

                NSMutableArray *aryTemp = [self.aryData mutableCopy];

                if (results.count > 0)
                {
                    [aryTemp addObjectsFromArray:results];
                    self.aryData = aryTemp;
                }

                [self.tableView reloadData];
            });

        }];

    });
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    QNAPhotoRecord *record = [self.aryData objectAtIndex: indexPath.row];

    if (!record.photoURLString) {
        return 0;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    QNAPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QNAPhotoCellIdentifier forIndexPath:indexPath];

    QNAPhotoRecord *record = [self.aryData objectAtIndex: indexPath.row];

    cell.titleLabel.text = (record.photoName) ? record.photoName: @"None";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *description = [NSString stringWithFormat:@"%@", record.photoDescription];

    cell.descriptionTextView.text = (record.photoDescription) ? description : @"None";

    if (!record.photoURLString) {
        cell.hidden = YES;
    } else {

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

- (void)setUpNavigationUI {

    UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onTapRefresh:)];
    self.navigationItem.rightBarButtonItem = refreshButton;


    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setCenter:self.tableView.center];

    [self.activityIndicator setColor:[UIColor orangeColor]];
    [self.view addSubview:self.activityIndicator];
}

#pragma mark - Action Handler

- (void)refreshTable
{
    [self appendItems];
}

-(void)onTapRefresh:(UIBarButtonItem*)item {

    [self.activityIndicator startAnimating];
    [self appendItems];

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
