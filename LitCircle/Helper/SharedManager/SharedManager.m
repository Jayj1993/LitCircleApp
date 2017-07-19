//
//  SharedManager.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/13/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "SharedManager.h"

@implementation SharedManager
@synthesize user;
static SharedManager *sharedInstance = nil;
    
- (id) init
    {
        self = [super init];
        if (self) {
            
            user = [[LitUser alloc]init];
            
            
        }
        return self;
    }
+ (SharedManager*)sharedManager
    {
        static SharedManager *sharedMyManager = nil;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedMyManager = [[self alloc] init];
        });
        return sharedMyManager;
        
        
    }

@end
