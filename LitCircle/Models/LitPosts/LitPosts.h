//
//  LitPosts.h
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LitPosts : NSObject

@property (nonatomic,assign) int totalComments;
@property (nonatomic,assign) int totalLikes;
@property (nonatomic,assign) int video_id;
@property (nonatomic,assign) int user_id;
@property (nonatomic,assign) float lat;
@property (nonatomic,assign) float lng;
@property (nonatomic, assign) int isLikedByUser;
@property (nonatomic, assign) int attended;
@property (nonatomic, strong) NSString *video_name;
@property (nonatomic, strong) NSString *video_description;
@property (nonatomic, strong) NSString *video_thumb;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *profile_image;
@property (nonatomic, strong) NSArray *commentsArray;
@property (nonatomic, strong) NSString *created;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
