//
//  EventRequestVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 4/26/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "EventRequestVC.h"
#import "EventRequestTVC.h"
@interface EventRequestVC ()<eventrequestDelegate>
{
    UIActivityIndicatorView *spinner;
    BOOL isFetching;
    int offset;
    NSMutableArray *allRequests;
    UIRefreshControl *refreshControl;
}

@end

@implementation EventRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    allRequests = [[NSMutableArray alloc]init];
    offset = 1;
    [self setUpControls];
    [self getAllRequests];
}

- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView DataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allRequests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LitEvent *event = [allRequests objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"RequestCell";
    EventRequestTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.lblName.text = [NSString stringWithFormat:@"%@ %@",event.first_name,event.last_name];
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
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

-(void)getAllRequests {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@%i/%i",kServerURLGETEventRequest,[SharedManager sharedManager].user.user_id,offset] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                for (int i=0; i<Users.count; i++) {
                    LitEvent *user = [[LitEvent alloc]initWithDictionary:[Users objectAtIndex:i]];
                    [allRequests addObject:user];
                }
            }
            if (allRequests.count>0) {
                offset = (int)allRequests.count + 1;
                [self.tblRequest reloadData];
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

-(void)loadMoreEvents {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@%i/%i",kServerURLGETEventRequest,[SharedManager sharedManager].user.user_id,offset]parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        if (offset==1) {
            [refreshControl endRefreshing];
            [allRequests removeAllObjects];
        } else {
            isFetching = NO;
            [spinner stopAnimating];
            [spinner setHidden:YES];
            self.tblRequest.tableFooterView = nil;
        }
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                for (int i=0; i<Users.count; i++) {
                    LitEvent *user = [[LitEvent alloc]initWithDictionary:[Users objectAtIndex:i]];
                    [allRequests addObject:user];
                }
                if (allRequests.count>0) {
                    offset = (int)allRequests.count + 1;
                    [self.tblRequest reloadData];
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
-(void)setUpControls {
    spinner   = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tblRequest addSubview:refreshControl];
    [refreshControl addTarget:self
                       action:@selector(getFreshData)
             forControlEvents:UIControlEventValueChanged];
}

-(void)getFreshData {
    offset = 1;
    [self loadMoreEvents];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate {
    CGPoint newoffset = self.tblRequest.contentOffset;
    CGRect bounds = self.tblRequest.bounds;
    CGSize size = self.tblRequest.contentSize;
    UIEdgeInsets inset = self.tblRequest.contentInset;
    
    float y = newoffset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 50;
    if (y > h + reload_distance) {
        if (offset<10)
            return;
        if (isFetching==NO) {
            spinner.frame=CGRectMake(0, 0, 310, 44);
            [spinner startAnimating];
            [spinner setHidden:NO];
            self.tblRequest.tableFooterView = spinner;
            isFetching = YES;
            [self loadMoreEvents];
        }
    }
}

#pragma mark - EventRequest Delegate -

-(void)btnAcceptPressed:(NSUInteger)tag {
    LitEvent *post = [allRequests objectAtIndex:tag];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInt:post.event_id] forKey:@"event_id"];
    [dict setObject:[NSNumber numberWithInt:post.user_id] forKey:@"user_id"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager PUT:[NSString stringWithFormat:@"%@",kServerURLAcceptRequest] parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
    [allRequests removeObject:post];
    [self.tblRequest reloadData];
}

-(void)btnRejectPressed:(NSUInteger)tag {
    LitEvent *post = [allRequests objectAtIndex:tag];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInt:post.event_id] forKey:@"event_id"];
    [dict setObject:[NSNumber numberWithInt:post.user_id] forKey:@"user_id"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager PUT:[NSString stringWithFormat:@"%@",kServerURLRejectRequest] parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
    [allRequests removeObject:post];
    [self.tblRequest reloadData];
}

@end
