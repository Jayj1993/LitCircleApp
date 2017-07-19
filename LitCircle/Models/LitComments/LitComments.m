//
//  LitComments.m
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "LitComments.h"

@implementation LitComments

-(id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    for (NSUInteger i = 0; i < numberOfProperties; i++) {
        objc_property_t property = propertyArray[i];
        NSString *key = [[NSString alloc] initWithUTF8String:property_getName(property)];
        id child = [dict valueForKey:key];
        if (child && ![child isKindOfClass:[NSNull class]])
                [self setValue:child forKey:key];
    }
    return self;
}

@end
