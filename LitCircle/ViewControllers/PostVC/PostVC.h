//
//  PostVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 1/3/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostVC : UIViewController
- (IBAction)btnSelectVideoPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UITextField *txtAbout;
@property (weak, nonatomic) IBOutlet UITextField *txtCircleToShareWith;
- (IBAction)btnPostPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;

@end
