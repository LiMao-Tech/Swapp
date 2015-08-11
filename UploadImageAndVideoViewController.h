//
//  UploadImageAndVideoViewController.h
//  Swapp
//
//  Created by Yifang Zhang on 7/28/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "YoukuUploader.h"
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface UploadImageAndVideoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, YoukuUploaderDelegate, UIWebViewDelegate, ELCImagePickerControllerDelegate>


@property NSMutableArray *chosenImages;
@property NSInteger counter;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;



//更新进度
- (void) onProgressUpdate:(int)progress;
//上传成功
- (void) onSuccess:(NSString*)vid;
//上传失败
- (void) onFailure:(NSDictionary*)response;

@end
