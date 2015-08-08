//
//  UploadImageAndVideoViewController.m
//  Swapp
//
//  Created by Yifang Zhang on 7/28/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import "UploadImageAndVideoViewController.h"

#import "AppDelegate.h"
#import "CommonImports.h"


@interface UploadImageAndVideoViewController ()

@end

static NSString * username = @"13142061115";
static NSString * password = @"Abcd1234";
static NSString * client_id = @"1b90441167c89500";
static NSString * client_secret = @"ed1de4139222e9f8fcc5583771209916";
static NSString * redirect_url = @"http://www.limao-tech.com/";
//@"http://www.code-desire.com.tw/joe/YoukuUpload/OAuth/";



@implementation UploadImageAndVideoViewController
{
    
    NSString *mediaURL;
    NSString *access_token;
    UILabel * accessTokenLabel;
    UIProgressView * progressBar;
    //NSString * myCode;
    //NSString * refresh_token;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //access_token = @"783407f4ab60d5e45c40099515ea35ae";
    
    //get access token label
    accessTokenLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 250, 200, 60)];
    accessTokenLabel.numberOfLines = 2;
    accessTokenLabel.text = @"No Access Code";
    [self.view addSubview:accessTokenLabel];
    
    //get progress bar
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressBar.frame = CGRectMake(40, 300, 200, 60);
    progressBar.progress = 0.0f;
    progressBar.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:progressBar];
    
    //[self selectAccessToken];
    [self getAccessToken];
    
    self.chosenImages = [[NSMutableArray alloc] init];
    [self selectPhotoButton];
    
    if (!access_token) {
        NSLog(@"cant upload video yet");
    }
    [self selectVideosButton];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Related

-(void)selectPhotoButton{
    
    UIButton *getmedia_video=[[UIButton alloc]initWithFrame:CGRectMake(40, 100, 100, 30)];
    [getmedia_video setTitle:@"上传图片" forState:UIControlStateNormal];
    [getmedia_video setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [getmedia_video.layer setBorderWidth:2];
    [getmedia_video.layer setBorderColor:[[UIColor redColor] CGColor]];
    [getmedia_video addTarget:self action:@selector(LocalPhoto) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:getmedia_video];
    
}

-(void)selectVideosButton{
    
    UIButton *getmedia_video=[[UIButton alloc]initWithFrame:CGRectMake(40, 150, 100, 30)];
    [getmedia_video setTitle:@"上传视频" forState:UIControlStateNormal];
    [getmedia_video setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [getmedia_video.layer setBorderWidth:2];
    [getmedia_video.layer setBorderColor:[[UIColor redColor] CGColor]];
    [getmedia_video addTarget:self action:@selector(LocalVideos) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:getmedia_video];
    
}

/*-(void)selectAccessToken{
    
    UIButton *getmedia_accessToken=[[UIButton alloc]initWithFrame:CGRectMake(40, 200, 100, 30)];
    [getmedia_accessToken setTitle:@"获取token" forState:UIControlStateNormal];
    [getmedia_accessToken setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [getmedia_accessToken.layer setBorderWidth:2];
    [getmedia_accessToken.layer setBorderColor:[[UIColor redColor] CGColor]];
    [getmedia_accessToken addTarget:self action:@selector(getAccessToken) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:getmedia_accessToken];
    
}*/

#pragma mark - Image Related

- (void) LocalPhoto{
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 3; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image
    //and movie types -- (NSString *)kUTTypeMovie
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    
}

#pragma mark ELCImagePickerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    
    
    for (NSDictionary * tempDict in info) {
        if ([tempDict objectForKey:UIImagePickerControllerOriginalImage]){
            UIImage* tempImg = [tempDict objectForKey:UIImagePickerControllerOriginalImage];
            NSData *dataImage = UIImageJPEGRepresentation(tempImg, 1);
            [self.chosenImages addObject:dataImage];
            NSLog(@"one photo is reconstructed");
        }
        else{
            NSLog(@"this is not an image");
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self postImages];
    
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark AFNetworking Upload Images

- (void)postImages {
    
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //APPDELEGATE.AFNManager;
    //上传的字典
    //NSDictionary *parameters = @{@"orderno":@"1419486171570"};
    //上传的本地路径
    //NSURL *filePath = [NSURL fileURLWithPath:_imgPath];
    APPDELEGATE.AFNManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //上传的网上路径
    [APPDELEGATE.AFNManager POST:@"http://www.code-desire.com.tw/LiMao/upload/Yifang/testUpload.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //上传图片的本地路径和上传图片的文件名
        //NSInteger * counter = 0;
        for (NSData *imageData in self.chosenImages) {
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image%ld", (long)self.counter] fileName:[NSString stringWithFormat:@"image%ld.jpg", (long)self.counter] mimeType:@"image/jpeg"];
            self.counter = self.counter + 1;
            NSLog(@"image%ld.jpg is going to be uploaded", (long)self.counter);
        }
        //[formData appendPartWithFileURL:filePath name:@"rpf" error:nil];
        // NSLog(@"%@",filePath);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        //NSString *message = responseObject[@"message"];
        //NSLog(@"message:%@",message);
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"successfully upload" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        self.chosenImages = [[NSMutableArray alloc] init];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"failed to upload" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        self.chosenImages = [[NSMutableArray alloc] init];
    }];
    
}


#pragma mark - Videos Related

//打开本地相册获取视频
-(void)LocalVideos

{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    [self presentViewController:picker animated:YES completion:nil];
}

//本地相册选择视频之后触发
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断是否视频文件
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        //获取视频文件的url
        NSURL *mediaUrltmp = [info objectForKey:UIImagePickerControllerMediaURL];
        mediaURL=[mediaUrltmp absoluteString];
        mediaURL=[mediaURL substringFromIndex:7];
        
        [self uploadYoukuVideos];
        
        //UIAlertView *loadorwatch=[[UIAlertView alloc]initWithTitle:@"同时" message:@"请问是想观看还是想上传" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"上传", nil];
        //[loadorwatch show];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //上传
    if (buttonIndex==1)
    {
        [self uploadYoukuVideos];
    }
}
*/

#pragma mark Upload to Youku function TODO: Warning for JSON Parsing

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
        accessTokenLabel.text = access_token;
        //}
       
        
    }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    

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

#pragma mark - Additional Helper Functions

-(void)alert:(NSString *)contents withtitle:(NSString *)title
{
    UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:title message:contents delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alerta show];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
