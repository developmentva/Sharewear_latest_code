//
//  UINavigationController+Navigation.h
//  Virtual Closet
//
//  Created by Apple on 17/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Navigation)
- (void)pushViewControllerFrom:(UIViewController*)FromviewController
          ToViewControllerFrom:(UIViewController*)ToviewController;
- (void)popViewControllerFrom:(UIViewController*)FromviewController;
@end
