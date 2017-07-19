//
//  DiscoverCollCell.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/15/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscoverCellDelegate <NSObject>

-(void)joinClicked:(NSUInteger)tag;

@end

@interface DiscoverCollCell : UICollectionViewCell
@property (nonatomic) id<DiscoverCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnJoin;

- (IBAction)btnJoinPressed:(id)sender;

@end
