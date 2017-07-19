//
//  SelectEventPhotoVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 3/2/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "SelectEventPhotoVC.h"
#import "TopCircleCollCell.h"
@interface SelectEventPhotoVC (){
    
    NSArray *allPhotos;
}

@end

@implementation SelectEventPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    allPhotos = [NSArray arrayWithObjects:@"stock1.png",@"stock2.png",@"stock3.png",@"stock4.png",@"stock5.png",@"stock6.png",@"stock7.png",@"stock8.png",@"stock9.png",@"stock10.png",@"stock11.png", nil];
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

#pragma mark - UICollectionView -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return allPhotos.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"PCollCell";
    TopCircleCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.imgPlaceHolderImage.image = [UIImage imageNamed:[allPhotos objectAtIndex:indexPath.item]];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(imageSelected:)]) {
        
        [self.delegate imageSelected:[allPhotos objectAtIndex:indexPath.item]];
        
        
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width/2;
    float cellWidth = screenWidth / 3.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    
    return size;
}



- (IBAction)btnCancelPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
