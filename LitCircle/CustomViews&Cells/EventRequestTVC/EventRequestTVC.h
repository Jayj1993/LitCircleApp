//
//  EventRequestTVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 4/26/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol eventrequestDelegate <NSObject>

-(void)btnAcceptPressed:(NSUInteger)tag;
-(void)btnRejectPressed:(NSUInteger)tag;

@end

@interface EventRequestTVC : UITableViewCell
@property (nonatomic) id<eventrequestDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
- (IBAction)btnRejectPressed:(id)sender;
- (IBAction)btnAcceptPressed:(id)sender;

@end
