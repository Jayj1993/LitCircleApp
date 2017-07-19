//
//  NotificationsVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 1/25/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblNotifications;
- (IBAction)optionSelected:(UISegmentedControl *)sender;

@end
