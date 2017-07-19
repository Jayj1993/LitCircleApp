//
//  LitEvent.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/21/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LitEvent : NSObject

@property (nonatomic,assign) int event_id;
@property (nonatomic,assign) int user_id;
@property (nonatomic, strong) NSString *event_name;
@property (nonatomic, strong) NSString *event_scope;
@property (nonatomic, strong) NSString *event_location;
@property (nonatomic, strong) NSString *event_lat_long;
@property (nonatomic, strong) NSString *event_date;
@property (nonatomic, strong) NSString *event_img_name;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *profile_image;
@property (nonatomic, strong) NSString *circle_ids;
@property (nonatomic, strong) NSString *image_name;
@property (nonatomic, assign) BOOL canRequest;
@property (nonatomic, assign) float event_lat;
@property (nonatomic, assign) float event_long;
@property (nonatomic, assign) NSString *event_description;
@property (nonatomic,assign) float distance;
@property (nonatomic,strong) NSArray* images;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
