//
//  TravelHistoryCell.m
//  CarTracing
//
//  Created by sogou on 15/11/3.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

#import "TravelHistoryCell.h"

@implementation TravelHistoryCell
{
    UILabel* timeLabel;
    UILabel* distLabel;
    UILabel* costLabel;
    UIImageView* imgView;
}


- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customSubViews];
    }
    return self;
    
}


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        
    }
    return self;
}



- (void)customSubViews {
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    [timeLabel setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:timeLabel];
    
    distLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 10, 50, 20)];
    [distLabel setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:distLabel];
    
    costLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 10, 150, 20)];
    [costLabel setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:costLabel];
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 200, 150)];
    [self.contentView addSubview:imgView];
    

}

- (void)dealWithData:(NSDictionary *)dataDic {


     NSDate *finishTime    = [dataDic objectForKey:@"finish"];
     NSString* distStr     = [[dataDic objectForKey:@"distance"] stringValue];
     NSString* costStr     = [[dataDic objectForKey:@"seconds"] stringValue];
     
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     NSTimeZone *timeZone    = [NSTimeZone localTimeZone];
     [formatter setTimeZone:timeZone];
     [formatter setDateFormat : @"yyyy年M月d日 h点m分"];
     NSString *stringTime    = [formatter stringFromDate:finishTime];
     NSString* distFormatStr = [NSString stringWithFormat:@"驾驶%@米", distStr];
     NSString* costFormatStr = [NSString stringWithFormat:@"耗时%@秒", costStr];
    
     timeLabel.text = stringTime;
     distLabel.text = distFormatStr;
     costLabel.text = costFormatStr;
     
     UIImage* pathImg     = [UIImage imageWithContentsOfFile:[dataDic objectForKey:@"image"]];
     [imgView setImage:pathImg];
    

}

- (void)prepareForReuse {
    [super prepareForReuse];
    for(UIView *subview in [self.contentView subviews]) {
        [subview removeFromSuperview];
    }
}

@end
