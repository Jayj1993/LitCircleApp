//
//  SelectTopCirclesVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 3/2/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "SelectTopCirclesVC.h"

@interface SelectTopCirclesVC ()
{
    NSMutableArray *topCircles;
    NSMutableArray *allCircles;
}

@end

@implementation SelectTopCirclesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    topCircles  = [[NSMutableArray alloc]init];
    allCircles = [[NSMutableArray alloc]init];
    [self getAllCircles];
}

- (IBAction)btnCancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDonePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(circleSelected:)]) {
        if (topCircles.count > 0)
            [self.delegate circleSelected:topCircles];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)getAllCircles {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/%i",kServerURLLogin,[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            NSArray *Users = [[json objectForKey:@"result"] objectForKey:@"circles"];
            if (Users.count>0) {
                for (int i=0; i<Users.count; i++) {
                    LitCircle *user = [[LitCircle alloc]initWithDictionary:[Users objectAtIndex:i]];
                    [allCircles addObject:user];
                }
            }
            topCircles = [self savedTopCircles];
            if (allCircles.count>0)
                [self.tblCircles reloadData];
            else
                [Utilities showAlertView:@"" message:@"You have no circle. Please create or join circle to grow your circle"];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utilities showAlertView:@"" message:kErrorMessage];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities showAlertView:@"" message:kErrorMessage];
    }];
}

- (NSMutableArray *)savedTopCircles {
    NSMutableArray *savedTopCircles = [[NSMutableArray alloc] init];
    for (TopCircles *topCircle in [self fetchTopCircles]) {
        for (LitCircle *circle in allCircles) {
            if ((int)topCircle.circleID == circle.circle_id)
                [savedTopCircles addObject: circle];
        }
    }
    return savedTopCircles;
}

// Temp copy from FeedVC
-(NSArray *)fetchTopCircles {
    NSString *myuserID = [NSString stringWithFormat:@"%i",[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]];
    NSPredicate *predicateFrmt = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID =='%@'",myuserID]];
    return [TopCircles findAllWithPredicate:predicateFrmt];
}

#pragma mark - UITableView DataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allCircles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    LitCircle *circle = [allCircles objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",circle.circle_name];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([topCircles containsObject:circle])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LitCircle *circle = [allCircles objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([topCircles containsObject:circle])
        [topCircles removeObject:circle];
    else {
        if (topCircles.count>=5) {
            [Utilities showAlertView:@"" message:@"You can only select 5 circles to keep it on top."];
            return;
        }
        [topCircles addObject:circle];
    }
    [_tblCircles reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

@end
