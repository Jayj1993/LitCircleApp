//
//  UserProfileVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface UserProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgUserImage;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalEvents;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCircles;
- (IBAction)optionSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgmentCntrl;
@property (weak, nonatomic) IBOutlet UITableView *tblPost;
@property (nonatomic,strong) MPMoviePlayerViewController *movieController;
- (IBAction)btnLogoutPressed:(id)sender;

@end
