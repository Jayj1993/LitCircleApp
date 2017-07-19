//
//  NotificationsVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 1/25/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "NotificationsVC.h"

@interface NotificationsVC (){
    
    UIActivityIndicatorView *spinner;
    BOOL isFetching;
    int offset;
    NSMutableArray *allNotifications;
    UIRefreshControl *refreshControl;
    NSString *baseUrl;

}

@end

@implementation NotificationsVC
@synthesize tblNotifications;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    allNotifications = [[NSMutableArray alloc]init];
    
    offset = 1;
    
    baseUrl = [NSString stringWithFormat:@"%@%i",kServerURLGETNotifications,[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]];
    
    [self setUpControls];
    
    [self getAllNotification];
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITableView DataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return allNotifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"NotiCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [allNotifications objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1.0f;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleNone;
}


-(void)getAllNotification{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/%i",baseUrl,offset] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"what's here %@",json);
        
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                
                for (int i=0; i<Users.count; i++) {
                    
                    NSDictionary *dict = [Users objectAtIndex:i];
                    
                    [allNotifications addObject:[dict objectForKey:@"notification_text"]];
                    
                }
                
                
            }
            
            
            if (allNotifications.count>0) {
                offset = (int)allNotifications.count + 1;
                [self.tblNotifications reloadData];
                
            }
            
            
        }
        else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [Utilities showAlertView:@"" message:@"no data to display"];
        }
        
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities showAlertView:@"" message:kErrorMessage];
        
    }];
    
    
    
    
}


-(void)loadMoreNotification{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/%i",baseUrl,offset] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"what's here %@",json);
        
        if (offset==1) {
            
            [refreshControl endRefreshing];
            [allNotifications removeAllObjects];
            
        }
        else{
            
            isFetching = NO;
            [spinner stopAnimating];
            [spinner setHidden:YES];
            self.tblNotifications.tableFooterView = nil;
        }
        
        
        
        
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            
            
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                
                
                
                for (int i=0; i<Users.count; i++) {
                    
                    NSDictionary *dict = [Users objectAtIndex:i];
                    
                    [allNotifications addObject:[dict objectForKey:@"notification_text"]];
                    
                }
                
                if (allNotifications.count>0) {
                    offset = (int)allNotifications.count + 1;
                    [self.tblNotifications reloadData];
                }
                
                
            }
            
            
            
            
        }
        else{
            
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
    
    [self.tblNotifications addSubview:refreshControl];
    [refreshControl addTarget:self
                       action:@selector(getFreshData)
             forControlEvents:UIControlEventValueChanged];
}

-(void)getFreshData{
    
    offset = 1;
    [self loadMoreNotification];
    
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    
    CGPoint newoffset = self.tblNotifications.contentOffset;
    CGRect bounds = self.tblNotifications.bounds;
    CGSize size = self.tblNotifications.contentSize;
    UIEdgeInsets inset = self.tblNotifications.contentInset;
    
    float y = newoffset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        
        if (offset<10) {
            
            return;
        }
        
        if (isFetching==NO) {
            
            NSLog(@"load more data");
            
            spinner.frame=CGRectMake(0, 0, 310, 44);
            [spinner startAnimating];
            [spinner setHidden:NO];
            self.tblNotifications.tableFooterView = spinner;
            isFetching = YES;
            [self loadMoreNotification];
            
            
            
            
        }
        
        
        
    }
}




- (IBAction)optionSelected:(UISegmentedControl *)sender {
    
    [allNotifications removeAllObjects];
    [self.tblNotifications reloadData];
    offset = 1;
    
    if (sender.selectedSegmentIndex==0) {
        
       
        baseUrl = [NSString stringWithFormat:@"%@%i",kServerURLGETNotifications,[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]];
    }
    else{
        
          baseUrl = [NSString stringWithFormat:@"%@%i",kServerURLGETActivities,[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]];
    }
    [self getAllNotification];
    
    
}
@end
