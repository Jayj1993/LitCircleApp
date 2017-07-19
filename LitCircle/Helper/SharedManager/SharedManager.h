//
//  SharedManager.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/13/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedManager : NSObject

+ (SharedManager*)sharedManager;
    
@property (nonatomic, strong) LitUser *user;
    
@end
