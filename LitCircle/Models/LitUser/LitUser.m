//
//  LitUser.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/13/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "LitUser.h"

@implementation LitUser
    
    @synthesize first_name = _first_name;
    @synthesize last_name = _last_name;
    @synthesize email = _email;
    @synthesize phone = _phone;
    @synthesize social_media_id = _social_media_id;
    @synthesize social_media_flag = _social_media_flag;
    @synthesize profile_image = _profile_image;
    @synthesize Profile_image_url = _Profile_image_url;

- (id)initWithDictionary:(NSDictionary *)dict {
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
    if ([dict objectForKey:@"attendedVideos"])
        self.events = [[NSArray alloc] initWithArray:[self getAttendedVideos:[dict valueForKey:@"attendedVideos"]]];
    return self;
}

- (NSMutableArray*)getAttendedVideos:(NSArray*)users {
    NSMutableArray *allUsers = [[NSMutableArray alloc] init];
    for (int i = 0; i < users.count; i++) {
        LitPosts *objComp = [[LitPosts alloc] initWithDictionary:[users objectAtIndex:i]];
        [allUsers addObject:objComp];
    }
    return [allUsers mutableCopy];
}
    
@end
