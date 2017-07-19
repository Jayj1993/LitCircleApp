//
//  CommentsTVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 1/10/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUserImage;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;

-(void)setCommentData:(LitComments*)comment;

@end
