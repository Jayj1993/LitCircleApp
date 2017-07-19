//
//  DiscoverCollCell.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/15/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "DiscoverCollCell.h"

@implementation DiscoverCollCell

- (IBAction)btnJoinPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(joinClicked:)])
        [self.delegate joinClicked:self.tag];
}

@end
