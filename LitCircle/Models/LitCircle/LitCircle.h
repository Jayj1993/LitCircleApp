//
//  LitCircle.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/15/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LitCircle : NSObject

@property (nonatomic,assign) int circle_id;
@property (nonatomic, strong) NSString *circle_name;
@property (nonatomic, strong) NSString *circle_image;
@property (nonatomic, strong) NSString *role;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
