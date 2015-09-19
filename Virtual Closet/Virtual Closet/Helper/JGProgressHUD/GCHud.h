//
//  GCHud.h
//  Virtual Closet
//
//  Created by Apple on 25/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GCHud;
@interface GCHud : NSObject
+(GCHud *)Hud;
- (void)showSuccessHUD;
- (void)showErrorHUD;
- (void)showNormalHUD:(NSString *)title;
-(void)Dismiss;
@end
