//
//  TravelDetailViewController.m
//  CarTracing
//
//  Created by sogou on 15/12/1.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

#import "TravelDetailViewController.h"

@interface TravelDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *leftContentView;
@property (weak, nonatomic) IBOutlet UIView *rightContentView;

@end

@implementation TravelDetailViewController

@synthesize imgView;
@synthesize leftContentView;
@synthesize rightContentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    imgView.layer.borderColor = [UIColor grayColor].CGColor;
    imgView.layer.borderWidth = 3.0f;
    
    leftContentView.layer.borderColor = [UIColor grayColor].CGColor;
    leftContentView.layer.borderWidth = 3.0f;
    
    rightContentView.layer.borderColor = [UIColor grayColor].CGColor;
    rightContentView.layer.borderWidth = 3.0f;
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
