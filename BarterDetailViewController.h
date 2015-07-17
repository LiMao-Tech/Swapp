//
//  BarterDetailViewController.h
//  Swapp
//
//  Created by Yumen Cao on 7/12/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarterDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *unlikeButton;

- (IBAction)likeAction:(id)sender;
- (IBAction)unlikeAction:(id)sender;


@end
