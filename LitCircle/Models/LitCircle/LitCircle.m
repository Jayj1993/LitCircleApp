//
//  LitCircle.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/15/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "LitCircle.h"

@implementation LitCircle

@synthesize circle_id = _circle_id;
@synthesize circle_name = _circle_name;
@synthesize circle_image = _circle_image;


-(id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    for (NSUInteger i = 0; i < numberOfProperties; i++) {
        objc_property_t property = propertyArray[i];
        NSString *key = [[NSString alloc] initWithUTF8String:property_getName(property)];
        id child = [dict valueForKey:key];
        if (child && ![child isKindOfClass:[NSNull class]])
            [self setValue:child forKey:key];
        else if (![dict objectForKey:@"id"])
            [self setValue:nil forKey:key];
    }
    return self;
}


@end
