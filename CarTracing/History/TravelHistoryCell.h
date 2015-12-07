//
//  TravelHistoryCell.h
//  CarTracing
//
//  Created by sogou on 15/11/3.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelHistoryCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel* timeLabel;
@property (nonatomic, weak) IBOutlet UILabel* distLabel;
@property (nonatomic, weak) IBOutlet UILabel* costLabel;
@property (nonatomic, weak) IBOutlet UIImageView* imgView;


- (void)dealWithData:(NSDictionary *)dataDic;
@end
