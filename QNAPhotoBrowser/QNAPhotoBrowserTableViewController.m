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

static NSString *QNAPhotoCellIdentifier = @"PhotoCellIdentifier";


@interface QNAPhotoBrowserTableViewController ()

@property (nonatomic, strong) NSArray *aryData;
@property (nonatomic, strong) QNADataManager *dataManager;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation QNAPhotoBrowserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.dataManager = [[QNADataManager alloc] init];

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

    cell.titleLabel.text = (record.photoName) ? record.photoName: @"Default";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *description = [NSString stringWithFormat:@"%@", record.photoDescription];

    cell.descriptionTextView.text = (record.photoDescription) ? description : @"Default";

    cell.photoImageView.image = [UIImage imageNamed:@"defaultImage"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        [self.dataManager startDownloadImage:record photoDataReady:^(NSData *data) {

            dispatch_async(dispatch_get_main_queue(), ^{

                if (!data) {
                    cell.descriptionTextView.text = (record.photoDescription) ? [NSString stringWithFormat:@"[Image Fail] %@", record.photoDescription] : @"Default";
                }
                cell.photoImageView.image = [UIImage imageWithData: data];
            });
        }];

    });


    [cell.contentView layoutIfNeeded];

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


@end
