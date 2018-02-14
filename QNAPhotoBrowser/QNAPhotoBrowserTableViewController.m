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
@end

@implementation QNAPhotoBrowserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    QNAPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QNAPhotoCellIdentifier forIndexPath:indexPath];

    QNAPhotoRecord *record = [self.aryData objectAtIndex: indexPath.row];


    cell.photoImageView.backgroundColor = [UIColor grayColor];
    cell.titleLabel.text = (record.photoName) ? record.photoName: @"Default";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *description = [NSString stringWithFormat:@"%@", record.photoDescription];

    if (!record.photoURLString) {
        description = [NSString stringWithFormat:@"[No Image] %@", record.photoDescription];
    }

    cell.descriptionTextView.text = (record.photoDescription) ? description : @"Default";

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

    return cell;
}

@end
