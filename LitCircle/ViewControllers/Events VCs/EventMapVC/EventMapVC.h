//
//  EventMapVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/21/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventMapVC : UIViewController
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic,strong) NSArray *eventsArray;
- (IBAction)btnBackPressed:(id)sender;
- (IBAction)publicOnOff:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblPrivate;
@property (weak, nonatomic) IBOutlet UISwitch *privateSwitch;

@end
