//
//  EventDetailVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 1/3/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "EventDetailVC.h"

@interface EventDetailVC (){
    
    LitEvent *detailEvent;
}

@end

@implementation EventDetailVC
@synthesize event;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imgUserImage.layer.cornerRadius = self.imgUserImage.frame.size.height/2;
    self.imgUserImage.clipsToBounds = YES;
    
    [self getEventDetail];
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

-(void)getEventDetail{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/%i",kServerURLGETEventDetail,event.event_id] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"what's here %@",json);
        
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            
            
            LitEvent *user = [[LitEvent alloc]initWithDictionary:[json objectForKey:@"result"]];
            
            [self setEventData:user];
            
    
                
            
            
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

#pragma mark - Set Event Details -

-(void)setEventData:(LitEvent*)eventDetail{
    
    detailEvent = eventDetail;
    
    self.lblName.text = eventDetail.event_name;
    self.lblAddress.text = eventDetail.event_location;
    self.lblEventTime.text = [NSString stringWithFormat:@"%@",[Utilities formatedDateFromString:eventDetail.event_date]];
    
    self.lblEventAddress.text = eventDetail.event_location;
    self.lblEventDistance.text = [NSString stringWithFormat:@"%.2fm",event.distance];
    
    [_imgUserImage sd_setImageWithURL:[NSURL URLWithString:event.profile_image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    if (eventDetail.image_name!=nil && ![eventDetail.image_name isEqualToString:@""]) {
        
        self.eventImage.image = [UIImage imageNamed:eventDetail.image_name];
        
    }
    else{
        
        if (eventDetail.images.count>0) {
            
            NSDictionary *dict = [eventDetail.images firstObject];
            
            if (![[dict objectForKey:@"event_img_name"] isKindOfClass:[NSNull class]] || [dict objectForKey:@"event_img_name"]!=nil ) {
                
                [_eventImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServerURL,[[dict objectForKey:@"event_img_name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
            else{
                
                _eventImage.image = [UIImage imageNamed:@"placeholder"];
            }
            
        }
        

        
        
    }
    
    if (event.canRequest==YES) {
        [self.lblAddress setHidden:YES];
        [self.btnJoin setHidden:NO];
        
    }
    else{
        [self.lblAddress setHidden:NO];
        [self.btnJoin setHidden:YES];
    }
    
    
}

- (IBAction)btnBackPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnJoinPressed:(id)sender {
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] forKey:@"user_id"];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] forKey:@"user_id"];
    
    [dict setObject:[NSNumber numberWithInt:detailEvent.event_id] forKey:@"event_id"];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:kServerURLJoinRequest parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        
        
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            
            [Utilities showAlertView:@"" message:@"Request sent successfully"];
            
            [self.btnJoin setHidden:YES];
        }
        else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [Utilities showAlertView:@"" message:@"Unable to send request"];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [Utilities showAlertView:@"" message:kErrorMessage];
    }];
    
    
    
    
}
@end
