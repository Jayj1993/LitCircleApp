//
//  CreateEventVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/21/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEventVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnDonePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UITextField *txtEventName;
@property (weak, nonatomic) IBOutlet UITextField *txtEventLoc;
@property (weak, nonatomic) IBOutlet UITextField *txtPublicPrivate;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtShareWithCircles;
@property (weak, nonatomic) IBOutlet UIButton *btnEventImage;
- (IBAction)btnEventImagePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtEventDate;

@end
