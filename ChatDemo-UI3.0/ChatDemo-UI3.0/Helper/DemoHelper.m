//
//  DemoHelper.m
//  ChatDemo-UI3.0
//
//  Created by dhcdht on 14-11-12.
//  Copyright (c) 2014年 easemob.com. All rights reserved.
//

#import "DemoHelper.h"

#import "DemoDefine.h"

static DemoHelper *helper = nil;

@implementation DemoHelper

@synthesize version = _version;

@synthesize applyArray = _applyArray;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _registerRemoteNotification];//apns注册
        
        [self _resetHelper];//初始化相关信息
    }
    
    return self;
}

+ (instancetype)defaultHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DemoHelper alloc] init];
    });
    
    return helper;
}

+ (void)clearHelper
{
    if (helper) {
        [helper _resetHelper];
    }
}

#pragma makr - private

- (void)_resetHelper
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(_applyArray)
    {
        [_applyArray removeAllObjects];
    }
    else{
        _applyArray = [NSMutableArray array];
    }
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)_registerRemoteNotification
{
#if !TARGET_IPHONE_SIMULATOR
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
#endif
    
}

#pragma mark - IChatManagerDelegate push相关

- (void)didRegisterDeviceWithToken:(NSData *)deviceToken
                             error:(EMError *)error
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败" message:error.description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"消息推送与设备绑定失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    if (!message) {
        message = [NSString stringWithFormat:@"%@ 添加你为好友", username];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{kApplyFrom:username, kApplyMessage:message, kApplyType:[NSNumber numberWithInteger:ApplyTypeBuddy]}];
    [_applyArray addObject:dic];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_APPLYCHANGE object:nil];
}

- (void)didRejectedByBuddy:(NSString *)username
{
    NSString *message = [NSString stringWithFormat:@"你被'%@'无耻的拒绝了", username];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"好友提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
                                error:(EMError *)error
{
    if (!groupId || !username) {
        return;
    }
    
    NSString *groupName = groupId;
    if (!message || message.length == 0) {
        message = [NSString stringWithFormat:@"%@ 邀请你加入群组\'%@\'", username, groupName];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{kApplyGroupName:groupName, kApplyGroupId:groupId, kApplyFrom:username, kApplyMessage:message, kApplyType:[NSNumber numberWithInteger:ApplyTypeGroupInvitation]}];
    
    [_applyArray addObject:dic];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_APPLYCHANGE object:nil];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!groupId || !username) {
        return;
    }
    
    if (error) {
        NSString *message = [NSString stringWithFormat:@"发送申请失败:%@\n原因：%@", reason, error.description];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        if (!reason || reason.length == 0) {
            reason = [NSString stringWithFormat:@"%@ 申请加入群组\'%@\'", username, groupname];
        }
        else{
            reason = [NSString stringWithFormat:@"%@ 申请加入群组\'%@\'：%@", username, groupname, reason];
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{kApplyGroupName:groupname, kApplyGroupId:groupId, kApplyFrom:username, kApplyMessage:reason, kApplyType:[NSNumber numberWithInteger:ApplyTypeJoinGroup]}];
        
        [_applyArray addObject:dic];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_APPLYCHANGE object:nil];
    }
}

//加群申请被拒绝
- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
                                   groupname:(NSString *)groupname
                                      reason:(NSString *)reason
{
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:@"被拒绝加入群组\'%@\'", groupname];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"群组提示" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

//已同意加入了群组
- (void)didAcceptInvitationFromGroup:(EMGroup *)group
                               error:(EMError *)error
{
    if (group) {
        NSString *message = [NSString stringWithFormat:@"你已进入群组\'%@\'", group.groupSubject];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"群组提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

//不再是群组成员了
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    NSString *tmpStr = group.groupSubject;
    NSString *str;
    if (!tmpStr || tmpStr.length == 0) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *obj in groupArray) {
            if ([obj.groupId isEqualToString:group.groupId]) {
                tmpStr = obj.groupSubject;
                break;
            }
        }
    }
    
    if (reason == eGroupLeaveReason_BeRemoved)
    {
        str = [NSString stringWithFormat:@"你被从群组\'%@\'中踢出", tmpStr];
    }
    if (str.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"群组提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
