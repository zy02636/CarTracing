//
//  TravelHistoryCell.m
//  CarTracing
//
//  Created by sogou on 15/11/3.
//  Copyright © 2015年 li pengxuan. All rights reserved.
//

#import "TravelHistoryCell.h"

@implementation TravelHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    for(UIView *subview in [self.contentView subviews]) {
        [subview removeFromSuperview];
    }
}

@end
