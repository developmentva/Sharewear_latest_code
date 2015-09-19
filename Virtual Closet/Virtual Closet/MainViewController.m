//
//  MainViewController.m
//  Virtual Closet
//
//  Created by Apple on 17/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "MainViewController.h"
#import "ProfileViewController.h"
#import "CreateClosetController.h"
#import "CreateNewClosetController.h"
#import "UINavigationController+Navigation.h"
#import "SlidingViewController.h"
#import "JoinClosetController.h"
#import "GCHud.h"
#import "UIViewController+JDSideMenu.h"
#import "Flurry.h"
@implementation MainViewController
- (void)viewDidLoad {
    [Flurry logEvent:@"MAIN_VIEW"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    UIImage *image = [UIImage imageNamed:@"list_icon1"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OpenProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=LeftButton;

    
//    image = [UIImage imageNamed:@"logout_btn"];
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
//    [button setImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(OpenHome:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *RightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem=RightButton;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)OpenProfile:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

-(void)OpenHome:(id)sender
{
    [[GCHud Hud] showNormalHUD:@"Logging Out"];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    int64_t delayInSeconds = 0.6;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[GCHud Hud] showSuccessHUD];
        UIStoryboard *Story=self.storyboard;
        UIViewController *vc=[Story instantiateInitialViewController];
         [vc dismissViewControllerAnimated:YES completion:nil];
    });
   
}

-(IBAction)CreateNew:(id)sender
{
    UIStoryboard *Story=self.storyboard;
    CreateNewClosetController *CenterView=[Story instantiateViewControllerWithIdentifier:@"createnew"];
   [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}
-(IBAction)JoinNew:(id)sender
{
    UIStoryboard *Story=self.storyboard;
    JoinClosetController *CenterView=[Story instantiateViewControllerWithIdentifier:@"Join"];
    [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
