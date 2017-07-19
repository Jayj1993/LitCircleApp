//
//  FeedTVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedTVCProtocol <NSObject>

-(void)buttonCommentBulletinPressd:(NSUInteger)tag;
-(void)buttonLikePressed:(NSUInteger)tag;
-(void)buttonSharePressd:(NSUInteger)tag;
-(void)buttonReportPressed:(NSUInteger)tag;
-(void)playVideo:(NSUInteger)tag;
-(void)btnAttendedPressed:(NSUInteger)tag;

@end

@interface FeedTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideoImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalLikes;
@property (weak, nonatomic) IBOutlet UIView *viewCOmment;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentText;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;

@property (weak, nonatomic) IBOutlet UIImageView *imgPlayIcon;
@property (weak,nonatomic)id<FeedTVCProtocol> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnAttend;

- (IBAction)btnLikePressed:(id)sender;
- (IBAction)btnCommentPressed:(id)sender;
- (IBAction)btnSharePressed:(id)sender;
- (IBAction)btnReportPressed:(id)sender;
- (IBAction)btnAttendPressed:(id)sender;

-(void)setData:(LitPosts*)post;



@end
