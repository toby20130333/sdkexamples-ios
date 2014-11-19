//
//  FetchBuddyTest.m
//  ChatDemo-UI2.0
//
//  Created by dhcdht on 14-11-19.
//  Copyright (c) 2014年 dhcdht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "EaseMob.h"

@interface FetchBuddyTest : XCTestCase<IChatManagerDelegate>

@end

@implementation FetchBuddyTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)testExample {
    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
    
    EMError *error = nil;
    [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:&error];
    
    if (!error) {
        XCTAssert(YES, @"fetchBuddyListWithError: Pass");
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
