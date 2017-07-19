//
//  CommentsTVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 1/10/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "CommentsTVC.h"

@implementation CommentsTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgUserImage.layer.cornerRadius = self.imgUserImage.frame.size.height/2;
    self.imgUserImage.clipsToBounds = YES;
}

-(void)setCommentData:(LitComments*)comment {
    self.lblName.text = [NSString stringWithFormat:@"%@ %@",comment.first_name,comment.last_name];
    self.lblComment.text = [NSString stringWithFormat:@"%@",comment.comments];
    if (comment.profile_image!=nil)
        [self.imgUserImage sd_setImageWithURL:[NSURL URLWithString:comment.profile_image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    else
        self.imgUserImage.image = [UIImage imageNamed:@"placeholder"];
}

@end
