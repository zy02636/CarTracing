//
//  TravelHistoryCell.m
//  CarTracing
//
//  Created by sogou on 15/11/3.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

#import "TravelHistoryCell.h"

@implementation TravelHistoryCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealWithData:(NSDictionary *)dataDic {

    NSDate *finishTime = [dataDic objectForKey:@"finish"];
    NSNumber* distNum = [dataDic objectForKey:@"distance"];
    NSInteger distInt = [distNum integerValue];
    NSString* costStr = [[dataDic objectForKey:@"seconds"] stringValue];
     
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone    = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy.M.d h点m分"];
    NSString *stringTime = [formatter stringFromDate:finishTime];
    NSString* distFormatStr = [NSString stringWithFormat:@"驾驶%ld米", (long)distInt];
    NSString* costFormatStr = [NSString stringWithFormat:@"耗时%@秒", costStr];
    
    self.timeLabel.text = stringTime;
    self.distLabel.text = distFormatStr;
    self.costLabel.text = costFormatStr;
    
    NSString *imgPath = [dataDic objectForKey:@"image"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imgPath];
    [self.imgView setImage:theImage];
    
}



@end
