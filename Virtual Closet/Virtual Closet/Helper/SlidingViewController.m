//
//  SlidingViewController.m
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "SlidingViewController.h"
#import "AppDelegate.h"
#import "UIViewController+JDSideMenu.h"
@implementation SlidingViewController

+(void)PushFromViewController:(UIViewController *)From CenterviewController:(UIViewController *)Center LeftviewController:(UIViewController *)Left //Block:(DrawerBlocks)object
{
    AppDelegate *App=(AppDelegate *)[UIApplication sharedApplication].delegate;
    App.window.rootViewController = [SlidingViewController RootToViewController:Center LeftviewController:Left];
    [App.window makeKeyAndVisible];
}

+(void)PushFromViewController2:(UIViewController *)From CenterviewController:(UIViewController *)center
{
     GCNavController *navcenter=[[GCNavController alloc]initWithRootViewController:center];
    From.frostedViewController.contentViewController = navcenter;
    [From.frostedViewController hideMenuViewController];
}
+(void)PushFromViewController3:(UIViewController *)From CenterviewController:(UIViewController *)center
{
   // GCNavController *navcenter=[[GCNavController alloc]initWithRootViewController:center];
    [From.navigationController pushViewController:center animated:YES];
    
}
+(void)PushFromViewController5:(UIViewController *)From CenterviewController:(UIViewController *)center
{
    [From.frostedViewController hideMenuViewController];
    // GCNavController *navcenter=[[GCNavController alloc]initWithRootViewController:center];
    [From.frostedViewController.contentViewController.navigationController pushViewController:center animated:YES];
    
}
+(void)PushFromViewController4:(UIViewController *)From CenterviewController:(UIViewController *)center
{
    GCNavController *navcenter=[[GCNavController alloc]initWithRootViewController:center];
    From.frostedViewController.contentViewController = navcenter;
    [From.frostedViewController hideMenuViewController];

}

+(REFrostedViewController*)RootToViewController:(UIViewController *)Center LeftviewController:(UIViewController *)Left
{
    GCNavController *navcenter=[[GCNavController alloc]initWithRootViewController:Center];
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navcenter menuViewController:[[UINavigationController alloc] initWithRootViewController:Left]];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    return frostedViewController;
}

+(void)Dissmissfrom:(UIViewController *)From
{
    [From.navigationController popViewControllerAnimated:YES];
}




@end
