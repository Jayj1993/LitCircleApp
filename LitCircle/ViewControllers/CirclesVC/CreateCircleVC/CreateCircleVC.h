//
//  CreateCircleVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/14/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateCircleVC : UIViewController
- (IBAction)btnBackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtGroupName;
@property (weak, nonatomic) IBOutlet UITableView *tblUsers;
- (IBAction)btnCreatePressed:(id)sender;

@end
