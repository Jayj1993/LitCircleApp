//
//  EventRequestVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 4/26/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventRequestVC : UIViewController

- (IBAction)btnBackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblRequest;

@end
