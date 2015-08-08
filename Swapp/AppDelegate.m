//
//  AppDelegate.m
//  Swapp
//
//  Created by Gawain Tsao on 7/6/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /* remote notification setting START */
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >=80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        //ios 8
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
#else
    else
    {
        //lower than ios 8
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
#endif
    
    /* remote notification setting ends */
    
    // get screen size
    self.SCREEN_WIDTH = UIScreen.mainScreen.bounds.size.width;
    self.SCREEN_HEIGHT = UIScreen.mainScreen.bounds.size.height;
    
    
    
    // set up AFNetworking manager
    self.AFNManager = [AFHTTPRequestOperationManager manager];
    
    

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - push notification
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    // NSLog(@"My token is: %@", deviceToken);
    
    NSString *device = [deviceToken description];
    device = [device stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    device = [device stringByReplacingOccurrencesOfString:@" " withString:@""];
    // insert into memory
    [[NSUserDefaults standardUserDefaults] setObject:device forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // NSLog(@"Failed to get token, error: %@", error);
}

#pragma mark push notification for ios 8

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive) {
        NSString *cancelTitle = @"Close";
        NSString *showTitle = @"Hide";
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Swapp消息"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:showTitle, nil];
        [alertView show];
        
        
    } else {
        // do nothing
        
    }
    
    
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swapp消息"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}



@end
