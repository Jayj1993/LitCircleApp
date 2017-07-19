//
//  SelectCircleVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/22/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "SelectCircleVC.h"

@interface SelectCircleVC (){
    
    
    NSMutableArray *cellSelected;
    NSMutableArray *allCircles;
}

@end

@implementation SelectCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cellSelected  = [[NSMutableArray alloc]init];
    allCircles = [[NSMutableArray alloc]init];
    
    [self getAllCircles];
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

- (IBAction)btnCancelPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDonePressed:(id)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(circleSelected:withCount:)]) {
        NSUInteger count = 0;
        NSMutableArray *selectedID = [[NSMutableArray alloc]init];
        NSString *selectedCircles;
        for (int i=0; i<cellSelected.count; i++) {
            
            NSIndexPath *path = [cellSelected objectAtIndex:i];
            
            LitCircle *selectedUser = [allCircles objectAtIndex:path.row];
            
            [selectedID addObject:[NSNumber numberWithInt:selectedUser.circle_id]];
            
            
        }
        
        if (selectedID.count>0) {
            
            selectedCircles = [[selectedID valueForKey:@"description"] componentsJoinedByString:@","];
            count = selectedID.count;
            
            
        }
        else{
            
            selectedCircles = @"";
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [self.delegate circleSelected:selectedCircles withCount:count];
    }
}
-(void)getAllCircles{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/%i",kServerURLLogin,[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"what's here %@",json);
        
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            
            NSArray *Users = [[json objectForKey:@"result"] objectForKey:@"circles"];
            if (Users.count>0) {
                
                for (int i=0; i<Users.count; i++) {
                    
                    LitCircle *user = [[LitCircle alloc]initWithDictionary:[Users objectAtIndex:i]];
                    
                    [allCircles addObject:user];
                    
                }
                
                
            }
            
            if (allCircles.count>0) {
                
                [self.tblCircles reloadData];
            }
            else{
                
                [Utilities showAlertView:@"" message:@"You have no circle. Please create or join circle to grow your circle"];
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

#pragma mark - UITableView DataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return allCircles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    LitCircle *circle = [allCircles objectAtIndex:indexPath.row];
    
        
    cell.textLabel.text = [NSString stringWithFormat:@"%@",circle.circle_name];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([cellSelected containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([cellSelected containsObject:indexPath])
    {
        [cellSelected removeObject:indexPath];
    }
    else
    {
        [cellSelected addObject:indexPath];
    }
    
    [_tblCircles reloadData];
    
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1.0f;
    
}
@end
