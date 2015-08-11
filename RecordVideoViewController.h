//
//  RecordVideoViewController.h
//  AGShareSDKDemo
//
//  Created by TDS on 7/24/15.
//  Copyright (c) 2015 vimfung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface RecordVideoViewController : UIViewController

@property (strong, nonatomic) NSURL *videoURL;
@property (retain, nonatomic) IBOutlet MPMoviePlayerController *videoController;
- (IBAction)recordVideo:(id)sender;
- (IBAction)selectVideo:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *uiview;

@end
