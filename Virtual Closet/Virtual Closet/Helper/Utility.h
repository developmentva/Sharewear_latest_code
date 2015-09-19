//
//  Utility.h
//  Virtual Closet
//
//  Created by Apple on 25/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
+(void)SaveUserName:(NSString *)name;
+(void)SaveUserid:(NSString *)ID;
+(NSString *)UserID;
+(NSString *)UserName;
+(void)SaveClosetid:(NSString *)ID;
+(NSString *)GetClosetID;
+(void)SaveDeviceToken:(NSString *)ID;
+(NSString *)Devicetoken;
+(void)SaveUserImage:(NSString *)ID;
+(NSString *)UserImage;
+(void)SaveClosetname:(NSString *)ID;
+(NSString *)GetClosetname;
+(NSString *)TimeAgo:(NSDate *)earlier;
+(void)RemoveUserid:(NSString *)ID;
+(void)SaveOtherUserName:(NSString *)name;
+(void)SaveOtherUserid:(NSString *)ID;
+(void)SaveOtherUserImage:(NSString *)ID;
+(NSString *)OtherUserID;
+(NSString *)OtherUserName;
+(NSString *)OtherUserImage;
NSString *AvoidNull(NSString *value);
@end
