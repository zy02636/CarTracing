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

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backHome)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //取数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    travelHistoryArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:@"saveDataArray"]];
    [self.tableView reloadData];
    
    
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
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* reuseIdentifier = @"resueCell";
    TravelHistoryCell *cell = (TravelHistoryCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[TravelHistoryCell alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    
    NSDictionary *dataDic = [travelHistoryArray objectAtIndex:indexPath.row];
    NSDate *finishTime    = [dataDic objectForKey:@"finish"];
    NSString* distStr     = [[dataDic objectForKey:@"distance"] stringValue];
    NSString* costStr     = [[dataDic objectForKey:@"seconds"] stringValue];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone    = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy年M月d日 h点m分"];
    NSString *stringTime    = [formatter stringFromDate:finishTime];
    NSString* distFormatStr = [NSString stringWithFormat:@"跑了%@米", distStr];
    NSString* costFormatStr = [NSString stringWithFormat:@"耗时%@秒", costStr];
    
    
    UILabel* timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    timeLabel.text = stringTime;
    [timeLabel setFont:[UIFont systemFontOfSize:13]];
    
    UILabel* distLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 10, 50, 20)];
    distLabel.text = distFormatStr;
    [distLabel setFont:[UIFont systemFontOfSize:13]];
    
    UILabel* costLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 10, 150, 20)];
    costLabel.text = costFormatStr;
    [costLabel setFont:[UIFont systemFontOfSize:13]];
    
    UIImage* pathImg     = [UIImage imageWithContentsOfFile:[dataDic objectForKey:@"image"]];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 200, 150)];
    [imgView setImage:pathImg];
    
    [cell.contentView addSubview:distLabel];
    [cell.contentView addSubview:costLabel];
    [cell.contentView addSubview:timeLabel];
    [cell.contentView addSubview:imgView];
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
//    NSString *idStr = [NSString stringWithFormat: @"My id is: %ld", (long)[indexPath row]];
//    TravelDetailViewController* detailViewController = [[TravelDetailViewController alloc] initWithTravelId:idStr];
//    
//    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
    //NSDictionary *locationDic = [travelHistoryArray objectAtIndex:indexPath.row];
    //HistoryLocationsViewController *locationViewController = [[HistoryLocationsViewController alloc] initWithNibName:@"HistoryLocationsViewController" bundle:nil];
    //NSArray *locations = locationDic[@"locations"];
    //locationViewController.dataArray = locations;
    
    TravelDetailViewController* travelDetailViewController = [[TravelDetailViewController alloc] initWithNibName:@"TravelDetailViewController" bundle:nil];
    [self.navigationController pushViewController:travelDetailViewController animated:YES];

    
    

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
