//
//  NSArray+Group.m
//  SuiteDash
//
//  Created by Afzal Sheikh on 10/17/16.
//  Copyright © 2016 iosdebugger. All rights reserved.
//

#import "NSArray+Group.h"

@implementation NSArray (Group)

-(NSMutableDictionary *)groupUsingBlock:(id<NSCopying> (^)(id obj))block {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (id obj in self) {
        id<NSCopying> key = block(obj);
        if (! dictionary[key]) {
            NSMutableArray *arr = [NSMutableArray array];
            dictionary[key] = arr;
        }
        [dictionary[key] addObject:obj];
    }
    return [dictionary mutableCopy];
}


-(NSDictionary *)groupByKeyPath:(NSString *) keyPath {
    return [self groupUsingBlock:^id<NSCopying>(id obj) {
        return [obj valueForKeyPath:keyPath];
    }];
}


@end
