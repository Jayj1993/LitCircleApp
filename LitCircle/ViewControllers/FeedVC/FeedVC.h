//
//  FeedVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface FeedVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblPosts;
@property (nonatomic,strong) MPMoviePlayerViewController *movieController;
- (IBAction)btnBackPressed:(id)sender;
- (IBAction)btnAddPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *myCircleCollView;

@end
