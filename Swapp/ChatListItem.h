//
//  ChatListItem.h
//  Swapp
//
//  Created by gt on 15/7/23.
//  Copyright (c) 2015年 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListItem : UITableViewCell
{
    UILabel *messageLabel;
    UILabel *userLabel;
}
@property(nonatomic,strong) IBOutlet UILabel *messageLabel;
@property(nonatomic,strong) IBOutlet UILabel *userLabel;
@end
