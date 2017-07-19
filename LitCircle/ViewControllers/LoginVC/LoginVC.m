//
//  ViewController.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/10/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()
{    
    LitUser *user;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [[LitUser alloc]init];
}
-(void)viewDidAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kUserID]!=nil) {
        [self performSegueWithIdentifier:@"toHome" sender:self];
    }
}

- (IBAction)btnFbLoginPressed:(id)sender {
    [self loginWithFacebook];
}

- (IBAction)btnTwitterLoginPressed:(id)sender {
    [self loginWithTwitter];
}

-(void)loginWithFacebook {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [Utilities showAlertView:@"" message:error.debugDescription];
         } else if (result.isCancelled) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [Utilities showAlertView:@"" message:@"Login Cancelled"];
         } else
             [self getUserProfile];
     }];
}

-(void)getUserProfile {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,first_name,last_name,picture.width(100).height(100)" forKey:@"fields"];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             user.email = result[@"email"];
             user.social_media_flag = @"F";
             user.social_media_id = result[@"id"];
             user.first_name = result[@"first_name"];
             user.last_name = result[@"last_name"];
             user.Profile_image_url = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
             user.profile_image = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
             [self performSelector:@selector(loginToServer) withObject:self afterDelay:2.0];
         } else {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [Utilities showAlertView:@"" message:error.debugDescription];
         }
     }];

}
-(void)loginWithTwitter {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Twitter sharedInstance] logInWithMethods:TWTRLoginMethodWebBased completion:^(TWTRSession *session, NSError *error) {
        if (session) {
            TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:session.userID];
            NSURLRequest *request = [client URLRequestWithMethod:@"GET"
                                                             URL:@"https://api.twitter.com/1.1/account/verify_credentials.json"
                                                      parameters:@{@"include_email": @"true", @"skip_status": @"true"}
                                                           error:nil];
            [client sendTwitterRequest:request
                            completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (connectionError) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [Utilities showAlertView:@"" message:@"something went wrong please check your internet connection and try again"];
                } else {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    if ([json objectForKey:@"name"]) {
                        if ([json objectForKey:@"name"]!=nil && ![[json objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
                            NSString *name = [json objectForKey:@"name"];
                            NSArray *arr = [name componentsSeparatedByString:@" "];
                            if (arr.count==2) {
                                user.first_name = [arr firstObject];
                                user.last_name = [arr objectAtIndex:1];
                            } else {
                                user.first_name = name;
                                user.last_name = @"";
                            }
                        } else {
                            user.first_name = @"";
                            user.last_name = @"";
                        }
                    } else {
                        user.first_name = @"";
                        user.last_name = @"";
                    }
                    user.social_media_flag = @"T";
                    user.social_media_id = [json objectForKey:@"id_str"];
                    if ([json objectForKey:@"email"]) {
                        if ([json objectForKey:@"email"]!=nil && ![[json objectForKey:@"email"] isKindOfClass:[NSNull class]])
                            user.email = [json objectForKey:@"email"];
                        else
                            user.email = @"";
                    } else
                        user.email = @"";
                    if ([json objectForKey:@"profile_image_url"]) {
                        if ([json objectForKey:@"profile_image_url"]!=nil && ![[json objectForKey:@"profile_image_url"] isKindOfClass:[NSNull class]])
                            user.profile_image = [json objectForKey:@"profile_image_url"];
                        else
                            user.profile_image = @"";
                    } else
                        user.profile_image = @"";
                    if ([json objectForKey:@"profile_image_url"]) {
                        if ([json objectForKey:@"profile_image_url"]!=nil && ![[json objectForKey:@"profile_image_url"] isKindOfClass:[NSNull class]])
                             user.Profile_image_url = [json objectForKey:@"profile_image_url"];
                        else
                            user.Profile_image_url = @"";
                    } else
                        user.Profile_image_url = @"";
                    [self loginToServer];
                }
            }];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utilities showAlertView:@"" message:@"something went wrong please check your internet connection and try again"];
        }
    }];
}

-(void)loginToServer {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:user.first_name forKey:@"first_name"];
    [dict setObject:user.last_name forKey:@"last_name"];
    [dict setObject:user.social_media_id forKey:@"social_media_id"];
    [dict setObject:user.email forKey:@"email"];
    [dict setObject:user.social_media_flag forKey:@"social_media_flag"];
    [dict setObject:@"" forKey:@"phone"];
    [dict setObject:user.Profile_image_url forKey:@"profile_image"];
    if ([[FIRInstanceID instanceID] token]!=nil) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:kFriebaseToken])
            [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kFriebaseToken] forKey:@"device_token"];
        else
            [dict setObject:@"" forKey:@"device_token"];
    } else
        [dict setObject:@"" forKey:@"device_token"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:kServerURLLogin parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            NSString *profilePicture = user.Profile_image_url;
            LitUser *loggedInUser = [[LitUser alloc]initWithDictionary:[json objectForKey:@"result"]];
            loggedInUser.Profile_image_url = profilePicture;
            [SharedManager sharedManager].user = loggedInUser;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[SharedManager sharedManager].user.user_id] forKey:kUserID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:@"toHome" sender:self];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utilities showAlertView:@"" message:@"Server is down, please try again later"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities showAlertView:@"" message:error.debugDescription];
    }];
}
  
@end
