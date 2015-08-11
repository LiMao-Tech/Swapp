//
//  AppDelegate.h
//  Swapp
//
//  Created by Gawain Tsao on 7/6/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewDelegate.h"
#import "WXApi.h"
#import "Reachability.h"
#import "AFNetworking.h"

//@class AGViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    enum WXScene _scene;
    ViewDelegate *_viewDelegate;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong) Reachability * networkManager;

@property (nonatomic,readonly) ViewDelegate *viewDelegate;

@property CGFloat SCREEN_WIDTH;
@property CGFloat SCREEN_HEIGHT;

@property AFHTTPRequestOperationManager *AFNManager;

@end
