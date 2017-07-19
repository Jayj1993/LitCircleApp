//
//  HomeVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/21/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "HomeVC.h"
#import "EventListTVC.h"
#import "EventDetailVC.h"
#import "EventMapVC.h"

@interface HomeVC ()<CLLocationManagerDelegate>{
    
    UIActivityIndicatorView *spinner;
    BOOL isFetching;
    int offset;
    NSMutableArray *allEvents;
    CLLocationManager *locationManager;
    UIRefreshControl *refreshControl;
    CLLocation *currentLoc;
    BOOL isCalled;
    LitEvent *selectedEvent;
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    allEvents = [[NSMutableArray alloc]init];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightPressed:)];
    //There is a direction property on UISwipeGestureRecognizer. You can set that to both right and left swipes
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tblHome addGestureRecognizer:recognizer];
    
//    UISwipeGestureRecognizer *recognizer1;
//    recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpPressed:)];
//    //There is a direction property on UISwipeGestureRecognizer. You can set that to both right and left swipes
//    recognizer1.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.tblHome addGestureRecognizer:recognizer1];

    
    offset = 1;
    [self setUpControls];
    
    [self getLocation];
    
    
    
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
    
    return allEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ECell";
    
    EventListTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    [cell setData:[allEvents objectAtIndex:indexPath.row]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  //  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedEvent = [allEvents objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"toEventDetail" sender:self];
    
    
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


-(void)getAllEvents:(CLLocation*)currentLocation{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/%i/%f/%f/%i",kServerURLGETEvent,[SharedManager sharedManager].user.user_id,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,offset] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"what's here %@",json);
        
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                
                for (int i=0; i<Users.count; i++) {
                    
                    LitEvent *user = [[LitEvent alloc]initWithDictionary:[Users objectAtIndex:i]];
                    [allEvents addObject:user];
                    
                }
                
                
            }
            
            if (allEvents.count>0) {
                offset = (int)allEvents.count + 1;
                [self.tblHome reloadData];
                isCalled =NO;
            }
            
            
        }
        else{
            
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
    
    [manager GET:[NSString stringWithFormat:@"%@/%i/%f/%f/%i",kServerURLGETEvent,[SharedManager sharedManager].user.user_id,currentLoc.coordinate.latitude,currentLoc.coordinate.longitude,offset] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"what's here %@",json);
        
        if (offset==1) {
            
            [refreshControl endRefreshing];
            [allEvents removeAllObjects];
            
        }
        else{
            
            isFetching = NO;
            [spinner stopAnimating];
            [spinner setHidden:YES];
            self.tblHome.tableFooterView = nil;
        }
        

        
        
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            
            
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                
                
                
                for (int i=0; i<Users.count; i++) {
                    
                    LitEvent *user = [[LitEvent alloc]initWithDictionary:[Users objectAtIndex:i]];
                    [allEvents addObject:user];
                    
                }
                
                if (allEvents.count>0) {
                    offset = (int)allEvents.count + 1;
                    [self.tblHome reloadData];
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

-(void)getLocation{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    

}

#pragma mark - Methods -
-(void)setUpControls{
    
    spinner   = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    
    [self.tblHome addSubview:refreshControl];
    [refreshControl addTarget:self
                       action:@selector(getFreshData)
             forControlEvents:UIControlEventValueChanged];
}

-(void)getFreshData{
    
    offset = 1;
    if (currentLoc==nil) {
        [refreshControl endRefreshing];
        return;
        
    }
    [self loadMoreEvents];
    
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    
    CGPoint newoffset = self.tblHome.contentOffset;
    CGRect bounds = self.tblHome.bounds;
    CGSize size = self.tblHome.contentSize;
    UIEdgeInsets inset = self.tblHome.contentInset;
    
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
            self.tblHome.tableFooterView = spinner;
            isFetching = YES;
            [self loadMoreEvents];
            
            
            
            
        }
        
        
        
    }
}


#pragma mark - CLLocationManager -

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    currentLoc = newLocation;
    if (isCalled==NO) {
   
         [self getAllEvents:newLocation];
        isCalled = YES;
    }
   
    [locationManager stopUpdatingLocation];
    //Tampa
    //CLLocation *testLocation = [[CLLocation alloc]initWithLatitude:27.964157 longitude:-82.452606];
    // St.Penut
   // CLLocation *testLocation = [[CLLocation alloc]initWithLatitude:27.773056 longitude:-82.639999];
//    27.773056
//    -82.639999
    
  //  CLLocation *testLocation = [[CLLocation alloc]initWithLatitude:28.0142 longitude:-82.1289];
    
//
//
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    [geocoder reverseGeocodeLocation:testLocation
//                   completionHandler:^(NSArray *placemarks, NSError *error) {
//                       NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
//                       
//                       if (error){
//                           NSLog(@"Geocode failed with error: %@", error);
//                           return;
//                           
//                       }
//                       
//                       
//                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                       
//                       NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
//                       NSLog(@"placemark.country %@",placemark.country);
//                       NSLog(@"placemark.postalCode %@",placemark.postalCode);
//                       NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
//                       NSLog(@"placemark.locality %@",placemark.locality);
//                       NSLog(@"placemark.subLocality %@",placemark.subLocality);
//                       NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
//                       
//                   }];
//    
    
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"toEventDetail"]) {
        
        EventDetailVC *vc = [segue destinationViewController];
        vc.event = selectedEvent;
    }
    if ([segue.identifier isEqualToString:@"toMap"]) {
        
        EventMapVC *vc = [segue destinationViewController];
        vc.eventsArray = [allEvents mutableCopy];
    }
    
    
}

- (IBAction)swipeRightPressed:(UISwipeGestureRecognizer*)sender {
    
    
        [self performSegueWithIdentifier:@"toMap" sender:self];
    
    
}

- (IBAction)btnBackPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
