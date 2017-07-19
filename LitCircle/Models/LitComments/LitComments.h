//
//  LitComments.h
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LitComments : NSObject

@property (nonatomic,assign) int user_id;
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *profile_image;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
