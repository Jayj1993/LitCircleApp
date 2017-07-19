//
//  HomeVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/21/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblHome;
- (IBAction)swipeRightPressed:(id)sender;
- (IBAction)btnBackPressed:(id)sender;

@end
