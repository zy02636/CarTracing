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

@interface HistoryTableViewController ()

@property (nonatomic, retain) NSMutableArray* travelHistoryArray;
@property (nonatomic, retain) UIViewController* homeView;

@end

@implementation HistoryTableViewController

@synthesize travelHistoryArray;

- (id) initWithHomeView:(UIViewController*)homeView {
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    travelHistoryArray = [NSMutableArray arrayWithCapacity:20];
    [travelHistoryArray addObject:@"北京天气"];
    [travelHistoryArray addObject:@"对象2"];
    [travelHistoryArray addObject:@"对象3"];
    [travelHistoryArray addObject:@"对象4"];

    _homeView = homeView;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //closeBtn.frame = CGRectMake(10, 20, 50, 20);
    //[closeBtn setTitle:@"CLOSE" forState:UIControlStateNormal];
    //[closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 100, 50)];
    //[headerView addSubview:closeBtn];
    //self.tableView.tableHeaderView = headerView;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backHome)];
    self.navigationItem.leftBarButtonItem = backButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return travelHistoryArray.count;
}


#pragma mark - Private Functions
- (void)backHome {
    //[self dismissViewControllerAnimated:YES completion:nil];
//    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
//    
//    [UIView transitionWithView:window
//                      duration:0.5
//                       options:UIViewAnimationOptionTransitionFlipFromLeft
//                    animations:^{ window.rootViewController = _homeView; }
//                    completion:nil];
    
    
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* reuseIdentifier = @"Cell";
    TravelHistoryCell *cell = (TravelHistoryCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[TravelHistoryCell alloc] initWithReuseIdentifier:reuseIdentifier];
        UILabel* distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 150, 20)];
        distanceLabel.text     = @"今天我跑了1W公里.. 牛逼么?";
        [cell addSubview:distanceLabel];
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.travelHistoryArray removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    NSString *idStr = [NSString stringWithFormat: @"My id is: %ld", (long)[indexPath row]];
    TravelDetailViewController* detailViewController = [[TravelDetailViewController alloc] initWithTravelId:idStr];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
