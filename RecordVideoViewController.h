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

#import "YoukuUploader.h"

@interface RecordVideoViewController : UIViewController <YoukuUploaderDelegate>

@property (strong, nonatomic) NSURL *videoURL;
@property (retain, nonatomic) IBOutlet MPMoviePlayerController *videoController;

- (IBAction)recordVideo:(id)sender;
- (IBAction)selectVideo:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *uiview;

/* Yifang Upload to Youku */
- (IBAction)uploadVideo:(id)sender;

//更新进度
- (void) onProgressUpdate:(int)progress;
//上传成功
- (void) onSuccess:(NSString*)vid;
//上传失败
- (void) onFailure:(NSDictionary*)response;


@end
