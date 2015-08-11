//
//  SelectImageViewController.h
//  AGShareSDKDemo
//
//  Created by TDS on 7/24/15.
//  Copyright (c) 2015 vimfung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface SelectImageViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;
- (IBAction)sliderChange:(id)sender;
- (IBAction)changeFilter:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *sliderValue;
-(CIImage *)oldPhoto:(CIImage *)img withAmount:(float)intensity;
@property (nonatomic) int filterIndex;
@end
