//
//  EventRequestTVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 4/26/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "EventRequestTVC.h"

@implementation EventRequestTVC

- (IBAction)btnRejectPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnRejectPressed:)])
        [self.delegate btnRejectPressed:self.tag];
}

- (IBAction)btnAcceptPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnAcceptPressed:)])
        [self.delegate btnAcceptPressed:self.tag];
}

@end
