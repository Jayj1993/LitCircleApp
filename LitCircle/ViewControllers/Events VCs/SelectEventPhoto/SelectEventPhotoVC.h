//
//  SelectEventPhotoVC.h
//  LitCircle
//
//  Created by Afzal Sheikh on 3/2/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectEventPhotoVCDelegate <NSObject>

-(void)imageSelected:(NSString*)imageName;


@end

@interface SelectEventPhotoVC : UIViewController

@property (nonatomic) id<SelectEventPhotoVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollView;
- (IBAction)btnCancelPressed:(id)sender;

@end
