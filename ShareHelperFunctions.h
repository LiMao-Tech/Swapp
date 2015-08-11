//
//  ShareHelperFunctions.h
//  TestProject
//
//  Created by TDS on 8/11/15.
//  Copyright (c) 2015 Matthew Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <CoreImage/CoreImage.h>
#import "WBHttpRequest.h"

@interface ShareHelperFunctions : NSObject

+(void)shareToWeibo:(UIImage *)image;
+(void)shareToWechat:(UIImage *)image;

@end
