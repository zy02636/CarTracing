//
//  HistoryTableViewController.m
//  CarTracing
//
//  Created by li pengxuan on 15/11/3.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "TravelHistoryCell.h"
#import "TravelDetailViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CarTracing-Swift.h"
#import "TravelDetailViewController.h"

static NSString *cellIdentifier = @"TracelHistoryCell";

@interface HistoryTableViewController ()

@property (nonatomic, retain) NSMutableArray* travelHistoryArray;

@end

@implementation HistoryTableViewController

@synthesize travelHistoryArray;

- (id) init {
    travelHistoryArray = [NSMutableArray arrayWithCapacity:20];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //自定义视图
    [self customSubViews];
    
    //取数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    travelHistoryArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:@"saveDataArray"]];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customSubViews {
    
    //Bar
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(backHome)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"TravelHistoryCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return travelHistoryArray.count;
}


#pragma mark - Private Functions
- (void)backHome {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TravelHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *dataDic = [travelHistoryArray objectAtIndex:indexPath.row];
    [cell dealWithData:dataDic];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
//    NSString *idStr = [NSString stringWithFormat: @"My id is: %ld", (long)[indexPath row]];
//    TravelDetailViewController* detailViewController = [[TravelDetailViewController alloc] initWithTravelId:idStr];
//    
//    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
    //NSDictionary *locationDic = [travelHistoryArray objectAtIndex:indexPath.row];
    //HistoryLocationsViewController *locationViewController = [[HistoryLocationsViewController alloc] initWithNibName:@"HistoryLocationsViewController" bundle:nil];
    //NSArray *locations = locationDic[@"locations"];
    //locationViewController.dataArray = locations;
    
    
    NSDictionary *dataDic = [travelHistoryArray objectAtIndex:indexPath.row];
    TravelDetailViewController* travelDetailViewController = [[TravelDetailViewController alloc] initWithNibName:@"TravelDetailViewController" bundle:nil];
    travelDetailViewController.dataDic = dataDic;
    [self.navigationController pushViewController:travelDetailViewController animated:YES];

    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
