//
//  CreateEventVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/21/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "CreateEventVC.h"
#import "SelectCircleVC.h"
#import "SelectEventPhotoVC.h"
@interface CreateEventVC ()<GMSAutocompleteViewControllerDelegate,selectCirclVCDelegate,SelectEventPhotoVCDelegate>{
    
    BOOL isImageSelected;
    NSArray *optionsArray;
    LitEvent *event;
    NSString *selectedImageName;
    
}

@end

@implementation CreateEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    optionsArray = [NSArray arrayWithObjects:@"Public",@"Private", nil];
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.height/2;
    self.imgUser.clipsToBounds = YES;
    
    [self.imgUser sd_setImageWithURL:[NSURL URLWithString:[SharedManager sharedManager].user.Profile_image_url] placeholderImage:[UIImage imageNamed:@""]];
    
    event = [[LitEvent alloc]init];
    
    
    
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
    
    [self.view endEditing:YES];
    
    if ([_txtEventName.text isEqualToString:@""]) {
        
        [Utilities showAlertView:@"" message:@"Please enter event name"];
        return;
    }
    if ([_txtEventLoc.text isEqualToString:@""]) {
        
        [Utilities showAlertView:@"" message:@"Please enter event location"];
        return;
    }
    if ([_txtPublicPrivate.text isEqualToString:@""]) {
        
        [Utilities showAlertView:@"" message:@"Please choose accessibility for event"];
        return;
        
    }
    if ([_txtEventDate.text isEqualToString:@""]) {
        
        [Utilities showAlertView:@"" message:@"Please select date for event"];
        return;
    }
    if ([_txtPublicPrivate.text isEqualToString:@"Private"]) {
        
        if ([_txtShareWithCircles.text isEqualToString:@""]) {
            
            [Utilities showAlertView:@"" message:@"Please select circles you want to share event with"];
            return;
            
        }
    }
    
    [self createEvent];
}
- (IBAction)btnEventImagePressed:(id)sender {
    
    [self.view endEditing:YES];
    [self showActionControl];
}

-(void)showActionControl{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Choose"
                                  message:@""
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* addText = [UIAlertAction
                              actionWithTitle:@"Camera"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                  
                                  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                      
                                      UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                                      imagePicker.delegate = self;
                                      imagePicker.navigationController.delegate =self;
                                      imagePicker.navigationBar.tintColor = [UIColor blackColor];
                                      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                      imagePicker.allowsEditing = NO;
                                      
                                      [self presentViewController:imagePicker animated:YES completion:nil];
                                      
                                  }
                                  
                                  
                                  
                                  
                              }];
    
    UIAlertAction* drawText = [UIAlertAction
                               actionWithTitle:@"Choose from Library"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                                   UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                                   imagePicker.delegate = self;
                                   imagePicker.navigationController.delegate =self;
                                   imagePicker.navigationBar.tintColor = [UIColor blackColor];
                                   imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                   
                                   [self presentViewController:imagePicker animated:YES completion:nil];
                                   
                                   
                               }];
    
    
    UIAlertAction* stockPhoto = [UIAlertAction
                               actionWithTitle:@"Choose from Available Photos"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                                  
                                   [self performSegueWithIdentifier:@"toSelectPhoto" sender:self];
                                   
                                   
                                   
                               }];
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                             }];
    
    [alert addAction:addText];
    [alert addAction:drawText];
    [alert addAction:stockPhoto];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}




#pragma mark- image picker delegates

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    selectedImageName = nil;
    isImageSelected = YES;
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.btnEventImage setBackgroundImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - UITextField Delegate -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    
    if(textField.tag==2){
        
        UIPickerView *picker = [[UIPickerView alloc]init];
        CGRect rect = picker.frame;
        rect.size.width = [UIScreen mainScreen].bounds.size.width;
        picker.frame = rect;
        picker.delegate = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = YES;
        picker.tag = textField.tag;
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, picker.frame.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlack;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressed:)];
        
        [doneButton setTintColor:[UIColor whiteColor]];
        
        doneButton.tag = picker.tag;
        
        
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self
                                                                                  action:nil];
        
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnPressed:)];
        
        
        [cancelButton setTintColor:[UIColor whiteColor]];
        
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton,flexible,doneButton, nil]];
        
        
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 219, [UIScreen mainScreen].bounds.size.width, 266)];
        
        [view addSubview:picker];
        [view addSubview:toolBar];
        
        
        textField.inputView = view;
        
        
        
    }
    
    else if(textField.tag==4){
        
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        CGRect rect = datePicker.frame;
        rect.size.width = [UIScreen mainScreen].bounds.size.width;
        datePicker.frame = rect;
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.tag = textField.tag;
        
        
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, datePicker.frame.size.width, 44)];
        toolBar.barStyle = UIBarStyleBlack;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressed:)];
        
        doneButton.tag = datePicker.tag;
        
        [doneButton setTintColor:[UIColor whiteColor]];
        
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self
                                                                                  action:nil];
        
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnPressed:)];
        
        
        [cancelButton setTintColor:[UIColor whiteColor]];
        
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton,flexible,doneButton, nil]];
        
        
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 219, [UIScreen mainScreen].bounds.size.width, 266)];
        
        [view addSubview:datePicker];
        [view addSubview:toolBar];
        
        
        textField.inputView = view;
        
        
        
    }
    else if(textField.tag==1||textField.tag==3){
        
        if (textField.tag==1) {
            
            GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
            acController.delegate = self;
            [self presentViewController:acController animated:YES completion:nil];
            return NO;
        }
        
        
        if (textField.tag==3) {
            
            [self performSegueWithIdentifier:@"toSelectCircles" sender:self];
            return NO;
        }
       
    }
    
    return YES;
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (pickerView.tag == 2) {
        return optionsArray.count;
    }
    
    
    return 0;
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent:(NSInteger)component{
    
    
    if (pickerView.tag == 2) {
        
        return [optionsArray objectAtIndex:row];;
    }
    
    
    return nil;
    
}



#pragma mark - Methods
-(void)doneBtnPressed:(UIBarButtonItem*)sender{
    
    [self.view endEditing:YES];
    
    UITextField *field = (UITextField*)[self.view viewWithTag:sender.tag];
    
    
    
    
    if (field.tag==4) {
        
        UIDatePicker *picker = [field.inputView.subviews objectAtIndex:0];
        
        field.text = [self formateDate:picker.date];
        
        
    }
    else if (field.tag==2){
        
        UIPickerView *picker = [field.inputView.subviews objectAtIndex:0];
        
        field.text = [optionsArray objectAtIndex:[picker selectedRowInComponent:0]];
        
    }
    
    
}

-(void)cancelBtnPressed:(id)sender{
    
    [self.view endEditing:YES];
}
-(NSString*)formateDate:(NSDate*)date{
    
   // milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"MMM dd, yyyy"];
    
    return [df stringFromDate:date];
}

#pragma mark - AutoComplete Delegate -

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    // Do something with the selected place.
    
    _txtEventLoc.text = [NSString stringWithFormat:@"%@",place.name];
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place lat %f", place.coordinate.latitude);
    NSLog(@"Place long %f", place.coordinate.longitude);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    event.event_lat_long = [NSString stringWithFormat:@"%f,%f",place.coordinate.latitude,place.coordinate.longitude];
    event.event_lat = place.coordinate.latitude;
    event.event_long = place.coordinate.longitude;
    event.event_location = place.name;
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"toSelectCircles"]) {
        
        SelectCircleVC *vc = [segue destinationViewController];
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"toSelectPhoto"]) {
        
        SelectEventPhotoVC *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}
#pragma mark - Selected Circles -

-(void)circleSelected:(NSString*)selectedCircles withCount:(NSUInteger)count{
    
    NSLog(@"what's here %@",selectedCircles);
    if (count>0) {
        
        _txtShareWithCircles.text = [NSString stringWithFormat:@"Shared with %li Circles",count];
        event.circle_ids = @"";
    }
    else{
        
        event.circle_ids = selectedCircles;
    }
    NSLog(@"test line");
    
}

#pragma mark - Method -
-(void)createEvent{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    
    [dict setObject:_txtEventName.text forKey:@"event_name"];
    [dict setObject:_txtDescription.text forKey:@"event_description"];
    [dict setObject:_txtPublicPrivate.text forKey:@"event_scope"];
    [dict setObject:_txtEventLoc.text forKey:@"event_location"];
    [dict setObject:[NSNumber numberWithFloat:event.event_lat] forKey:@"event_lat"];
    [dict setObject:[NSNumber numberWithFloat:event.event_long] forKey:@"event_long"];
    [dict setObject:_txtEventDate.text forKey:@"event_date"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] forKey:@"user_id"];
    if (event.circle_ids==nil) {
        
        event.circle_ids = @"";
    }
    [dict setObject:event.circle_ids forKey:@"circle_ids"];
    if (selectedImageName==nil) {
        
        selectedImageName = @"";
        
        NSString *imgBase64;
        if (isImageSelected==YES) {
            
            imgBase64 = [self imageToNSString:[Utilities resizeImage:[self.btnEventImage backgroundImageForState:UIControlStateNormal] toWidth:300.0f height:300.0f]];
            
            
        }
        else{
            
            imgBase64 = @" ";
        }
        
        [dict setObject:imgBase64 forKey:@"event_images"];
        [dict setObject:@"" forKey:@"image_name"];
        
    }
    else{
        
        [dict setObject:selectedImageName forKey:@"image_name"];
        
    }
    
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60000.0;
    
    [manager POST:kServerURLCreateEvent parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        
        
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            
            [Utilities showAlertView:@"" message:@"Event Created Successfully"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [Utilities showAlertView:@"" message:@"Unable to create event please try again"];
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

#pragma mark - Select Photo Delegate -

-(void)imageSelected:(NSString*)imageName{
    
    isImageSelected = YES;
    selectedImageName = imageName;
    [self.btnEventImage setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
}

@end
