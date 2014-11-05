//
//  DemoHelper.h
//  ChatDemo-UI3.0
//
//  Created by dhcdht on 14-11-12.
//  Copyright (c) 2014年 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EaseMob.h"

typedef enum{
  ApplyTypeBuddy,
  ApplyTypeGroupInvitation,
  ApplyTypeJoinGroup,
}ApplyType;

#define kApplyFrom @"from"
#define kApplyMessage @"message"
#define kApplyType @"type"
#define kApplyGroupId @"groupId"
#define kApplyGroupName @"groupName"

@interface DemoHelper : NSObject<IChatManagerDelegate>

@property (nonatomic) float version;

@property (strong, nonatomic) NSMutableArray *applyArray;

+ (instancetype)defaultHelper;

+ (void)clearHelper;

- (void)endReviceMessage;

@end
