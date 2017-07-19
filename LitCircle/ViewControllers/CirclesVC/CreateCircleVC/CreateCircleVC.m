//
//  CreateCircleVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/14/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "CreateCircleVC.h"

@interface CreateCircleVC ()
{
    UIActivityIndicatorView *spinner;
    BOOL isFetching;
    int offset;
    NSMutableArray *cellSelected;
    NSMutableArray *allUsers;
}

@end

@implementation CreateCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    cellSelected  = [[NSMutableArray alloc]init];
    allUsers = [[NSMutableArray alloc]init];
    offset = 1;
    [self getAllUsers];
}

-(void)getAllUsers {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/%i",kServerGetAllUsers,offset] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                for (int i=0; i<Users.count; i++) {
                    LitUser *user = [[LitUser alloc]initWithDictionary:[Users objectAtIndex:i]];
                    [allUsers addObject:user];
                }
                NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.user_id != %@",[[NSUserDefaults standardUserDefaults]objectForKey:kUserID]];
                allUsers = [[allUsers filteredArrayUsingPredicate:bPredicate]mutableCopy];
            }
            if (allUsers.count>0) {
                offset = (int)allUsers.count + 1;
                [self.tblUsers reloadData];
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


- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView DataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    LitUser *user = [allUsers objectAtIndex:indexPath.row];
    if (user.last_name!=nil)
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",user.first_name,user.last_name];
    else
        cell.textLabel.text = [NSString stringWithFormat:@"%@",user.first_name];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cellSelected containsObject:indexPath])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([cellSelected containsObject:indexPath])
        [cellSelected removeObject:indexPath];
    else
        [cellSelected addObject:indexPath];
    [_tblUsers reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate {
    CGPoint newoffset = self.tblUsers.contentOffset;
    CGRect bounds = self.tblUsers.bounds;
    CGSize size = self.tblUsers.contentSize;
    UIEdgeInsets inset = self.tblUsers.contentInset;
    float y = newoffset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 50;
    if(y > h + reload_distance) {
        if (offset<10)
            return;
        if (isFetching==NO) {
            spinner.frame=CGRectMake(0, 0, 310, 44);
            [spinner startAnimating];
            [spinner setHidden:NO];
            self.tblUsers.tableFooterView = spinner;
            isFetching = YES;
            [self loadMoreData];
        }
    }
}

-(void)loadMoreData{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/%i",kServerGetAllUsers,offset] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                for (int i=0; i<Users.count; i++) {
                    LitUser *user = [[LitUser alloc]initWithDictionary:[Users objectAtIndex:i]];
                    if (user.user_id!=[SharedManager sharedManager].user.user_id)
                        [allUsers addObject:user];
                }
                NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.user_id != %@",[[NSUserDefaults standardUserDefaults]objectForKey:kUserID]];
                allUsers = [[allUsers filteredArrayUsingPredicate:bPredicate]mutableCopy];
            }
            isFetching = NO;
            [spinner stopAnimating];
            [spinner setHidden:YES];
            self.tblUsers.tableFooterView = nil;
            offset = (int)allUsers.count + 1;
            if (allUsers.count>0)
                [self.tblUsers reloadData];
        } else [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)btnCreatePressed:(id)sender {
    if ([_txtGroupName.text isEqualToString:@""]) {
        [Utilities showAlertView:@"" message:@"Please enter group name"];
        return;
    }
    NSString *groupName;
    if ([_txtGroupName.text hasPrefix:@"#"])
        groupName = [_txtGroupName.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
    else
        groupName = _txtGroupName.text;
    NSString *groupUsers;
    NSMutableArray *selectedID = [[NSMutableArray alloc]init];
    for (int i=0; i<cellSelected.count; i++) {
        NSIndexPath *path = [cellSelected objectAtIndex:i];
        LitUser *selectedUser = [allUsers objectAtIndex:path.row];
        [selectedID addObject:[NSNumber numberWithInt:selectedUser.user_id]];
    }
    if (selectedID.count>0)
        groupUsers = [[selectedID valueForKey:@"description"] componentsJoinedByString:@","];
    else
        groupUsers = @"";
    [self createCircle:groupUsers withName:groupName];
}

-(void)createCircle:(NSString*)users withName:(NSString*)name {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:users forKey:@"users"];
    [dict setObject:name forKey:@"circle_name"];
    [dict setObject:@"" forKey:@"circle_image"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] forKey:@"admin_id"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:kServerURLCreateCircle parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            [Utilities showAlertView:@"" message:@"Circle Created Successfully"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utilities showAlertView:@"" message:@"Circle with this name already exist"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities showAlertView:@"" message:kErrorMessage];
    }];
}

@end
