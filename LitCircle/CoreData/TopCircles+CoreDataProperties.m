//
//  TopCircles+CoreDataProperties.m
//  LitCircle
//
//  Created by Afzal Sheikh on 3/2/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "TopCircles+CoreDataProperties.h"

@implementation TopCircles (CoreDataProperties)

+ (NSFetchRequest<TopCircles *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TopCircles"];
}

@dynamic circlename;
@dynamic circleID;
@dynamic userID;

@end
