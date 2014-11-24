//
//  EMTestManager.h
//  ChatDemo-UI2.0
//
//  Created by dhcdht on 14-11-24.
//  Copyright (c) 2014年 dhcdht. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EaseMob.h"

@interface EMTestManager : NSObject

@property (strong, nonatomic, readonly) EaseMob *easemob;

+ (instancetype)shareManager;

@end
