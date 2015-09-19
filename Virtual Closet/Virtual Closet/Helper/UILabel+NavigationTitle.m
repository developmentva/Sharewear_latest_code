//
//  UILabel+NavigationTitle.m
//  Virtual Closet
//
//  Created by Apple on 20/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "UILabel+NavigationTitle.h"

@implementation UILabel (NavigationTitle)

+(void)SetTitle:(NSString *)title OnView:(UIViewController *)controller
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 45)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"GoodMobiPro-CondBold" size:24];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    controller.navigationItem.titleView = label;
    label.text = title;
    [label sizeToFit];
}
@end
