//
//  UINavigationController+Navigation.m
//  Virtual Closet
//
//  Created by Apple on 17/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "UINavigationController+Navigation.h"

@implementation UINavigationController (Navigation)
- (void)pushViewControllerFrom:(UIViewController*)FromviewController
      ToViewControllerFrom:(UIViewController*)ToviewController
{
    [UIView transitionFromView:FromviewController.view
                        toView:ToviewController.view
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    completion:nil];
    [UIView transitionFromView:FromviewController.navigationItem.titleView
                        toView:ToviewController.navigationItem.titleView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    completion:nil];
    [FromviewController.navigationController pushViewController:ToviewController animated:NO];
}

- (void)popViewControllerFrom:(UIViewController*)FromviewController
{
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
}
@end
