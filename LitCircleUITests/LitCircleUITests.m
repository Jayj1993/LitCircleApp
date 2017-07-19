//
//  LitCircleUITests.m
//  LitCircleUITests
//
//  Created by Afzal Sheikh on 12/10/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LitCircleUITests : XCTestCase

@property (nonatomic,strong) XCUIApplication *app;

@end

@implementation LitCircleUITests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLoginOptions {
    XCUIElementQuery *buttons = self.app.buttons;
    for (NSString *btnName in @[@"FBLogin", @"TwitterLogin"]) {
        XCTAssert([[buttons elementMatchingType:XCUIElementTypeButton
                                    identifier:btnName]
                   exists]);
    }
}

@end
