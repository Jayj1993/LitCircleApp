//
//  EventListTVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/21/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgEventImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserImage;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblEventName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

-(void)setData:(LitEvent*)event;

@end
