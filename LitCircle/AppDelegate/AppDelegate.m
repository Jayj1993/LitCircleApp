//
//  AppDelegate.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/10/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize topAlert;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [FIRApp configure];

    [Fabric with:@[[Twitter class]]];
    
    [[UITabBar appearance]setTranslucent:NO];
    [[UITabBar appearance]setBackgroundColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0],NSFontAttributeName,[UIColor colorWithRed:210.0/255.0f green:0.0/255.0f blue:148.0/255.0f alpha:1.0],NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    [GMSPlacesClient provideAPIKey:kGooglePlacesApiKey];
    [GMSServices provideAPIKey:kGooglePlacesApiKey];
    
    [self registerForRemoteNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
    topAlert = [[topAlertMessageVC alloc] initWithNibName:@"topAlertMessageVC" bundle:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"LitCircle"];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];    
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    NSString *tok = [[FIRInstanceID instanceID] token];
    if (![tok isKindOfClass:[NSNull class]] || tok !=nil) {
        [[NSUserDefaults standardUserDefaults]setObject:tok forKey:kFriebaseToken];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self connectToFcm];
    }
}

- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"instanceId_tokenRefreshNotification22=>%@",[[FIRInstanceID instanceID] token]);
                });
            });
        }
    }];
}

-(void)registerForRemoteNotifications{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
         }
         ];
        
        // For iOS 10 display notification (sent via APNS)
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
        // For iOS 10 data message (sent via FCM)
        [[FIRMessaging messaging] setRemoteMessageDelegate:self];
#endif
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark - Push Notifications -

// To receive notifications for iOS 9 and below.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    if (application.applicationState==UIApplicationStateActive) {
        [self addMessage:[NSString stringWithFormat:@"%@",[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"]] withTitle:[NSString stringWithFormat:@"%@",[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"]] afterDelay:3.0];
    }
}



// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    [self addMessage:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"] withTitle:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"] afterDelay:3.0];
    
    // Print full message.
    NSLog(@"%@", userInfo);
}

// Receive data message on iOS 10 devices.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", [remoteMessage appData]);
}
#endif


#pragma mark - Notification Displayer

- (void)addMessage:(NSString *)message withTitle:(NSString*)title afterDelay:(float)delayTime {
    topAlert.view.frame = CGRectMake(0, -topAlert.view.frame.size.height, topAlert.view.frame.size.width, topAlert.view.frame.size.height);
    [UIView animateWithDuration:1.0 delay:0.25 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        topAlert.view.center = CGPointMake(topAlert.view.center.x, topAlert.view.frame.size.height/2);}
                     completion:nil];
    
    topAlert.lblTitle.text = title;
    topAlert.lblDescription.text = message;
    
    [self.window addSubview:topAlert.view];
    [self performSelector:@selector(removeMessage) withObject:nil afterDelay:delayTime];
}

- (void)removeMessage {
    if (topAlert.view.superview == self.window) {
        [UIView animateWithDuration:1.0f delay:0.25f options:UIViewAnimationOptionCurveEaseIn animations:^{
            topAlert.view.center = CGPointMake(topAlert.view.center.x, -topAlert.view.frame.size.height/2);
        } completion:^(BOOL finished) {
            if (finished) [topAlert.view removeFromSuperview];
        }];
    }
}

@end
