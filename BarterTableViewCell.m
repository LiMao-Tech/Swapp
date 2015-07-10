//
//  BarterTableViewCell.m
//  Swapp
//
//  Created by Gawain Tsao on 7/9/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

@import UIKit;

#import "BarterTableViewCell.h"


@implementation BarterTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //[self setBackgroundColor: [UIColor greenColor]];
    [self.barterItemImage setBackgroundColor:[UIColor grayColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
