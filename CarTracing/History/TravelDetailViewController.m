//
//  TravelDetailViewController.m
//  CarTracing
//
//  Created by sogou on 15/12/1.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

#import "TravelDetailViewController.h"
#import "MapKit/MapKit.h"

static NSString *cellIdentifier = @"HistoryLocationCell";

@interface TravelDetailViewController () <UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate>


@property (nonatomic, weak) IBOutlet UILabel* timeLabel;
@property (nonatomic, weak) IBOutlet UILabel* distLabel;
@property (nonatomic, weak) IBOutlet UILabel* costLabel;
@property (nonatomic, weak) IBOutlet UITableView* locationTableView;

@property (weak, nonatomic) IBOutlet UIView *topCotentView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *leftContentView;
@property (weak, nonatomic) IBOutlet UIView *rightContentView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TravelDetailViewController


@synthesize leftContentView;
@synthesize rightContentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customSubViews];
    [self dealWithData:self.dataDic];
}

- (void)customSubViews {

    [_locationTableView registerNib:[UINib nibWithNibName:@"TravelDetailCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [_locationTableView setEstimatedRowHeight:100];
    [_locationTableView setRowHeight:UITableViewAutomaticDimension];
}

- (void)dealWithData:(NSDictionary *)dataDic {
    
    //Data
    NSDate *finishTime    = [dataDic objectForKey:@"finish"];
    NSNumber* distNum = [dataDic objectForKey:@"distance"];
    NSInteger distInt = [distNum integerValue];
    NSString* costStr     = [[dataDic objectForKey:@"seconds"] stringValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone    = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy.M.d h点m分"];
    NSString *stringTime    = [formatter stringFromDate:finishTime];
    NSString* distFormatStr = [NSString stringWithFormat:@"驾驶%ld米", (long)distInt];
    NSString* costFormatStr = [NSString stringWithFormat:@"耗时%@秒", costStr];
    self.dataArray = [NSMutableArray arrayWithArray:[dataDic objectForKey:@"locations"]];
    
    //Label
    self.timeLabel.text = stringTime;
    self.distLabel.text = distFormatStr;
    self.costLabel.text = costFormatStr;

    //Tableview
    
    [self.locationTableView reloadData];
    
    //Map
    self.mapView.delegate = self;
    
    for (NSDictionary *locationDic in self.dataArray) {
        NSNumber *laNum = locationDic[@"latitude"];
        NSNumber *longNum = locationDic[@"longitude"];
        MKPointAnnotation *pointAnnotation = nil;
        pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(laNum.floatValue, longNum.floatValue);
        [self.mapView addAnnotation:pointAnnotation];
    }
    
    MKCoordinateRegion region = [self mapRegion];
    [self.mapView setRegion:region animated:YES];

    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    NSDictionary *locationDic = [_dataArray objectAtIndex:indexPath.row];
    NSNumber *laNum = locationDic[@"latitude"];
    NSNumber *longNum = locationDic[@"longitude"];

    NSString *latitudeStr = [NSString stringWithFormat:@"%.4f",laNum.floatValue];
    NSString *longitudeStr = [NSString stringWithFormat:@"%.4f",longNum.floatValue];
    cell.locationLabel.text = [NSString stringWithFormat:@"%@, %@",latitudeStr, longitudeStr];

    
    
    //GLGeocoder limit: 1 request in 1 minute
    
//    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:laNum.floatValue longitude:longNum.floatValue];
//    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
//
//        if (error){
//            cell.locationStrLabel.text = @"GeoCoder Error";
//            NSLog(@"Geocode failed with error: %@", error);
//        }else {
//            CLPlacemark *placeMark=[placemarks objectAtIndex:0];
//            cell.locationStrLabel.text = placeMark.name;
//        }
//        
//    }];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *locationDic = [_dataArray objectAtIndex:indexPath.row];
    CGFloat lat = [(NSNumber *)locationDic[@"latitude"] floatValue];
    CGFloat lng = [(NSNumber *)locationDic[@"longitude"] floatValue];
  
    CLLocationCoordinate2D regionCenter = CLLocationCoordinate2DMake(lat, lng);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.007, 0.007);
    [self.mapView setRegion:MKCoordinateRegionMake(regionCenter, span) animated:YES];
    
}

//画线路可视Region

- (MKCoordinateRegion) mapRegion {
    NSDictionary *firstLocationDic = self.dataArray[0];
    CGFloat minLat = [(NSNumber *)firstLocationDic[@"latitude"] floatValue];
    CGFloat minLng = [(NSNumber *)firstLocationDic[@"longitude"] floatValue];
    CGFloat maxLat = minLat;
    CGFloat maxLng = minLng;


    for (NSDictionary *location in self.dataArray) {
        CGFloat tempLat = [(NSNumber *)location[@"latitude"] floatValue];
        CGFloat tempLng = [(NSNumber *)location[@"longitude"] floatValue];
        minLat = MIN(minLat, tempLat);
        minLng = MIN(minLng, tempLng);
        maxLat = MAX(maxLat, tempLat);
        maxLng = MAX(maxLng, tempLng);
    }
    
    CLLocationCoordinate2D regionCenter = CLLocationCoordinate2DMake((minLat + maxLat)/2, (minLng + maxLng)/2);
    MKCoordinateSpan span = MKCoordinateSpanMake((maxLat - minLat)*1.5, (maxLng - minLng)*1.5);
    
    return MKCoordinateRegionMake(regionCenter, span);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
