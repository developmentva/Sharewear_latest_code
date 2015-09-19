//
//  ViewController.m
//  Virtual Closet
//
//  Created by Apple on 12/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "ProfileViewController.h"
#import "UINavigationController+Navigation.h"
#import "SlidingViewController.h"
#import "GCFacebookSDK.h"
#import "GCHud.h"
#import "GCCacheSaver.h"
#import "JGProgressHUD.h"
#import "AppDelegate.h"
#import "CreateClosetController.h"
#import "TermsAndPrivacy.h"
#import "Flurry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [Flurry logEvent:@"HOME_VIEW"];
    if ((int)[[UIScreen mainScreen] bounds].size.height == 480)
    {
        self.ViewBase.frame =CGRectMake(71, 437, 178, 43);
        btnCheked.frame =CGRectMake(46, 446, 25, 25);
    }
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"back_bg"]];
    [btnCheked setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [btnCheked setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [btnCheked setSelected:NO];
    self.navigationController.title=@"";
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
    [super viewWillAppear:animated];
}
- (IBAction)termsAndCOnditionCheckeButton:(id)sender {
    btnCheked.selected=!btnCheked.selected;
}
JGProgressHUD *Hud;
-(IBAction)FacebookLogin:(id)sender
{
//    UIStoryboard *Story=self.storyboard;
//    MainViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"main"];
//    ProfileViewController *LeftView=[Story instantiateViewControllerWithIdentifier:@"profile"];
//    [SlidingViewController PushFromViewController:self CenterviewController:CenterView LeftviewController:LeftView Block:^(ICSDrawerController *drawer) {
//        CenterView.drawer=drawer;
//    }];
    if (!btnCheked.selected) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ShareWear" message:@"You have to accept Terms of Use & Privacy Policy before login." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [GCFacebookSDK loginCallBack:^(BOOL success, id result) {
        if (success) {
            
             Hud=  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
            [Hud showInView:self.view];
            [GCFacebookSDK getUserFields:@"id, name, email, birthday, about, picture" callBack:^(BOOL success, id result) {
                if (success) {
                    NSLog(@"%@", result);
                    [self UserInfromation:result];
                }else{
                }
            }];
            [GCFacebookSDK getUserFriendsCallBack:^(BOOL success, id result) {
                [GCCacheSaver saveDictionary:[NSMutableDictionary dictionaryWithObject:result forKey:@"Friends"] withName:@"Friends" inRelativePath:@"List"];
            }];
        }else{
        }
    }];
    
}


-(void)UserInfromation:(id)info{
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/add_user.php?fb_user_name=klggljk&email=jhrr@sddsdj.com&img=aaaaaaaaa&fb_user_id=457767
    
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[info objectForKey:@"name"] forKey:@"fb_user_name"];
    [Param setObject:[info objectForKey:@"email"] forKey:@"email"];
    [Param setObject:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[info objectForKey:@"id"]] forKey:@"img"];
    [Param setObject:[info objectForKey:@"id"] forKey:@"fb_user_id"];
    [Param setObject:[Utility Devicetoken] forKey:@"device_token"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/add_user.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        NSLog(@"%@",Dic);
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [[GCHud Hud] showSuccessHUD];
            [Hud dismiss];
            [Utility SaveUserid:AvoidNull([info objectForKey:@"id"])];
            [Utility SaveUserName:AvoidNull([info objectForKey:@"name"])];
            [Utility SaveUserImage:AvoidNull([info objectForKey:@"id"])];
            [self StoreSettings:Dic];
            UIStoryboard *Story=self.storyboard;
            NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"feeds" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            if (!Dic) {
                MainViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"main"];
                ProfileViewController *LeftView=[Story instantiateViewControllerWithIdentifier:@"profile"];
                [SlidingViewController PushFromViewController:self CenterviewController:CenterView LeftviewController:LeftView];
                
        
            }
            else{
               CreateClosetController *CenterView=[Story instantiateViewControllerWithIdentifier:@"create"];
                ProfileViewController *LeftView=[Story instantiateViewControllerWithIdentifier:@"profile"];
                [SlidingViewController PushFromViewController:self CenterviewController:CenterView LeftviewController:LeftView];
            }
           
        }
    } Error:^{
        [[GCHud Hud] showErrorHUD];
    }];
}
-(void)StoreSettings:(NSMutableDictionary *)dic
{
    NSMutableDictionary *Settings=[NSMutableDictionary new];
    [Settings setObject:AvoidNull([dic objectForKey:@"shoe"]) forKey:@"ShoeSize"];
    [Settings setObject:AvoidNull([dic objectForKey:@"dress_size"]) forKey:@"DressSize"];
    [Settings setObject:AvoidNull([dic objectForKey:@"blouse"]) forKey:@"Blouse"];
    [Settings setObject:AvoidNull([dic objectForKey:@"pant"]) forKey:@"pantsize"];
    [GCCacheSaver saveDictionary:Settings withName:@"UserSettings" inRelativePath:[NSString stringWithFormat:@"Settings_%@",[Utility UserID]]];
}
-(IBAction)TermsPrivacy:(id)sender
{
    UIStoryboard *Story=self.storyboard;
    TermsAndPrivacy *CenterView=[Story instantiateViewControllerWithIdentifier:@"web"];
    CenterView.type= ([sender tag]==0)?1:2;
    UINavigationController *Nav=[[UINavigationController alloc]initWithRootViewController:CenterView];
    [self presentViewController:Nav animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
