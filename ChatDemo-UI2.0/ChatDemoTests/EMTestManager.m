//
//  EMTestManager.m
//  ChatDemo-UI2.0
//
//  Created by dhcdht on 14-11-24.
//  Copyright (c) 2014年 dhcdht. All rights reserved.
//

#import "EMTestManager.h"

static EMTestManager *manager = nil;

@implementation EMTestManager

@synthesize easemob = _easemob;

- (instancetype)init
{
    if (self = [super init]) {
        _easemob = [[EaseMob alloc] init];
    }
    
    return self;
}

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EMTestManager alloc] init];
    });
    
    return manager;
}

@end
