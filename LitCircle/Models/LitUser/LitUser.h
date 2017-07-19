//
//  LitUser.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/13/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LitUser : NSObject

@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *social_media_id;
@property (nonatomic, strong) NSString *social_media_flag;
@property (nonatomic, strong) NSString *profile_image;
@property (nonatomic, strong) NSString *Profile_image_url;
@property (nonatomic,assign) int user_id;
@property (nonatomic,strong) NSArray *circles;
@property (nonatomic,strong) NSArray *events;

-(id)initWithDictionary:(NSDictionary *)dict;

    
@end
