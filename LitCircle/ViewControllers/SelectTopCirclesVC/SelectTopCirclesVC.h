//
//  SelectTopCirclesVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 3/2/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectTopCirclesVCDelegate <NSObject>

-(void)circleSelected:(NSArray*)selectedCircles;

@end


@interface SelectTopCirclesVC : UIViewController

- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnDonePressed:(id)sender;

@property (nonatomic) id<selectTopCirclesVCDelegate> delegate;
@property (nonatomic,strong) NSArray *selectedCirclesArray;
@property (weak, nonatomic) IBOutlet UITableView *tblCircles;

@end
