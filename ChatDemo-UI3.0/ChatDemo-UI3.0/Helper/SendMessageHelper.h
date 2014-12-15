//
//  SendMessageHelper.h
//  ChatDemo-UI3.0
//
//  Created by dhcdht on 14-11-11.
//  Copyright (c) 2014年 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EaseMob.h"
#import "EMMessage.h"

@interface SendMessageHelper : NSObject

/**
 *  发送文字消息（包括系统表情）
 *
 *  @param text               发送的文字
 *  @param toChatter          接收方
 *  @param isGroup            是否是群聊
 *  @param isEncrypt          是否加密
 *  @param ext                扩展
 *
 *  @return 封装的消息体
 */
+ (EMMessage *)sendText:(NSString *)text
              toChatter:(NSString *)toChatter
                isGroup:(BOOL)isGroup
              isEncrypt:(BOOL)isEncrypt
                    ext:(NSDictionary *)ext;

/**
 *  发送图片消息
 *
 *  @param image             发送的图片
 *  @param toChatter         接收方
 *  @param isGroup           是否是群聊
 *  @param isEncrypt         是否加密
 *  @param ext               扩展
 *
 *  @return 封装的消息体
 */
+(EMMessage *)sendImage:(UIImage *)image
              toChatter:(NSString *)toChatter
                isGroup:(BOOL)isGroup
              isEncrypt:(BOOL)isEncrypt
                    ext:(NSDictionary *)ext;

/**
 *  发送音频消息
 *
 *  @param voice             发送的音频
 *  @param toChatter         接收方
 *  @param isGroup           是否是群聊
 *  @param isEncrypt         是否加密
 *  @param ext               扩展
 *
 *  @return 封装的消息体
 */
+(EMMessage *)sendVoice:(EMChatVoice *)voice
              toChatter:(NSString *)toChatter
                isGroup:(BOOL)isGroup
              isEncrypt:(BOOL)isEncrypt
                    ext:(NSDictionary *)ext;

/**
 *  发送位置消息（定位）
 *
 *  @param latitude          经度
 *  @param longitude         纬度
 *  @param address           位置描述信息
 *  @param toChatter         接收方
 *  @param isGroup           是否是群聊
 *  @param isEncrypt         是否加密
 *  @param ext               扩展
 *
 *  @return 封装的消息体
 */
+(EMMessage *)sendLocationLatitude:(double)latitude
                         longitude:(double)longitude
                           address:(NSString *)address
                         toChatter:(NSString *)toChatter
                           isGroup:(BOOL)isGroup
                         isEncrypt:(BOOL)isEncrypt
                               ext:(NSDictionary *)ext;

/**
 *  发送视频文件消息
 *
 *  @param video             发送的视频
 *  @param toChatter         接收方
 *  @param isGroup           是否是群聊
 *  @param isEncrypt         是否加密
 *  @param ext               扩展
 *
 *  @return 封装的消息体
 */
+(EMMessage *)sendVideo:(EMChatVideo *)video
              toChatter:(NSString *)toChatter
                isGroup:(BOOL)isGroup
              isEncrypt:(BOOL)isEncrypt
                    ext:(NSDictionary *)ext;

@end
