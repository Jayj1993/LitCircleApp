//
//  TabbarVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/14/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "TabbarVC.h"

@interface TabbarVC ()

@end

@implementation TabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *item4 = [self.tabBar.items objectAtIndex:4];
    
    item.title = @"Feed";
    item1.title = @"Circles";
    item2.title = @"Post";
    item3.title = @"Notifications";
    item4.title = @"Profile";
    
    item.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"searchIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"posticon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"notificationicon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"profileicon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [item setSelectedImage:[[UIImage imageNamed:@"homeselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"searchSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"postSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"notificationSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"profileSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

@end
