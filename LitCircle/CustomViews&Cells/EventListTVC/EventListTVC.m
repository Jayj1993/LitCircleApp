//
//  EventListTVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/21/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "EventListTVC.h"

@implementation EventListTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgUserImage.layer.cornerRadius = self.imgUserImage.frame.size.height/2;
    self.imgUserImage.clipsToBounds = YES;
}

-(void)setData:(LitEvent*)event {
    self.lblEventName.text = [NSString stringWithFormat:@"%@",event.event_name];
    self.lblDistance.text = [NSString stringWithFormat:@"%.2fm",event.distance];
    self.lblDate.text = [NSString stringWithFormat:@"%@",[Utilities formatedDateFromString:event.event_date]];
    self.lblUserName.text = [NSString stringWithFormat:@"%@ %@",event.first_name,event.last_name];
    [_imgUserImage sd_setImageWithURL:[NSURL URLWithString:event.profile_image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    if (event.image_name!=nil && ![event.image_name isEqualToString:@""])
        _imgEventImage.image = [UIImage imageNamed:event.image_name];
    else
        if (![event.event_img_name isKindOfClass:[NSNull class]] || event.event_img_name!=nil )
            [_imgEventImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServerURL,[event.event_img_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        else
            _imgEventImage.image = [UIImage imageNamed:@"placeholder"];
}

@end
