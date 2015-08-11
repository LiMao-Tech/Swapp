//
//  SelectImageViewController.m
//  AGShareSDKDemo
//
//  Created by TDS on 7/24/15.
//  Copyright (c) 2015 vimfung. All rights reserved.
//

/* general importing */
#import "AppDelegate.h"
#import "CommonImports.h"

#import "SelectImageViewController.h"
#import "ShareHelperFunctions.h"
#import "SWRevealViewController.h"



@interface SelectImageViewController ()

@end

@implementation SelectImageViewController{
    CIContext *context;
    CIFilter *filter;
    CIImage *beginImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.counter = 0;
    self.filterIndex = 0;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    
    // setup sidebar menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark imagepicker Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    beginImage = [CIImage imageWithData:UIImagePNGRepresentation(chosenImage)];
    
    context = [CIContext contextWithOptions:nil];
    filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", @0.8, nil];
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg =
    [context createCGImage:outputImage fromRect:[outputImage extent]];
    // 4
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
    
    //self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(CIImage *)oldPhoto:(CIImage *)img withAmount:(float)intensity {
    
    // 1
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
    [sepia setValue:img forKey:kCIInputImageKey];
    [sepia setValue:@(intensity) forKey:@"inputIntensity"];
    
    // 2
    CIFilter *random = [CIFilter filterWithName:@"CIRandomGenerator"];
    
    // 3
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:random.outputImage forKey:kCIInputImageKey];
    [lighten setValue:@(1 - intensity) forKey:@"inputBrightness"];
    [lighten setValue:@0.0 forKey:@"inputSaturation"];
    
    // 4
    CIImage *croppedImage = [lighten.outputImage imageByCroppingToRect:[beginImage extent]];
    
    // 5
    CIFilter *composite = [CIFilter filterWithName:@"CIHardLightBlendMode"];
    [composite setValue:sepia.outputImage forKey:kCIInputImageKey];
    [composite setValue:croppedImage forKey:kCIInputBackgroundImageKey];
    
    // 6
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
    [vignette setValue:composite.outputImage forKey:kCIInputImageKey];
    [vignette setValue:@(intensity * 2) forKey:@"inputIntensity"];
    [vignette setValue:@(intensity * 30) forKey:@"inputRadius"];
    
    // 7
    return vignette.outputImage;
}

- (IBAction)shareWechat:(id)sender {
    [ShareHelperFunctions shareToWechat:self.imageView.image];
}

- (IBAction)shareWeibo:(id)sender {
    [ShareHelperFunctions shareToWeibo:self.imageView.image];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)sliderChange:(UISlider *)slider {
    float slideValue = slider.value;
    CIImage *outputImage;
    if(!self.filterIndex){
        [filter setValue:@(slideValue)
                  forKey:@"inputIntensity"];
        outputImage = [filter outputImage];
    }
    else{
        outputImage = [self oldPhoto:beginImage withAmount:slideValue];
    }
    
    CGImageRef cgimg = [context createCGImage:outputImage
                                     fromRect:[outputImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
}

- (IBAction)changeFilter:(id)sender {
    if(!self.filterIndex){
        self.filterIndex = 1;
        CIImage *outputImage = [self oldPhoto:beginImage withAmount:self.sliderValue.value];
        CGImageRef cgimg = [context createCGImage:outputImage
                                         fromRect:[outputImage extent]];
        
        UIImage *newImage = [UIImage imageWithCGImage:cgimg];
        self.imageView.image = newImage;
        
        CGImageRelease(cgimg);
    }
    else{
        self.filterIndex = 0;
        [filter setValue:@(self.sliderValue.value)
                  forKey:@"inputIntensity"];
        CIImage *outputImage = [filter outputImage];
        
        CGImageRef cgimg = [context createCGImage:outputImage
                                         fromRect:[outputImage extent]];
        
        UIImage *newImage = [UIImage imageWithCGImage:cgimg];
        self.imageView.image = newImage;
        
        CGImageRelease(cgimg);
    }
    
}

#pragma mark upload image for Yifang

- (IBAction)uploadImages:(id)sender {
    
    // 1. save the modified images
    UIImage* tempImg = self.imageView.image;
    NSData *dataImage = UIImageJPEGRepresentation(tempImg, 1);
    [self.chosenImages addObject:dataImage];
    NSLog(@"one photo is reconstructed");
    
    // 2. self upload
    [self postImages];
    
}

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


@end
