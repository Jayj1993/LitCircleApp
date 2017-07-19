//
//  NSArray+Group.h
//  SuiteDash
//
//  Created by Afzal Sheikh on 10/17/16.
//  Copyright © 2016 iosdebugger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Group)

-(NSMutableDictionary *)groupUsingBlock:(id<NSCopying> (^)(id obj))block;
-(NSDictionary *)groupByKeyPath:(NSString *) keyPath;


@end
