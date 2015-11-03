//
//  TravelDetailViewController.m
//  CarTracing
//
//  Created by sogou on 15/11/3.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

#import "TravelDetailViewController.h"

@interface TravelDetailViewController ()

@property (nonatomic, retain) IBOutlet UILabel* infoLabel;
@property (nonatomic, retain) IBOutlet UIButton* closeBtn;
@property (nonatomic, copy)  NSString* idStr;

@end


@implementation TravelDetailViewController

@synthesize infoLabel;
@synthesize idStr;

- (id) initWithTravelId:(NSString*)travelID {
    self = [super initWithNibName:@"TravelDetailViewController" bundle:nil];
    idStr = travelID;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    infoLabel.text = idStr;
}

- (IBAction)closeTravelDetail:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
