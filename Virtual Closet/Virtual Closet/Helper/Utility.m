//
//  Utility.m
//  Virtual Closet
//
//  Created by Apple on 25/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(void)SaveUserName:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)SaveUserid:(NSString *)ID
{
    [[NSUserDefaults standardUserDefaults] setObject:ID forKey:@"Userid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)RemoveUserid:(NSString *)ID
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Userid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void)SaveUserImage:(NSString *)ID
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",ID] forKey:@"image"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)SaveOtherUserName:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"OtherUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)SaveOtherUserid:(NSString *)ID
{
    [[NSUserDefaults standardUserDefaults] setObject:ID forKey:@"OtherUserid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)SaveOtherUserImage:(NSString *)ID
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",ID] forKey:@"Otherimage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)SaveDeviceToken:(NSString *)ID
{
    [[NSUserDefaults standardUserDefaults] setObject:ID forKey:@"Device"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)Devicetoken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Device"];
}
+(NSString *)UserImage
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
}

+(NSString *)UserID
{
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"Userid"];
}

+(NSString *)UserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
}

+(NSString *)OtherUserImage
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Otherimage"];
}

+(NSString *)OtherUserID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"OtherUserid"];
}

+(NSString *)OtherUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"OtherUserName"];
}


+(void)SaveClosetid:(NSString *)ID
{
    [[NSUserDefaults standardUserDefaults] setObject:ID forKey:@"ClosetID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)GetClosetID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ClosetID"];
}

+(void)SaveClosetname:(NSString *)ID
{
    [[NSUserDefaults standardUserDefaults] setObject:ID forKey:@"Closetname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)GetClosetname
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Closetname"];
}


+(NSString *)TimeAgo:(NSDate *)earlier
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    
    // pass as many or as little units as you like here, separated by pipes
    NSUInteger units = NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:units fromDate:earlier toDate:today options:0];
    
    NSInteger years = [components year];
    NSInteger months = [components month];
   // NSInteger days = [components day];
   // NSInteger week = [components week];
    NSInteger weekDays = [components weekday];
    NSInteger Seconds = [components second];
    NSInteger minutes = [components minute];
    NSInteger hours = [components hour];
    NSString *TimeDiff;
    if (Seconds<=59&&minutes==0&&hours==0) {
        TimeDiff=[NSString stringWithFormat:@"%li sec(s) ago",(long)[Utility RemoveNegative:Seconds]];
    }
    else if (minutes<=59&&hours==0) {
        TimeDiff=[NSString stringWithFormat:@"%li min(s) ago",(long)[Utility RemoveNegative:minutes]];
    }
    else if (hours<=24) {
        TimeDiff=[NSString stringWithFormat:@"%li hour(s) ago",(long)[Utility RemoveNegative:hours]];
    }
    else if (weekDays<=7&&months==0) {
        TimeDiff=[NSString stringWithFormat:@"%li day(s) ago",(long)[Utility RemoveNegative:weekDays]];
    }
    else if (months<=12&&years==0) {
        TimeDiff=[NSString stringWithFormat:@"%li month(s) ago",(long)[Utility RemoveNegative:months]];
    }
    else if (years<=12) {
        TimeDiff=[NSString stringWithFormat:@"%li year(s) ago",(long)[Utility RemoveNegative:years]];
    }
    
    return TimeDiff;

}

+(NSInteger)RemoveNegative:(NSInteger)value
{
    if (value<=0) {
        value=0;
    }
    return value;
}

NSString *AvoidNull(NSString *value)
{
    if ([value isKindOfClass:[NSNull class]]||value==NULL||[value length]==0) {
        value=@"";
    }
    return value;
}

@end
