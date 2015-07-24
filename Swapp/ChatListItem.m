//
//  ChatListItem.m
//  Swapp
//
//  Created by gt on 15/7/23.
//  Copyright (c) 2015年 Limao. All rights reserved.
//

#import "ChatListItem.h"

@implementation ChatListItem

@synthesize messageLabel,userLabel;

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
