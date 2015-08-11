//
//  AppDelegate.h
//  Swapp
//
//  Created by Gawain Tsao on 7/6/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "AFNetworking.h"
#import "WXApi.h"
#import "WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate, WeiboSDKDelegate>
{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong) Reachability * networkManager;

@property CGFloat SCREEN_WIDTH;
@property CGFloat SCREEN_HEIGHT;

@property AFHTTPRequestOperationManager *AFNManager;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

@end
