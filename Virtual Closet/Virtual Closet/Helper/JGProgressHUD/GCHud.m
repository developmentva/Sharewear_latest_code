//
//  GCHud.m
//  Virtual Closet
//
//  Created by Apple on 25/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "GCHud.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "JGProgressHUDRingIndicatorView.h"
#import "JGProgressHUDFadeZoomAnimation.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUDIndeterminateIndicatorView.h"
#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 838.00
#endif

#define iOS7 (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
GCHud *Hudder;
JGProgressHUD *HUD;
@implementation GCHud

+(GCHud *)Hud
{
    if (!Hudder) {
        Hudder=[[GCHud alloc] init];
    }
    return Hudder;
}
//- (UIViewController *)currentViewController
//{
//    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    while (viewController.presentedViewController) {
//        viewController = viewController.presentedViewController;
//    }
//    return viewController;
//}

//- (JGProgressHUD *)prototypeHUD {
//    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:1];
//    HUD.interactionType = 1;
//    
//    //if (_zoom) {
//       JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
//       HUD.animation = an;
////    }
////    
////    if (_dim) {
////        HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
////    }
//    
//   // if (_shadow) {
//        HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
//        HUD.HUDView.layer.shadowOffset = CGSizeZero;
//        HUD.HUDView.layer.shadowOpacity = 0.4f;
//        HUD.HUDView.layer.shadowRadius = 8.0f;
//   // }
//    
//    return HUD;
//}

- (void)showSuccessHUD {
//    if ([HUD isVisible]) {
//        [HUD dismiss];
//    }
//    HUD=self.prototypeHUD;
    //JGProgressHUD *HUD = self.prototypeHUD;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    HUD.textLabel.text = @"Success!";
//    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
//    
//    HUD.square = YES;
//    
//    [HUD showInView:[UIApplication sharedApplication].keyWindow];
//    
//    [HUD dismissAfterDelay:2.0];
}

- (void)showErrorHUD {
//    if ([HUD isVisible]) {
//        [HUD dismiss];
//    }
//    
//    HUD=self.prototypeHUD;
//    
//    HUD.textLabel.text = @"Error!";
//    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
//    
//    HUD.square = YES;
//    
//    [HUD showInView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //[HUD dismissAfterDelay:2.0];
}

- (void)showNormalHUD:(NSString *)title {
//    if ([HUD isVisible]) {
//        [HUD dismiss];
//    }
//    HUD=self.prototypeHUD;
//    
//    HUD.textLabel.text = title;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
   // [HUD showInView:[UIApplication sharedApplication].keyWindow];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //HUD.indicatorView = nil;
//        
//        HUD.textLabel.font = [UIFont systemFontOfSize:30.0f];
//        
//        HUD.textLabel.text = @"Loading";
//        
//        HUD.position = JGProgressHUDPositionBottomCenter;
//    });
    
   // HUD.marginInsets = UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f);
    
    //[HUD dismissAfterDelay:3.0];
}

-(void)Dismiss
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    // [HUD dismiss];
}

@end
