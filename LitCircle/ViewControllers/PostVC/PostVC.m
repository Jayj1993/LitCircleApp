//
//  PostVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 1/3/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "PostVC.h"
#import "SelectCircleVC.h"

@interface PostVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,selectCirclVCDelegate,GMSAutocompleteViewControllerDelegate,selectCirclVCDelegate>{
    
    NSString *circlesSelected;
    BOOL isVideoSelected;
    NSURL *videoFileUrl;
    
    UIImage *thumbnailImage;
    float selectedLat;
    float selectedLng;
}

@end

@implementation PostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    circlesSelected = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setHidden:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSelectVideoPressed:(id)sender {
    
    [self showActionSheet];
}

-(void)showActionSheet{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Capture Video", @"Choose From Library", nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate -

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        [self openCamera];
    }
    if (buttonIndex==1) {
        
        [self openLibrary];
    }
    
    
}



-(void)openLibrary{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.navigationController.delegate =self;
    imagePicker.allowsEditing = YES;
    imagePicker.videoMaximumDuration = 30.0;
    imagePicker.navigationBar.tintColor = [UIColor whiteColor];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,nil];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)openCamera{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.navigationController.delegate =self;
    imagePicker.navigationBar.tintColor = [UIColor whiteColor];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.videoMaximumDuration = 30.0;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,nil];
    
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
}

#pragma mark - UIImagePicker -

#pragma mark- image picker delegates

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    isVideoSelected = YES;
        NSURL *pickeUrl = info[UIImagePickerControllerMediaURL];
       videoFileUrl = pickeUrl;
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:pickeUrl options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
    
        thumbnailImage = thumb;
    
       [self.btnSelect setBackgroundImage:thumb forState:UIControlStateNormal];
    
       [picker dismissViewControllerAnimated:YES completion:nil];
    
}





-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - UITextField Delegate -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
        if (textField.tag==1) {
            
            [self performSegueWithIdentifier:@"toSelectCircles" sender:self];
            return NO;
        }
    if (textField.tag==2) {
        
        GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
        acController.delegate = self;
        [self presentViewController:acController animated:YES completion:nil];
        return NO;
    }

    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"toSelectCircles"]) {
        
        SelectCircleVC *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}

#pragma mark - Selected Circles -

-(void)circleSelected:(NSString*)selectedCircles withCount:(NSUInteger)count{
    
    NSLog(@"what's here %@",selectedCircles);
    if (count>0) {
        circlesSelected = selectedCircles;
        NSLog(@"test line");
        if (count==1) {
            _txtCircleToShareWith.text = [NSString stringWithFormat:@"Shared with %li circle",count];
        }
        else{
        
            _txtCircleToShareWith.text = [NSString stringWithFormat:@"Shared with %li circles",count];
            
        }
        
    }
    else{
    
        circlesSelected  = @"";
        NSLog(@"test line");
        
    }
    
    
}

- (IBAction)btnPostPressed:(id)sender {
    
    if ([circlesSelected isEqualToString:@""]) {
        
        [Utilities showAlertView:@"" message:@"Please select circles to share video with"];
        return;
    }
    if (isVideoSelected==NO) {
        
        [Utilities showAlertView:@"" message:@"Please select video to share"];
        return;
        
    }
    if ([self.txtLocation.text isEqualToString:@""]) {
        
        [Utilities showAlertView:@"" message:@"Please share where you are?"];
        return;
    }
    
    [self postSendVideo];
    
}

-(void)postSendVideo{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    NSString *imgBase64 = [self imageToNSString:thumbnailImage];
    
    [dict setObject:_txtAbout.text forKey:@"video_description"];
    [dict setObject:imgBase64 forKey:@"video_thumb"];
    [dict setObject:circlesSelected forKey:@"circle_ids"];
    [dict setObject:_txtLocation.text forKey:@"address"];
    [dict setObject:[NSNumber numberWithFloat:selectedLat] forKey:@"lat"];
    [dict setObject:[NSNumber numberWithFloat:selectedLng] forKey:@"long"];
    [dict setObject:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]intValue]] forKey:@"user_id"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
 
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
   manager.responseSerializer = [AFJSONResponseSerializer serializer];
   // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];;
    
    [manager POST:kServerURLPostVideo parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        NSLog(@"what's here %@",videoFileUrl);
        
        NSString *videoPathComponent = [[videoFileUrl lastPathComponent]stringByReplacingOccurrencesOfString:@"trim." withString:@""];
        
        NSError *error;
        if (![formData appendPartWithFileURL:videoFileUrl name:@"video" fileName:videoPathComponent mimeType:@"video/quicktime" error:&error]) {
            NSLog(@"error appending part %@",error);
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"what's here %f", uploadProgress.fractionCompleted);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error;
        NSLog(@"error %@",error);
        
        
        
        NSDictionary *jsonData = (NSDictionary*)responseObject;
        
        if ([[jsonData objectForKey:@"status"]boolValue]==YES) {
            
            [Utilities showAlertView:@"" message:@"Video Posted Successfully"];
            
            
        }
        else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [Utilities showAlertView:@"" message:@"Unable to post video please try again"];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [Utilities showAlertView:@"" message:kErrorMessage];

    }];
    
    
}

- (NSString *)imageToNSString:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

#pragma mark - AutoComplete Delegate -

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    // Do something with the selected place.
    
    _txtLocation.text = [NSString stringWithFormat:@"%@",place.name];
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place lat %f", place.coordinate.latitude);
    NSLog(@"Place long %f", place.coordinate.longitude);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    
    selectedLat = place.coordinate.latitude;
    selectedLng = place.coordinate.longitude;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    // TODO: handle the error.
    NSLog(@"error: %ld", [error code]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    NSLog(@"Autocomplete was cancelled.");
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
