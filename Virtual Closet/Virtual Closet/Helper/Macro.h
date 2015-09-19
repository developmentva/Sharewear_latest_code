#define isIOS6 floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1
#define isIOS7 floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1
#define CorrectValue(field) ([field isKindOfClass:[NSNull class]]) ? @"" : field;
#import "Utility.h"
