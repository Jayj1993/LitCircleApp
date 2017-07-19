//
//  SelectCircleVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/22/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectCirclVCDelegate <NSObject>

-(void)circleSelected:(NSString*)selectedCircles withCount:(NSUInteger)count;


@end

@interface SelectCircleVC : UIViewController
- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnDonePressed:(id)sender;
@property (nonatomic) id<selectCirclVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tblCircles;

@end
