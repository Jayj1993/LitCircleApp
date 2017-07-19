//
//  UserProfileVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "UserProfileVC.h"
#import "FeedTVC.h"
#import "CommentsVC.h"
#import "LoginVC.h"
#import "AppDelegate.h"

@interface UserProfileVC ()<FeedTVCProtocol>{
    
    NSArray *allCircles;
    NSMutableArray *allAttendedParties;
    LitPosts *selectedPost;
}

@end

@implementation UserProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgUserImage.layer.cornerRadius = self.imgUserImage.frame.size.height/2;
    self.imgUserImage.clipsToBounds = YES;
    allAttendedParties = [[NSMutableArray alloc]init];
    [self getUserProfile];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)getUserProfile{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/%i",kServerURLLogin,[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [allAttendedParties removeAllObjects];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            LitUser *user = [[LitUser alloc]initWithDictionary:[json objectForKey:@"result"]];
            [self setUserData:user];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utilities showAlertView:@"" message:kErrorMessage];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities showAlertView:@"" message:kErrorMessage];
    }];
}

-(void)setUserData:(LitUser*)user{
    self.lblUserName.text = [NSString stringWithFormat:@"%@ %@",user.first_name,user.last_name];
    self.lblTotalEvents.text = [NSString stringWithFormat:@"%li",(unsigned long)user.events.count];
    self.lblTotalCircles.text = [NSString stringWithFormat:@"%li",(unsigned long)user.circles.count];
    [self.imgUserImage sd_setImageWithURL:[NSURL URLWithString:[SharedManager sharedManager].user.Profile_image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    allCircles = user.circles;
    allAttendedParties = [user.events mutableCopy];
    [self.tblPost reloadData];
}

- (IBAction)optionSelected:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex==0)
        [self.tblPost reloadData];
    else
        [self.tblPost reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.sgmentCntrl.selectedSegmentIndex==0)
        return allAttendedParties.count;
    else return allCircles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sgmentCntrl.selectedSegmentIndex==1) {
        static NSString *cellIdentifier = @"CircleCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *circleName = [allCircles objectAtIndex:indexPath.row];
        if (![[circleName objectForKey:@"circle_name"] isKindOfClass:[NSNull class]])
         cell.textLabel.text = [circleName objectForKey:@"circle_name"];
        else cell.textLabel.text = @"";
        return cell;
    } else {
        static NSString *cellIdentifier = @"FeedCell";
        FeedTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [cell setData:[allAttendedParties objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sgmentCntrl.selectedSegmentIndex==1)
        return 44.0f;
    else return 275.0f;
}

#pragma mark - FeedTVC Delegate -

-(void)buttonCommentBulletinPressd:(NSUInteger)tag{
    selectedPost = [allAttendedParties objectAtIndex:tag];
    [self performSegueWithIdentifier:@"toComments" sender:self];
}

-(void)buttonLikePressed:(NSUInteger)tag{
    LitPosts *post = [allAttendedParties objectAtIndex:tag];
    if (post.isLikedByUser==YES) {
        post.isLikedByUser = NO;
        post.totalLikes = post.totalLikes-1;
        [allAttendedParties replaceObjectAtIndex:tag withObject:post];
        FeedTVC *tvc = [_tblPost cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
        if (post.totalLikes==1)
            tvc.lblTotalLikes.text = [NSString stringWithFormat:@"%i Like",post.totalLikes];
        else
            tvc.lblTotalLikes.text = [NSString stringWithFormat:@"%i Likes",post.totalLikes];
        [self unLikeUser:post];
    } else {
        post.isLikedByUser = YES;
        post.totalLikes = post.totalLikes+1;
        [allAttendedParties replaceObjectAtIndex:tag withObject:post];
        FeedTVC *tvc = [_tblPost cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
        if (post.totalLikes==1)
            tvc.lblTotalLikes.text = [NSString stringWithFormat:@"%i Like",post.totalLikes];
        else
            tvc.lblTotalLikes.text = [NSString stringWithFormat:@"%i Likes",post.totalLikes];
        [self likeUser:post];
    }
}

-(void)buttonSharePressd:(NSUInteger)tag{
    LitPosts *post = [allAttendedParties objectAtIndex:tag];
    NSArray *activityItems = [NSArray arrayWithObjects:post.video_name,[NSString stringWithFormat:@"%@%@",kServerVideoURL,post.video_name], nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)likeUser:(LitPosts*)post{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@%i/%i",kServerLikeVideoURL,post.video_id,[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
}

-(void)unLikeUser:(LitPosts*)post{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@%i/%i",kServerUnLikeVideoURL,post.video_id,[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
}

-(void)playVideo:(NSUInteger)tag{
    LitPosts *post = [allAttendedParties objectAtIndex:tag];
    NSURL *movieURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServerVideoURL,post.video_name]];
    self.movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    self.movieController.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    self.movieController.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    self.movieController.moviePlayer.fullscreen = YES;
    [self.movieController.moviePlayer prepareToPlay];
    [self presentMoviePlayerViewControllerAnimated:self.movieController];
    [self.movieController.moviePlayer play];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toComments"]) {
        CommentsVC *vc = [segue destinationViewController];
        vc.selectedPost = selectedPost;
    }
}

- (IBAction)btnLogoutPressed:(id)sender {
    [self showConfirmation];
}

-(void)showConfirmation{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:^{}];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self logOutUser];
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)moveToHome{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kUserID];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginVC *loginVC = (LoginVC*)[storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    AppDelegate *appDelegateTemp = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegateTemp.window setRootViewController:loginVC];
}

-(void)logOutUser{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] forKey:@"user_id"];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kFriebaseToken] != nil)
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kFriebaseToken] forKey:@"device_token"];
    else
        [dict setObject:@"" forKey:@"device_token"];
    [manager POST:kServerLogout parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self moveToHome];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [Utilities showAlertView:@"" message:@"Something went wrong please try agian later"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
