//
//  AppDelegate.m
//  Virtual Closet
//
//  Created by Apple on 12/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+Code.h"
#import "Macro.h"
#import "GCFacebookSDK.h"
#import "MainViewController.h"
#import "ProfileViewController.h"
#import "ServerParsing.h"
#import <Parse/Parse.h>
#import "ViewController.h"
#import "CreateClosetController.h"
#import <AudioToolbox/AudioServices.h>
#import "UIViewController+JDSideMenu.h"
@interface AppDelegate ()
{
    
    ViewController *Controller;
}
@end

@implementation AppDelegate
@synthesize InChatView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    sleep(3);
    UIStoryboard *Story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    // SETUP FLURRY KEY
    
    [Flurry startSession:@"JKY558Y7ZP6F4YB4MHQT"];
    [Flurry setCrashReportingEnabled:YES];
    
    if ([Utility UserID]) {
         CreateClosetController *CenterView=[Story instantiateViewControllerWithIdentifier:@"create"];
         ProfileViewController *LeftView=[Story instantiateViewControllerWithIdentifier:@"profile"];
        //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
         self.window.rootViewController = [SlidingViewController RootToViewController:CenterView LeftviewController:LeftView];
        [self.window makeKeyAndVisible];
    }
    else
    {
        Controller =[Story instantiateInitialViewController];
       // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = Controller;
        [self.window makeKeyAndVisible];
    }
    if (isIOS6) {
        [[UINavigationBar appearance] setTintColor:[UIColor colorFromHexString:@"#25AAA0"]];
    }
    else if (isIOS7) {
       [[UINavigationBar appearance] setBarTintColor:[UIColor colorFromHexString:@"#25AAA0"]];
    }
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [GCFacebookSDK initWithPermissions:@[@"user_about_me",
                                         @"user_birthday",
                                         @"email",
                                         @"user_photos",
                                         @"publish_stream",
                                         @"user_events",
                                         @"friends_events",
                                         @"manage_pages",
                                         @"share_item",
                                         @"publish_actions",
                                         @"user_friends",
                                         @"manage_pages",
                                         @"user_videos",
                                         @"public_profile"]];
    _Application=application;
    [Parse setApplicationId:@"wBo1f7ByC2uSc8pPet6KO8H6viAVulfcIckSsOJM" clientKey:@"AVGIMeqhc8nDYscRxlQthsEuoRvxY7u4dHMOskqp"];
     [Utility SaveDeviceToken:@"edghofghf"];
    Opened=YES;
    [self initPushNotification];
    return YES;
}



-(void)PushToHome:(UIViewController *)controller
{
    UIStoryboard *Story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MainViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"main"];
   // UINavigationController *contentController = [[UINavigationController alloc]
      ///                                     initWithRootViewController:CenterView];
    [SlidingViewController PushFromViewController2:controller CenterviewController:CenterView];
}
-(void)initPushNotification
{
    if ([_Application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [_Application registerUserNotificationSettings:settings];
        [_Application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [_Application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *dToken = [[[[deviceToken description]
                               stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    [Utility SaveDeviceToken:dToken];
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (!self.InChatView) {
        // [PFPush handlePush:userInfo];
       // NSLog(@"%@",userInfo);
      //  NSDictionary *aps=[userInfo objectForKey:@"aps"];
        
        //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        if (!Opened) {
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"message"]) {
                
                UIStoryboard *Story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                MessagesController *CenterView=[Story instantiateViewControllerWithIdentifier:@"message"];
                [SlidingViewController PushFromViewController2:[self currentViewController] CenterviewController:CenterView];
//                UIViewController *Current=[self currentViewController];
//                //ICSDrawerController *c=(ICSDrawerController *)Current;
//
//                NSString *CurrentSelectedCViewController = NSStringFromClass([[((UINavigationController *)Current) visibleViewController] class]);
//                
//               
//                if ([CurrentSelectedCViewController isEqualToString:@"MessagesController"]) {
//                    [self.messageview viewWillAppear:YES];
//                }
//                else{
//                     MessagesController *CenterView=[Story instantiateViewControllerWithIdentifier:@"message"];
//                    ProfileViewController *LeftView=[Story instantiateViewControllerWithIdentifier:@"profile"];
//                    [SlidingViewController PushFromViewController:Current CenterviewController:CenterView LeftviewController:LeftView];
//                }
                
            }
            
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"notification"]) {
                
                
                UIStoryboard *Story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                NotificationCOntroller *CenterView=[Story instantiateViewControllerWithIdentifier:@"notification"];
                [SlidingViewController PushFromViewController5:[self currentViewController] CenterviewController:CenterView];
//                UIViewController *Current=[self currentViewController];
//               // ICSDrawerController *c=(ICSDrawerController *)Current;
//                NSString *CurrentSelectedCViewController = NSStringFromClass([[((UINavigationController *)Current) visibleViewController] class]);
//                if ([CurrentSelectedCViewController isEqualToString:@"NotificationCOntroller"]) {
//                    [self.notifi viewWillAppear:YES];
//                }
//                else{
//                    NotificationCOntroller *CenterView=[Story instantiateViewControllerWithIdentifier:@"notification"];
//                    [SlidingViewController PushFromViewController2:[self currentViewController] CenterviewController:CenterView];
//                }
               
            }
        }
        else{
            
             if ([[userInfo objectForKey:@"type"] isEqualToString:@"message"]) {
                 isMessage=YES;
             }
             else{
                isMessage=NO;
             }
            NSDictionary *aps=[userInfo objectForKey:@"aps"];
            NZAlertView *alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                              title:@"ShareWear"
                                                            message:[aps objectForKey:@"alert"]
                                                           delegate:self];
            tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
            [alert addGestureRecognizer:tap];
            alert.alertDuration=2;
            [alert show];
        }
       
    }
    else{
//        NSDictionary *aps=[userInfo objectForKey:@"aps"];
//        NZAlertView *alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
//                                                          title:@"ShareWear"
//                                                        message:[aps objectForKey:@"alert"]
//                                                       delegate:self];
//        alert.alertDuration=2;
//        [alert show];
    }
   
}

-(void)tapped:(UIGestureRecognizer *)gesture
{
//    if (isMessage) {
//        UIStoryboard *Story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        MessagesController *CenterView=[Story instantiateViewControllerWithIdentifier:@"message"];
//        [SlidingViewController PushFromViewController2:[self currentViewController] CenterviewController:CenterView];
//    }
//    else{
//        UIStoryboard *Story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        NotificationCOntroller *CenterView=[Story instantiateViewControllerWithIdentifier:@"notification"];
//        [SlidingViewController PushFromViewController5:[self currentViewController] CenterviewController:CenterView];
//    }
}
- (UIViewController *)currentViewController
{
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL wasHandled = [FBAppCall handleOpenURL:url
//                             sourceApplication:sourceApplication];
//    return wasHandled;
//}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)UserStatus
{
    if ([Utility UserID]) {
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:[Utility UserID] forKey:@"uid"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/active_user.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            }
        } Error:^{
        }];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([ActiveUser isValid]) {
        [ActiveUser invalidate];
        ActiveUser=nil;
    }
    Opened=NO;
   
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
    if ([ActiveUser isValid]) {
        [ActiveUser invalidate];
        ActiveUser=nil;
    }
    //[self UserStatus];
    [self UpdateBadge];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
   // ActiveUser=[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(UserStatus) userInfo:nil repeats:YES];
     Opened=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshapi" object:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

-(void)UpdateBadge
{
    if ([Utility UserID]) {
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:[Utility Devicetoken] forKey:@"devicetoken"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/clear.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            }
        } Error:^{
        }];
    }
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController");
}


#pragma mark -
#pragma mark - NZAlertViewDelegate

- (void)willPresentNZAlertView:(NZAlertView *)alertView
{
    NSLog(@"%s\n\t alert will present", __PRETTY_FUNCTION__);
}

- (void)didPresentNZAlertView:(NZAlertView *)alertView
{
    NSLog(@"%s\n\t alert did present", __PRETTY_FUNCTION__);
}

- (void)NZAlertViewWillDismiss:(NZAlertView *)alertView
{
    NSLog(@"%s\n\t alert will dismiss", __PRETTY_FUNCTION__);
}

- (void)NZAlertViewDidDismiss:(NZAlertView *)alertView
{
    [alertView removeGestureRecognizer:tap];
    NSLog(@"%s\n\t alert did dismiss", __PRETTY_FUNCTION__);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
