//
//  ProfileViewController.m
//  Virtual Closet
//
//  Created by Apple on 17/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCell.h"
#import "MyClosetViewController.h"
#import "SlidingViewController.h"
#import "MyLikesController.h"
#import "MyItemController.h"
#import "MessagesController.h"
#import "NewItemController.h"
#import "NotificationCOntroller.h"
#import "CreateClosetController.h"
#import "UserDetailViewController.h"
#import "AddFriendsViewController.h"
#import "GCHud.h"
#import "UIColor+Code.h"
#import "GCCacheSaver.h"
#import "AppDelegate.h"
#import "UIViewController+JDSideMenu.h"
#import "UIImageView+Network.h"
#import "UIImageView+WebCache.h"
#import "Flurry.h"
@implementation ProfileViewController

- (void)viewDidLoad {
    
    [Flurry logEvent:@"PROFILE_VIEW"];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_bg"]];
    self.Table.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_bg"]];
    
    IconImageArray=[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"hme_icon"],[UIImage imageNamed:@"folder_icon"],[UIImage imageNamed:@"item_icon"],[UIImage imageNamed:@"heart_icon"],[UIImage imageNamed:@"hme_icon"],[UIImage imageNamed:@"add_icon"],[UIImage imageNamed:@"invite_frnds"],[UIImage imageNamed:@"hme_icon"],[UIImage imageNamed:@"history_icon"],[UIImage imageNamed:@"notification_icon"],[UIImage imageNamed:@"message_icon"],[UIImage imageNamed:@"setting_icon"],[UIImage imageNamed:@"logout_btn"], nil];
    
    titleArray=[NSMutableArray arrayWithObjects:@"Newsfeed",@"My Closets",@"My Items",@"My Likes",@"",@"Add Items",@"Invite Friends",@"",@"Messages",@"Notifications",@"History Log",@"Settings",@"Logout", nil];
   // ProfileImage.placeholderImage=[UIImage imageNamed:@"defaultimage"];
   
    ProfileImage.layer.cornerRadius=ProfileImage.frame.size.height/2;
    ProfileImage.layer.masksToBounds=YES;
    //[ProfileImage setPlaceholderImage:[UIImage imageNamed:@"defaultimage"]];
  //  ProfileImage.imageURL=[NSURL URLWithString:[Utility UserImage]];
    //[ProfileImage loadImageFromURL:[NSURL URLWithString:[Utility UserImage]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
    
    UserName.text=[Utility UserName];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
//    CATransition *animation = [CATransition animation];
//    [animation setDelegate:self];
//    [animation setDuration:2.0f];
//    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
//    [animation setType:@"rippleEffect" ];
//    [self.view.layer addAnimation:animation forKey:NULL];
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [ProfileImage sd_setImageWithURL:[NSURL URLWithString:[Utility UserImage]] placeholderImage:[UIImage imageNamed:@"defaultimage"]];
    [self.navigationController.navigationBar setHidden:YES];
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [IconImageArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"profilecell";
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor brownColor];
    cell.selectedBackgroundView = selectionColor;
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.UperLineimage.hidden=YES;
    cell.NewLineimage.hidden=YES;
    cell.Lineimage.hidden=NO;
    if (indexPath.row==0 || indexPath.row==4 || indexPath.row==5 || indexPath.row==7|| indexPath.row==8) {
        cell.UperLineimage.hidden=NO;
    }
    if (indexPath.row==3 || indexPath.row==4 || indexPath.row==6 || indexPath.row==7) {
        cell.Lineimage.hidden=YES;
    }
    if (indexPath.row==12)
    {
        cell.NewLineimage.hidden=NO;
        cell.Lineimage.hidden=YES;
    }
    UIImage *image=[IconImageArray objectAtIndex:indexPath.row];
    cell.iconimage.image=image;
    if (indexPath.row==4 || indexPath.row==7){
        cell.iconimage.image=nil;
    }
//    if (indexPath.row==9) {
//         UILabel *lblNoti=[[UILabel alloc]initWithFrame:CGRectMake(230, 1, 30, 30)];
//         lblNoti.layer.cornerRadius=15.0;
//        [lblNoti setClipsToBounds:YES];
//        [lblNoti setBackgroundColor:[UIColor redColor]];
//        [lblNoti setText:@"1"];
//        [lblNoti setTextAlignment:NSTextAlignmentCenter];
//        [cell.contentView addSubview:lblNoti];
//    }
    cell.iconimage.frame=CGRectMake(cell.iconimage.frame.origin.x, cell.iconimage.frame.origin.y, image.size.width, image.size.height);
    cell.Textlable.text=[titleArray objectAtIndex:indexPath.row];
    cell.Textlable.textColor=[UIColor colorFromHexString:@"#e9e4cf"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        UIStoryboard *Story=self.storyboard;
        CreateClosetController *CenterView=[Story instantiateViewControllerWithIdentifier:@"create"];
        [SlidingViewController PushFromViewController4:self CenterviewController:CenterView];
    }
    if (indexPath.row==1) {
        UIStoryboard *Story=self.storyboard;
        MyClosetViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"mycloset"];
       [SlidingViewController PushFromViewController4:self CenterviewController:CenterView];
    }
    if (indexPath.row==3) {
        UIStoryboard *Story=self.storyboard;
        MyLikesController *CenterView=[Story instantiateViewControllerWithIdentifier:@"likes"];
        [SlidingViewController PushFromViewController4:self CenterviewController:CenterView];
    }
    if (indexPath.row==2) {
        UIStoryboard *Story=self.storyboard;
        MyItemController *CenterView=[Story instantiateViewControllerWithIdentifier:@"items"];
        [SlidingViewController PushFromViewController4:self CenterviewController:CenterView];
    }
    if (indexPath.row==8) {
        UIStoryboard *Story=self.storyboard;
        AppDelegate *App=(AppDelegate *)[UIApplication sharedApplication].delegate;
        App.messageview=[Story instantiateViewControllerWithIdentifier:@"message"];
       [SlidingViewController PushFromViewController4:self CenterviewController: App.messageview];
    }
     if (indexPath.row==10) {
         UIStoryboard *Story=self.storyboard;
         CreateClosetController *CenterView=[Story instantiateViewControllerWithIdentifier:@"create"];
         CenterView.History=YES;
        [SlidingViewController PushFromViewController4:self CenterviewController:CenterView];
     }
    if (indexPath.row==9) {
        UIStoryboard *Story=self.storyboard;
        NotificationCOntroller *CenterView=[Story instantiateViewControllerWithIdentifier:@"notification"];
       [SlidingViewController PushFromViewController4:self CenterviewController:CenterView];
    }
    
    if (indexPath.row==5) {
        UIStoryboard *Story=self.storyboard;
        NewItemController *CenterView=[Story instantiateViewControllerWithIdentifier:@"newitem"];
        EditingExisting=NO;
        [SlidingViewController PushFromViewController4:self CenterviewController:CenterView];
    }
    if (indexPath.row==6) {
    UIStoryboard *Story=self.storyboard;
    AddFriendsViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"addfriend"];
    //CenterView.ClosetID=cid;
    CenterView.Backhidden=YES;
   [SlidingViewController PushFromViewController4:self CenterviewController:CenterView];
        }
    if (indexPath.row==11) {
        UIStoryboard *Story=self.storyboard;
        UserDetailViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"user"];
         ownprofile=YES;
        settingsclick=YES;
        [SlidingViewController PushFromViewController4:self CenterviewController:CenterView];
    }
     if (indexPath.row==12) {
         
         [[GCHud Hud] showNormalHUD:@"Logging Out"];
//         NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//         [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
         [Utility RemoveUserid:@""];
        // [GCCacheSaver DeleteAllStoredData];
         [(AppDelegate*)[UIApplication sharedApplication].delegate initPushNotification];
         int64_t delayInSeconds = 0.6;
         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             [[GCHud Hud] showSuccessHUD];
             UIStoryboard *Story=self.storyboard;
             UIViewController *vc =[Story instantiateInitialViewController];
             self.view.window.rootViewController = vc;
         });
     }
}

-(IBAction)OpenProfile:(id)sender
{
    UIStoryboard *Story=self.storyboard;
    UserDetailViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"user"];
   ownprofile=YES;
    settingsclick=NO;
    [SlidingViewController PushFromViewController2:self CenterviewController:CenterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
