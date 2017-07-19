//
//  TopCircles+CoreDataProperties.h
//  LitCircle
//
//  Created by Afzal Sheikh on 3/2/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "TopCircles+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TopCircles (CoreDataProperties)

+ (NSFetchRequest<TopCircles *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *circlename;
@property (nonatomic) int64_t circleID;
@property (nonatomic) int64_t userID;

@end

NS_ASSUME_NONNULL_END
