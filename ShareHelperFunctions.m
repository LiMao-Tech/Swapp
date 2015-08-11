//
//  ShareHelperFunctions.m
//  TestProject
//
//  Created by TDS on 8/11/15.
//  Copyright (c) 2015 Matthew Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareHelperFunctions.h"
#import "AppDelegate.h"

@implementation ShareHelperFunctions

+(void)shareToWeibo:(UIImage *)image {
    WBMessageObject *message = [WBMessageObject message];
    
    
    WBImageObject *WBImage = [WBImageObject object];
    WBImage.imageData = UIImagePNGRepresentation(image);
    message.imageObject = WBImage;
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://github.com/LiMao-Tech/Swapp";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"TestProject",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

+(void)shareToWechat:(UIImage *)image {
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"The Weixin app is not installed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    //create a message object
    WXMediaMessage *message = [WXMediaMessage message];
    //set the thumbnail image. This MUST be less than 32kb, or sendReq may return NO.
    //we'll just use the full image resized to 100x100 pixels for now
    CGSize size = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [message setThumbImage:image];
    //create an image object and set the image data as a JPG representation of our UIImage
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(image, 0.8);
    message.mediaObject = ext;
    //create a request
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    //this is a multimedia message, not a text message
    req.bText = NO;
    //set the message
    req.message = message;
    //set the "scene", WXSceneTimeline is for "moments". WXSceneSession allows the user to send a message to friends
    req.scene = WXSceneTimeline;
    //try to send the request
    if (![WXApi sendReq:req]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}


#pragma mark -
#pragma WBHttpRequestDelegate

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"收到网络回调", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}

@end

