//
//  AppDelegate.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/10/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

#import "topAlertMessageVC.h"

@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate,FIRMessagingDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) topAlertMessageVC *topAlert;


@end

