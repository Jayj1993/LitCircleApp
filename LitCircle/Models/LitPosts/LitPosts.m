//
//  LitPosts.m
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "LitPosts.h"

@implementation LitPosts

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
    if ([dict objectForKey:@"comments"])
        self.commentsArray = [[NSArray alloc] initWithArray:[self getUserCompanies:[dict valueForKey:@"comments"]]];
    return self;
}

- (NSMutableArray*)getUserCompanies:(NSArray*)comp {
    NSMutableArray *allCompanies = [[NSMutableArray alloc] init];
    for (int i = 0; i < comp.count; i++) {
        LitComments *objComp = [[LitComments alloc] initWithDictionary:[comp objectAtIndex:i]];
        [allCompanies addObject:objComp];
    }
    return [allCompanies mutableCopy];
}

@end
