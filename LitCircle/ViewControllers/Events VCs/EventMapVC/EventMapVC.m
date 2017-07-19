//
//  EventMapVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/21/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "EventMapVC.h"

@interface EventMapVC ()<CLLocationManagerDelegate,GMSMapViewDelegate>{
    
    CLLocationManager *locationManager;
    BOOL firstLocationUpdate;
}

@end

@implementation EventMapVC
@synthesize eventsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    
    CLLocationCoordinate2D current = CLLocationCoordinate2DMake(31.4805, 74.2808);
    
    if ([[eventsArray firstObject] isKindOfClass:[LitPosts class]]) {
        
        [self.privateSwitch setHidden:YES];
        [self.lblPrivate setHidden:YES];
        [self setEventsMarket];
    }
    else{
        
        [self.privateSwitch setHidden:NO];
        [self.lblPrivate setHidden:NO];
        [self setPublicMarkers];
        
    }
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:current.latitude longitude: current.longitude zoom:15];
    _mapView.mapType = kGMSTypeNormal;
    _mapView.camera = camera;
    
    
    
    self.mapView.myLocationEnabled = YES;
    
    
//    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = current;
//    marker.icon = [UIImage imageNamed:@"locationiocn"];
//    marker.map = _mapView;
    
   
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

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    BOOL saved = NO;
    saved = [moc save:&error]; CLLocation *currentLocation = newLocation;
    
   [self.mapView animateToLocation:newLocation.coordinate];
    
    
    
    [locationManager stopUpdatingLocation];
    
  
    
    
    
}

-(void)setPublicMarkers{
    
    [self.mapView clear];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.event_scope CONTAINS[cd] %@",
                              @"public"];
    
    NSArray *filteredArray = [eventsArray filteredArrayUsingPredicate:predicate];
    
    for (int i=0; i<filteredArray.count; i++) {
        
        LitEvent *event = [filteredArray objectAtIndex:i];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(event.event_lat, event.event_long);
        marker.icon = [UIImage imageNamed:@"marker"];
        marker.map = _mapView;
        
    }
    
}

- (IBAction)btnBackPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)publicOnOff:(UISwitch*)sender {

    if ([sender isOn]) {
        
        if ([[eventsArray firstObject]isKindOfClass:[LitPosts class]]) {
            
            [self setEventsMarket];
        }
        else{
            
            [self setPublicPrivateMarkers];
        }
    }
    else{
        
        if ([[eventsArray firstObject]isKindOfClass:[LitPosts class]]) {
            
            [self setEventsMarket];
        }
        else{
            
            [self setPublicMarkers];
        }
        
       
    }
}
-(void)setEventsMarket{
    
        [self.mapView clear];
        
        for (int i=0; i<eventsArray.count; i++) {
            
            LitPosts *event = [eventsArray objectAtIndex:i];
            
            
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(event.lat, event.lng);
            marker.icon = [UIImage imageNamed:@"marker"];
            marker.map = _mapView;
            
        }
    
}
-(void)setPublicPrivateMarkers{
    
    [self.mapView clear];
    
    for (int i=0; i<eventsArray.count; i++) {
        
        LitEvent *event = [eventsArray objectAtIndex:i];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(event.event_lat, event.event_long);
        marker.icon = [UIImage imageNamed:@"marker"];
        marker.map = _mapView;
        
    }
}
@end
