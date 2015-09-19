//
//  SlidingViewController.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDSideMenu.h"
#import "REFrostedViewController.h"
#import "GCNavController.h"
@interface SlidingViewController : NSObject<REFrostedViewControllerDelegate>
+(void)PushFromViewController:(UIViewController *)From CenterviewController:(UIViewController *)Center LeftviewController:(UIViewController *)Left;// Block:(DrawerBlocks)object;
+(REFrostedViewController*)RootToViewController:(UIViewController *)Center LeftviewController:(UIViewController *)Left;
+(void)PushFromViewController2:(UIViewController *)From CenterviewController:(UIViewController *)navcenter;
+(void)PushFromViewController3:(UIViewController *)From CenterviewController:(UIViewController *)center;
+(void)PushFromViewController4:(UIViewController *)From CenterviewController:(UIViewController *)center;
+(void)PushFromViewController5:(UIViewController *)From CenterviewController:(UIViewController *)center;
+(void)Dissmissfrom:(UIViewController *)From;
@end
