//
//  AppDelegate.h
//  Virtual Closet
//
//  Created by Apple on 12/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "SlidingViewController.h"
#import "NZAlertViewDelegate.h"
#import "MessagesController.h"
#import "NotificationCOntroller.h"
#import "REFrostedViewController.h"
#import "Flurry.h"

BOOL ownprofile;
NSString *ItemI;
NSString *OwnerI;
NSString *ClosetI;
@interface AppDelegate : UIResponder <UIApplicationDelegate,NZAlertViewDelegate,REFrostedViewControllerDelegate>
{
    NSTimer *ActiveUser;
    BOOL Opened,isMessage;
    UITapGestureRecognizer *tap;
}
@property BOOL InChatView;
@property (strong, nonatomic) UIWindow *window;
-(void)initPushNotification;
@property (strong, nonatomic)UIApplication *Application;
@property (strong, nonatomic)MessagesController *messageview;
@property (strong, nonatomic)NotificationCOntroller *notifi;
@property (strong, nonatomic)UIViewController *PreviousController;
-(void)PushToHome:(UIViewController *)controller;
@end

