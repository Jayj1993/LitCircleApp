//
//  SearchVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/14/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "SearchVC.h"
#import "DiscoverCollCell.h"

@interface SearchVC ()<DiscoverCellDelegate>
{
    NSMutableArray *searchedArray;
}

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    searchedArray = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchedArray removeAllObjects];
    [self.collView reloadData];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchItems];
    [searchBar resignFirstResponder];
}

-(void)searchItems {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *circleName;
    if ([_searchBar.text hasPrefix:@"#"])
        circleName = [_searchBar.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
    else
        circleName = _searchBar.text;
    circleName  = [circleName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@%@",kServerURLSearchCircle,[circleName lowercaseString]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        if ([[json objectForKey:@"status"]boolValue]==YES && [[json objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
            [searchedArray removeAllObjects];
            LitCircle *circle = [[LitCircle alloc]initWithDictionary:[json objectForKey:@"result"]];
            [searchedArray addObject:circle];
            [self.collView reloadData];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utilities showAlertView:@"" message:@"Circle not exist"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities showAlertView:@"" message:kErrorMessage];
    }];
}

#pragma mark - UICollectionView -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return searchedArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DCell";
    DiscoverCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    LitCircle *circle = [searchedArray objectAtIndex:indexPath.item];
    cell.lblName.text = circle.circle_name;
    cell.btnJoin.tag = indexPath.item;
    cell.tag = indexPath.item;
    cell.delegate = self;
    return cell;
}

-(void)joinClicked:(NSUInteger)tag {
    LitCircle *circle = [searchedArray objectAtIndex:tag];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSString stringWithFormat:@"%i",[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]] forKey:@"users"];
    [dict setObject:[NSNumber numberWithInt:circle.circle_id] forKey:@"circle_id"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager PUT:kServerURLUpdateCircle parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
    [searchedArray removeObject:circle];
    [self.collView reloadData];
}

@end
