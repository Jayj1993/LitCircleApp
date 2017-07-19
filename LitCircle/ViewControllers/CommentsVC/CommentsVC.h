//
//  CommentsVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsVC : UIViewController

@property (nonatomic,strong) LitPosts *selectedPost;
@property (weak, nonatomic) IBOutlet UITableView *tblComment;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

- (IBAction)btnBackPressed:(id)sender;
- (IBAction)btnSendPressed:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;


@end
