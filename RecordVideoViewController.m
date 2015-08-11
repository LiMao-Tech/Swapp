//
//  RecordVideoViewController.m
//  AGShareSDKDemo
//
//  Created by TDS on 7/24/15.
//  Copyright (c) 2015 vimfung. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonImports.h"

#import "RecordVideoViewController.h"



@interface RecordVideoViewController ()

@end

static NSString * username = @"13142061115";
static NSString * password = @"Abcd1234";
static NSString * client_id = @"1b90441167c89500";
static NSString * client_secret = @"ed1de4139222e9f8fcc5583771209916";
static NSString * redirect_url = @"http://www.limao-tech.com/";

@implementation RecordVideoViewController
{
    
    NSString *mediaURL;
    NSString *access_token;
    UIProgressView * progressBar;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAccessToken];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.videoURL = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.videoController = [[MPMoviePlayerController alloc] init];
    [self.videoController setScalingMode:MPMovieScalingModeFill];
    
    [self.videoController setContentURL:self.videoURL];
    [self.videoController.view setFrame:CGRectMake (0, 0, 320, 460)];
    [self.view addSubview:self.videoController.view];
    
    [self.videoController play];
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.videoController];
     */
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
/*
- (void)videoPlayBackDidFinish:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    // Stop the video player and remove it from view
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
    self.videoController = nil;
    
    // Display a message
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Video Playback" message:@"Just finished the video playback. The video is now removed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)recordVideo:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (__bridge NSString *) kUTTypeMovie, nil];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (IBAction)selectVideo:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (__bridge NSString *) kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:NULL];
}



#pragma mark - Upload to Youku function - START

-(void) getAccessToken{
    
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    APPDELEGATE.AFNManager.responseSerializer = [AFJSONResponseSerializer serializer];
    APPDELEGATE.AFNManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /*NSDictionary * params =@{
     @"client_id": client_id,
     @"client_secret": client_secret,
     @"authorization_code": @"grant_type",
     @"redirect_uri": redirect_url,
     @"state": @"yifang"
     };*/
    
    [APPDELEGATE.AFNManager POST:@"http://www.code-desire.com.tw/LiMao/upload/Joe/clsDbManager/youkuAccessTokenGet.aspx" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSString * respondStr = [responseObject objectAtIndex:0];
        NSLog(@"responseObject: %@", responseObject);
        
        //if ([responseObject indexOfObject:@"Status"] == 1) {
        access_token = [responseObject objectForKey:@"AccessToken"];
        NSLog(@"access_token = %@", access_token);
        
        //783407f4ab60d5e45c40099515ea35ae
        //accessTokenLabel.text = access_token;
        //}
        
        
    }
     
                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog(@"Error: %@", error);
                         }];
    
    
    
}


- (IBAction)uploadVideo:(id)sender {
    
    
    //获取视频文件的url
    NSURL *mediaUrltmp = self.videoURL;
    mediaURL=[mediaUrltmp absoluteString];
    mediaURL=[mediaURL substringFromIndex:7];
    
    [self uploadYoukuVideos];
        
        
    
}



-(void) uploadYoukuVideos{
    
    //access_token = @"783407f4ab60d5e45c40099515ea35ae";
    
    
    NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
    [params setObject:client_id forKey:@"client_id"];
    [params setObject:access_token forKey:@"access_token"];
    //优酷账号
    [params setObject:username forKey:@"username"];
    //优酷密码
    [params setObject:password forKey:@"password"];
    
    
    NSMutableDictionary *upload_info_params=[[NSMutableDictionary alloc]init];
    //视频标题
    [upload_info_params setObject:@"testName2" forKey:@"title"];
    //视频标签
    [upload_info_params setObject:@"tags2" forKey:@"tags"];
    //视频本地路径
    [upload_info_params setObject:mediaURL forKey:@"file_name"];
    //视频md5值，经实践，sdk会自己算，所以这里随便传值即可
    [upload_info_params setObject:@"file_md5" forKey:@"file_md5"];
    //视频大小，经实践，sdk会自己算，所以这里随便传值即可
    [upload_info_params setObject:@"file_size" forKey:@"file_size"];
    
    [[YoukuUploader sharedInstance] setClientID:client_id andClientSecret:client_secret];
    
    [[YoukuUploader sharedInstance]upload:params uploadInfo:upload_info_params uploadDelegate:self  dispatchQueue:Nil];
    
    
}

#pragma mark Youku new Delegate Methods

- (void) onStart{
    NSLog(@"on start");
}

//更新进度条
- (void) onProgressUpdate:(int)progress{
    
    float viewPorgress = progress*0.01;
    
    [progressBar setProgress:viewPorgress animated:YES];
    
    NSLog(@"%d%%",progress);
    
    //NSLog(@"aaa");
}


//上传成功
- (void) onSuccess:(NSString*)vid
{
    [self alert:[NSString stringWithFormat:@"upload success,the video id : %@",vid] withtitle:@"now"];
    progressBar.progress = 0.0f;
}


//上传失败
- (void) onFailure:(NSDictionary*)response
{
    [self alert:[NSString stringWithFormat:@"type:%@,desc:%@,code:%@",[response valueForKey:@"type"],[response valueForKey:@"desc"],[response valueForKey:@"code"]] withtitle:@"failed"];
    progressBar.progress = 0.0f;
}


-(void)alert:(NSString *)contents withtitle:(NSString *)title
{
    UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:title message:contents delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alerta show];
}

//#pragma mark Upload to Youku function - END


@end
