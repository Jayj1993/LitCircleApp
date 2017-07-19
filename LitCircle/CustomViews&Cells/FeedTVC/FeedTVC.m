//
//  FeedTVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "FeedTVC.h"

@implementation FeedTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgUserImage.layer.cornerRadius = self.imgUserImage.frame.size.height/2;
    self.imgUserImage.clipsToBounds = YES;
    
    self.btnAttend.layer.cornerRadius = 5.0f;
    self.btnAttend.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOpenSenderImage:)];
    
    [self.imgVideoImage addGestureRecognizer:tap];
    [self.imgVideoImage setUserInteractionEnabled:YES];
    [self.imgPlayIcon setUserInteractionEnabled:YES];
}

-(void)setData:(LitPosts*)post{
    self.lblName.text = [NSString stringWithFormat:@"%@ %@",post.first_name,post.last_name];
    self.lblTime.text = [Utilities relativeDateStringForDate:post.created];
    if (post.profile_image!=nil)
         [self.imgUserImage sd_setImageWithURL:[NSURL URLWithString:post.profile_image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    else self.imgUserImage.image = [UIImage imageNamed:@"placeholder"];
    
    if (post.totalLikes==1)
        self.lblTotalLikes.text = [NSString stringWithFormat:@"%i like",post.totalLikes];
    else if (post.totalLikes>0)
        self.lblTotalLikes.text = [NSString stringWithFormat:@"%i likes",post.totalLikes];
    else self.lblTotalLikes.text = @"0 likes";
    
    [self.imgVideoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServerURL,[post.video_thumb stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] placeholderImage:[UIImage imageNamed:@"videoPlaceholderIcon"]];
    
    if (post.commentsArray.count>0) {
        [self.viewCOmment setHidden:NO];
        LitComments *comment = [post.commentsArray firstObject];
        self.lblComment.text = [NSString stringWithFormat:@"%@ %@", comment.first_name,comment.last_name];
        self.lblCommentText.text = comment.comments;
    } else [self.viewCOmment setHidden:YES];
    
    if (post.attended==YES)
        [self.btnAttend setHidden:YES];
    else
        [self.btnAttend setHidden:NO];
}

- (IBAction)btnLikePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buttonLikePressed:)])
        [self.delegate buttonLikePressed:self.tag];
}

- (IBAction)btnCommentPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buttonCommentBulletinPressd:)])
        [self.delegate buttonCommentBulletinPressd:self.tag];
}

- (IBAction)btnSharePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buttonSharePressd:)])
        [self.delegate buttonSharePressd:self.tag];
}

- (IBAction)btnReportPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buttonReportPressed:)])
        [self.delegate buttonReportPressed:self.tag];
}

- (IBAction)btnAttendPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnAttendedPressed:)])
        [self.delegate btnAttendedPressed:self.tag];
}

- (void)tapOpenSenderImage:(UITapGestureRecognizer*)sender {
    if ([self.delegate respondsToSelector:@selector(playVideo:)])
        [self.delegate playVideo:self.tag];
}

@end
