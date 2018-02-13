//
//  QNAPhotoBrowserTableViewController.m
//  QNAPhotoBrowser
//
//  Created by QueenaHuang on 14/2/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

#import "QNAPhotoBrowserTableViewController.h"
#import "QNAPhotoTableViewCell.h"

static NSString *photoCellIdentifier = @"PhotoCellIdentifier";

@interface QNAPhotoBrowserTableViewController ()

@property (nonatomic, strong) NSArray* aryData;

@end

@implementation QNAPhotoBrowserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.aryData = @[@{
                         @"title":@"Beavers",
                         @"description":@"Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony",
                         @"imageHref":@"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"
                     },
                     @{
                         @"title":@"Flag",
                         @"description": @"",
                         @"imageHref":@"http://images.findicons.com/files/icons/662/world_flag/128/flag_of_canada.png"
                     },
                     @{
                         @"title":@"Meese",
                         @"description":@"A moose is a common sight in Canada. Tall and majestic, they represent many of the values which Canadians imagine that they possess. They grow up to 2.7 metres long and can weigh over 700 kg. They swim at 10 km/h. Moose antlers weigh roughly 20 kg. The plural of moose is actually 'meese', despite what most dictionaries, encyclopedias, and experts will tell you.",
                         @"imageHref":@"http://caroldeckerwildlifeartstudio.net/wp-content/uploads/2011/04/IMG_2418%20majestic%20moose%201%20copy%20(Small)-96x96.jpg"
                     },
                     @{
                         @"title":@"Public Shame",
                         @"description":@" Sadly it's true.",
                         @"imageHref":@"http://static.guim.co.uk/sys-images/Music/Pix/site_furniture/2007/04/19/avril_lavigne.jpg"
                     },
                     ];


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

    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    QNAPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:photoCellIdentifier forIndexPath:indexPath];

    NSDictionary *dic = [self.aryData objectAtIndex: indexPath.row];

    // Configure the cell...
    cell.photoImageView.backgroundColor = [UIColor grayColor];
    cell.titleLabel.text = [dic objectForKey: @"title"];
    cell.descriptionTextView.text = [dic objectForKey: @"description"];


    return cell;
}

@end
