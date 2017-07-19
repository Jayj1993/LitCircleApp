//
//  EventDetailVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 1/3/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailVC : UIViewController
@property (nonatomic, strong) LitEvent *event;
- (IBAction)btnBackPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserImage;
@property (weak, nonatomic) IBOutlet UILabel *lblEventTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEventAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblEventDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
- (IBAction)btnJoinPressed:(id)sender;

@end
