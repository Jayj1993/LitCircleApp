//
//  FeedVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "FeedVC.h"
#import "FeedTVC.h"
#import "CommentsVC.h"
#import "TopCircleCollCell.h"
#import "SelectTopCirclesVC.h"
#import "HomeVC.h"
#import "EventMapVC.h"
@interface FeedVC ()<FeedTVCProtocol,selectTopCirclesVCDelegate,CAAnimationDelegate>{
    
    UIActivityIndicatorView *spinner;
    BOOL isFetching;
    int offset;
    NSMutableArray *allPosts;
    UIRefreshControl *refreshControl;
    LitPosts *selectedPost;
    NSMutableArray *mySelectedCircles;
    NSUInteger selectedCircleIndex;
    NSString *baseUrl;
}

@end

@implementation FeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    allPosts = [[NSMutableArray alloc]init];
    mySelectedCircles = [[NSMutableArray alloc]init];
    offset = 1;
    selectedCircleIndex = 0;
    [self setUpControls];
    [self fetchTopData];
    baseUrl = [NSString stringWithFormat:@"%@/%i", kServerURLGETPosts, [[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]      intValue]];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightPressed:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tblPosts addGestureRecognizer:recognizer];
    
    UISwipeGestureRecognizer *recognizer1;
    recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftPressed:)];
    recognizer1.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tblPosts addGestureRecognizer:recognizer1];
    [self getAllEvents];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - UITableView DataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FeedCell";
    FeedTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [cell setData:[allPosts objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

-(void)getAllEvents{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/%i",baseUrl,offset] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                for (int i=0; i<Users.count; i++) {
                    LitPosts *user = [[LitPosts alloc]initWithDictionary:[Users objectAtIndex:i]];
                    [allPosts addObject:user];
                }
            }
            if (allPosts.count>0) {
                offset = (int)allPosts.count + 1;
                [self.tblPosts reloadData];
            }
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utilities showAlertView:@"" message:@"No data to display"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities showAlertView:@"" message:kErrorMessage];
    }];
}

-(void)loadMoreEvents{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/%i",baseUrl,offset] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (offset==1) {
            [refreshControl endRefreshing];
            [allPosts removeAllObjects];
        } else {
            isFetching = NO;
            [spinner stopAnimating];
            [spinner setHidden:YES];
            self.tblPosts.tableFooterView = nil;
        }
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                for (int i=0; i<Users.count; i++) {
                    LitPosts *user = [[LitPosts alloc]initWithDictionary:[Users objectAtIndex:i]];
                    [allPosts addObject:user];
                }
                if (allPosts.count>0) {
                    offset = (int)allPosts.count + 1;
                    [self.tblPosts reloadData];
                }
            }
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utilities showAlertView:@"" message:kErrorMessage];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities showAlertView:@"" message:kErrorMessage];
    }];
}

#pragma mark - Methods -
-(void)setUpControls{
    spinner   = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tblPosts addSubview:refreshControl];
    [refreshControl addTarget:self
                       action:@selector(getFreshData)
             forControlEvents:UIControlEventValueChanged];
}

-(void)getFreshData{
    offset = 1;
    [self loadMoreEvents];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    CGPoint newoffset = self.tblPosts.contentOffset;
    CGRect bounds = self.tblPosts.bounds;
    CGSize size = self.tblPosts.contentSize;
    UIEdgeInsets inset = self.tblPosts.contentInset;
    
    float y = newoffset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        if (offset<10) {return;}
        if (isFetching==NO) {
            spinner.frame=CGRectMake(0, 0, 310, 44);
            [spinner startAnimating];
            [spinner setHidden:NO];
            self.tblPosts.tableFooterView = spinner;
            isFetching = YES;
            [self loadMoreEvents];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LitPosts *post = [allPosts objectAtIndex:indexPath.row];
    if (post.commentsArray.count>0){return 387;}
    return 340;
}


- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAddPressed:(id)sender {
    [self performSegueWithIdentifier:@"toCricles" sender:self];
}


#pragma mark - FeedTVC Delegate -

-(void)buttonCommentBulletinPressd:(NSUInteger)tag{
    selectedPost = [allPosts objectAtIndex:tag];
    [self performSegueWithIdentifier:@"toComments" sender:self];
}

-(void)buttonLikePressed:(NSUInteger)tag{
    LitPosts *post = [allPosts objectAtIndex:tag];
    if (post.isLikedByUser==YES) {
        post.isLikedByUser = NO;
        post.totalLikes = post.totalLikes-1;
        [allPosts replaceObjectAtIndex:tag withObject:post];
        
        FeedTVC *tvc = [_tblPosts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
        if (post.totalLikes==1)
            tvc.lblTotalLikes.text = [NSString stringWithFormat:@"%i Like",post.totalLikes];
        else
            tvc.lblTotalLikes.text = [NSString stringWithFormat:@"%i Likes",post.totalLikes];
        [self unLikeUser:post];
    } else {
        post.isLikedByUser = YES;
        post.totalLikes = post.totalLikes+1;
        [allPosts replaceObjectAtIndex:tag withObject:post];
        FeedTVC *tvc = [_tblPosts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
        if (post.totalLikes==1) {
            tvc.lblTotalLikes.text = [NSString stringWithFormat:@"%i Like",post.totalLikes];
        } else {
            tvc.lblTotalLikes.text = [NSString stringWithFormat:@"%i Likes",post.totalLikes];
        }
        [self likeUser:post];
    }
}

-(void)buttonSharePressd:(NSUInteger)tag{
    LitPosts *post = [allPosts objectAtIndex:tag];
    NSArray *activityItems = [NSArray arrayWithObjects:post.video_name,[NSString stringWithFormat:@"%@%@",kServerVideoURL,post.video_name], nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)buttonReportPressed:(NSUInteger)tag{
    [Utilities showAlertView:@"" message:@"Thank you for reporting this content. A LitCircle member has been notified for review"];
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
    LitPosts *post = [allPosts objectAtIndex:tag];
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
    if ([segue.identifier isEqualToString:@"toCricles"]) {
        SelectTopCirclesVC *vc = [segue destinationViewController];
        vc.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"toMap"]) {
        EventMapVC *vc = [segue destinationViewController];
        vc.eventsArray = [allPosts mutableCopy];
    }
}

#pragma mark - UICollectionView -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return mySelectedCircles.count+1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"TCell";
    TopCircleCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.item==0) {
        cell.lblCircleName.text = @"Top";
    } else{
        TopCircles *circle = [mySelectedCircles objectAtIndex:indexPath.item-1];
        cell.lblCircleName.text = circle.circlename;
    }
    cell.imgPlaceHolderImage.layer.cornerRadius = cell.imgPlaceHolderImage.frame.size.height/2;
    cell.imgPlaceHolderImage.clipsToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedCircleIndex!=indexPath.item) {
        if (indexPath.item==0) {
            offset = 1;
            [allPosts removeAllObjects];
            baseUrl = [NSString stringWithFormat:@"%@/%i",kServerURLGETPosts,[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]];
            [self getAllEvents];
        } else{
            TopCircles *circle = [mySelectedCircles objectAtIndex:indexPath.item-1];
            offset = 1;
            [allPosts removeAllObjects];
            baseUrl = [NSString stringWithFormat:@"%@/%lli/%i",kServerURLGETCirclesPosts,circle.circleID,[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]];
            [self getAllEvents];
        }
    }
    selectedCircleIndex = indexPath.item;
}

-(void)circleSelected:(NSArray*)selectedCircles {
    [self deleteBeforeStoring];
    for (int i=0; i<selectedCircles.count; i++) {
        LitCircle *crcle = [selectedCircles objectAtIndex:i];
        TopCircles *circle = [TopCircles createEntity];
        circle.circlename = crcle.circle_name;
        circle.circleID = crcle.circle_id;
        circle.userID = [[[NSUserDefaults standardUserDefaults]objectForKey:kUserID]intValue];
        // Save Managed Object Context
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            if (!error) {
                if (i==selectedCircles.count-1) {
                    [self fetchTopData];
                }
            }
        }];
    }
}

-(void)deleteBeforeStoring {
    NSString *myuserID = [NSString stringWithFormat:@"%i",[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]];
    NSPredicate *predicateFrmt = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID =='%@'",myuserID]];
    [TopCircles deleteAllMatchingPredicate:predicateFrmt];
    NSError *error;
    [[NSManagedObjectContext defaultContext] save:&error];
}

-(void)fetchTopData {
    NSString *myuserID = [NSString stringWithFormat:@"%i",[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]];
    NSPredicate *predicateFrmt = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID =='%@'",myuserID]];
    NSArray *allRooms = [TopCircles findAllWithPredicate:predicateFrmt];
    mySelectedCircles = [allRooms mutableCopy];
    [_myCircleCollView reloadData];
}

- (IBAction)swipeRightPressed:(UISwipeGestureRecognizer*)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeVC *vc = (HomeVC *)[storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.30;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)swipeLeftPressed:(UISwipeGestureRecognizer*)sender {
    [self performSegueWithIdentifier:@"toMap" sender:self];
}

-(void)btnAttendedPressed:(NSUInteger)tag {
    LitPosts *post = [allPosts objectAtIndex:tag];
    post.attended = YES;
    [allPosts replaceObjectAtIndex:tag withObject:post];
    [self.tblPosts reloadData];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/%i/%i",kServerURLAttendVideo,post.video_id,[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
}
@end
