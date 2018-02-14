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
@end

@implementation QNAPhotoBrowserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    QNADataManager *dataManager = [[QNADataManager alloc] init];


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        [dataManager requestJSONData:^(NSString *title, NSArray *results) {
            dispatch_async(dispatch_get_main_queue(), ^{

                self.navigationItem.title = title;
                self.aryData = results;

                NSLog(@"Fetch Data Finish.");
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
    cell.descriptionTextView.text = (record.photoDescription) ? record.photoDescription : @"Default";


    return cell;
}

@end
