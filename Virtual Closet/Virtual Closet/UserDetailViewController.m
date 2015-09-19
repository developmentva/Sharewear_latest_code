//
//  UserDetailViewController.m
//  Virtual Closet
//
//  Created by Apple on 19/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "UserDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ItemCollectionCell.h"
#import "ClosetCell.h"
#import "UIColor+Code.h"
#import "SettingsView.h"
#import "UILabel+NavigationTitle.h"
#import "GCCacheSaver.h"
#import "GCFacebookSDK.h"
#import "ProfileViewController.h"
#import "SlidingViewController.h"
#import "AddFriendsViewController.h"
#import "MyClosetViewController.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "UIViewController+JDSideMenu.h"
#import "UIImageView+Network.h"
#import "UIImageView+WebCache.h"
#import "Flurry.h"
extern BOOL ownprofile,settingsclick;
@interface UserDetailViewController ()

@end

@implementation UserDetailViewController
@synthesize OwnProfile;
- (void)viewDidLoad {
    [Flurry logEvent:@"USER DETAIL VIEW"];
    if (ownprofile) {
       // ProfileImage.imageURL=[NSURL URLWithString:[Utility UserImage]];
     //   [ProfileImage loadImageFromURL:[NSURL URLWithString:[Utility UserImage]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
        [ProfileImage sd_setImageWithURL:[NSURL URLWithString:[Utility UserImage]] placeholderImage:[UIImage imageNamed:@"defaultimage"]];
        Username.text=[Utility UserName];
        self.UserID=[Utility UserID];
       
    }
    else{
       // ProfileImage.imageURL=[NSURL URLWithString:[Utility OtherUserImage]];
        //[ProfileImage loadImageFromURL:[NSURL URLWithString:[Utility OtherUserImage]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
         [ProfileImage sd_setImageWithURL:[NSURL URLWithString:[Utility OtherUserImage]] placeholderImage:[UIImage imageNamed:@"defaultimage"]];
        Username.text=[Utility OtherUserName];
         self.UserID=[Utility OtherUserID];
        SaveBut.hidden=YES;
        [self GetUserSetting];
        Itembut.selected=YES;
        PreviousBut=Itembut;
        FriendBase.hidden=YES;
    }
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    Table.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
     HistoryTable.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    UIImage *image = [UIImage imageNamed:@"list_icon1"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OpenProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=LeftButton;
    
    if (_backvisible) {
        image = [UIImage imageNamed:@"back_btn"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(BackPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *RightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem=RightButton;
    }
    
    
    self.navigationController.navigationItem.title=@"Add Friends";
    OptionBase.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
   
    //ProfileImage.image=[UIImage imageNamed:@"defaultimage"];
    ProfileImage.layer.cornerRadius=ProfileImage.frame.size.height/2;
    ProfileImage.layer.masksToBounds=YES;
    ProfileImage.layer.borderWidth=1;
    ProfileImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    
    Container.hidden=YES;
    
    [[SettingsView Settings] initializeonVIEW:self.view FOrUser:self.UserID IsOwner:ownprofile];
    [[SettingsView Settings].NibView setHidden:YES];
     HistoryTable.hidden=YES;
    [self NumberOfFriends];
    [self GetAllItems];
    [self GetAllClosets];
    [self GetAllHistory];
     [UILabel SetTitle:@"PROFILE" OnView:self];
    
    if (ownprofile) {
        if (settingsclick) {
            Collection.hidden=YES;
            Container.hidden=YES;
            HistoryTable.hidden=YES;
            [[SettingsView Settings].NibView setHidden:NO];
            SettingBut.selected=YES;
            PreviousBut=SettingBut;
            ButtonBase.center=SettingBut.center;
        }
    }
    else{
        Itembut.selected=YES;
        PreviousBut=Itembut;
    }
  //  [OptionBase sendSubviewToBack:[SettingsView Settings].NibView];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//
-(void)NumberOfFriends
{
    NSMutableDictionary *Frnds=[GCCacheSaver getDictionaryWithName:@"Friends" inRelativePath:[NSString stringWithFormat:@"List_%@",self.UserID]];
    if (Frnds) {
       NSMutableArray *frndscount=[[Frnds objectForKey:@"Friends"] mutableCopy];
        FriendsCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)frndscount.count];
    }
    [GCFacebookSDK getUserFriendsCallBack:^(BOOL success, id result) {
        [GCCacheSaver saveDictionary:[NSMutableDictionary dictionaryWithObject:result forKey:@"Friends"] withName:@"Friends" inRelativePath:[NSString stringWithFormat:@"List_%@",self.UserID]];
          NSMutableArray *frndscount=[result mutableCopy];
         FriendsCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)frndscount.count];
    }];
}

-(void)GetAllClosets
{
    NSMutableDictionary *dic=[GCCacheSaver getDictionaryWithName:@"newitem" inRelativePath:[NSString stringWithFormat:@"List_%@",self.UserID]];
    if (dic) {
        [self DisplayAllCloset:dic];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/get_closet.php?fb_id=54654654654654
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:self.UserID forKey:@"fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"newitem" inRelativePath:[NSString stringWithFormat:@"List_%@",self.UserID]];
            [self DisplayAllCloset:Dic];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    } Error:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

-(void)GetAllHistory
{
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"History" inRelativePath:[NSString stringWithFormat:@"List_%@",self.UserID]];
    if (Dic) {
        TimeStampArray=[[Dic objectForKey:@"time_stamp"] mutableCopy];
        NotificationArray=[[Dic objectForKey:@"notification"] mutableCopy];
        OwnerIdArray=[[Dic objectForKey:@"owner"] mutableCopy];
        ItemsArray=[[Dic objectForKey:@"item_detail"] mutableCopy];
        TypeArray=[[Dic objectForKey:@"type"] mutableCopy];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableDictionary *param=[NSMutableDictionary new];
    [param setObject:self.UserID forKey:@"fb_id"];
      [param setObject:@"history" forKey:@"type"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_feeds.php" WithParameter:param Success:^(NSMutableDictionary *Dic) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"History" inRelativePath:[NSString stringWithFormat:@"List_%@",self.UserID]];
            TimeStampArray=[[Dic objectForKey:@"time_stamp"] mutableCopy];
            NotificationArray=[[Dic objectForKey:@"notification"] mutableCopy];
            OwnerIdArray=[[Dic objectForKey:@"owner"] mutableCopy];
            ItemsArray=[[Dic objectForKey:@"item_detail"] mutableCopy];
            TypeArray=[[Dic objectForKey:@"type"] mutableCopy];
        }
    } Error:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

-(void)GetUserSetting
{
//     NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"UserSettings" inRelativePath:[NSString stringWithFormat:@"Settings_%@",_UserID]];
//    if (Dic) {
//        [self StoreSettings:Dic];
//    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/get_settings.php?fb_id=1495571574062460
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:self.UserID forKey:@"fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_settings.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [self StoreSettings:Dic];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    } Error:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}
-(void)StoreSettings:(NSMutableDictionary *)dic
{
    NSMutableDictionary *Settings=[NSMutableDictionary new];
    [Settings setObject:AvoidNull([dic objectForKey:@"shoe"]) forKey:@"ShoeSize"];
    [Settings setObject:AvoidNull([dic objectForKey:@"dress_size"]) forKey:@"DressSize"];
    [Settings setObject:AvoidNull([dic objectForKey:@"blouse"]) forKey:@"Blouse"];
    [Settings setObject:AvoidNull([dic objectForKey:@"pant"]) forKey:@"pantsize"];
    //[Settings setObject:[dic objectForKey:@"brands"] forKey:@"Preffered"];
    [GCCacheSaver saveDictionary:Settings withName:@"UserSettings" inRelativePath:[NSString stringWithFormat:@"Settings_%@",self.UserID]];
}


-(void)DisplayAllCloset:(NSMutableDictionary *)Dic
{
    ClosetnameArrray=[Dic objectForKey:@"closet_names"];
    ClosetIDArray=[Dic objectForKey:@"closet_id"];
    ClosetImageArray=[Dic objectForKey:@"closet_icon"];
    ClosetCount.text=[NSString stringWithFormat:@"%i",ClosetIDArray.count];
    [Table reloadData];
}
-(void)GetAllItems
{
    NSMutableDictionary *dic=[GCCacheSaver getDictionaryWithName:@"items" inRelativePath:[NSString stringWithFormat:@"List_%@",self.UserID]];
    if (dic) {
        [self DisplayAllItems:dic];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/get_items_by_user.php?fb_id=1431659760454917
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:self.UserID forKey:@"fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_items_by_user.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"items" inRelativePath:[NSString stringWithFormat:@"List_%@",self.UserID]];
            [self DisplayAllItems:Dic];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    } Error:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

-(void)DisplayAllItems:(NSMutableDictionary *)Dic
{
    MyItemsIdArray=[[Dic objectForKey:@"item_ids"] mutableCopy];
    MyItemsBrandArray=[[Dic objectForKey:@"brand_arr"] mutableCopy];
    MyItemsColorArray=[[Dic objectForKey:@"color_arr"] mutableCopy];
    MyItemsDecripArray=[[Dic objectForKey:@"description_arr"] mutableCopy];
    MyItemsImageArray=[[Dic objectForKey:@"image_name_arr"] mutableCopy];
    MyItemsSizeArray=[[Dic objectForKey:@"size_arr"] mutableCopy];
    MyItemsStatusArray=[[Dic objectForKey:@"status_arr"] mutableCopy];
    MyItemsTypeArray=[[Dic objectForKey:@"type_arr"] mutableCopy];
    [Collection reloadData];
}




-(void)OpenProfile:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

-(void)BackPress:(id)sender
{
    [SlidingViewController Dissmissfrom:self];
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

-(IBAction)OptionPressed:(UIButton *)sender
{
    UIButton *PreBut=(UIButton *)PreviousBut;
    PreBut.selected=NO;
    sender.selected=YES;
    switch ([sender tag]) {
        case 0:
        {
            Collection.hidden=NO;
             Container.hidden=YES;
             HistoryTable.hidden=YES;
            [[SettingsView Settings].NibView setHidden:YES];
            break;
        }
        case 1:
        {
            history=NO;
             Collection.hidden=YES;
             Container.hidden=NO;
             HistoryTable.hidden=YES;
            [[SettingsView Settings].NibView setHidden:YES];
             [Table reloadData];
            break;
        }
        case 2:
        {
            history=YES;
            Collection.hidden=YES;
            Container.hidden=YES;
            HistoryTable.hidden=NO;
           [[SettingsView Settings].NibView setHidden:YES];
            [HistoryTable reloadData];
            break;
        }
        case 3:
        {
             Collection.hidden=YES;
             Container.hidden=YES;
             HistoryTable.hidden=YES;
            [[SettingsView Settings].NibView setHidden:NO];
            break;
        }
            
        default:
            break;
    }
    [UIView animateWithDuration:.5 animations:^{
        ButtonBase.center=sender.center;
    }completion:^(BOOL finished) {
        PreviousBut=sender;
    }];
    
}

-(IBAction)UserFriends:(id)sender
{
    UIStoryboard *Story=self.storyboard;
    AddFriendsViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"addfriend"];
    //CenterView.ClosetID=cid;
   [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}

-(IBAction)UserCloset:(id)sender
{
    UIStoryboard *Story=self.storyboard;
    MyClosetViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"mycloset"];
   [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MyItemsIdArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"itemcell";
    
    ItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.closetimage.layer.borderColor=[UIColor darkGrayColor].CGColor;
    cell.closetimage.layer.borderWidth=1;
  //  cell.closetimage.imageURL=[NSURL URLWithString:[MyItemsImageArray objectAtIndex:indexPath.row]];
    if ([[MyItemsImageArray objectAtIndex:indexPath.row] isKindOfClass:[NSData class]]) {
        cell.closetimage.image=[UIImage imageWithData:[MyItemsImageArray objectAtIndex:indexPath.row]];
    }
    else{
    [cell.closetimage loadImageFromURL:[NSURL URLWithString:[MyItemsImageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
    }
   // [cell.closetimage setPlaceholderImage:[UIImage imageNamed:@"defaultimage"]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCollectionCell *cell=(ItemCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = cell.closetimage.image;
    imageInfo.referenceRect = cell.closetimage.frame;
    //imageInfo.referenceView = cell.closetimage.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (history)?ItemsArray.count:ClosetIDArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"closetcell";
    ClosetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (history) {
         NSInteger index=NotificationArray.count-1;
        cell.timelable.text=[Utility TimeAgo:[self getDateFromUnixFormat:[TimeStampArray objectAtIndex:index-indexPath.row]]];
        cell.Titlelable.text=[NotificationArray objectAtIndex:index-indexPath.row];
        cell.Titlelable.textColor=[UIColor colorFromHexString:@"#25AAA0"];
       // cell.Closetimage.placeholderImage=[UIImage imageNamed:@"defaultimage"];
       // cell.Closetimage.imageURL=[NSURL URLWithString:[[ItemsArray objectAtIndex:index-indexPath.row] objectForKey:@"image_name"]];
        if ([[[ItemsArray objectAtIndex:index-indexPath.row] objectForKey:@"image_name"] isKindOfClass:[NSData class]]) {
            cell.Closetimage.image=[UIImage imageWithData:[[ItemsArray objectAtIndex:index-indexPath.row] objectForKey:@"image_name"]];
        }
        else{
        [cell.Closetimage loadImageFromURL:[NSURL URLWithString:[[ItemsArray objectAtIndex:index-indexPath.row] objectForKey:@"image_name"]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
        }
    }
    else{
        NSInteger index=ClosetnameArrray.count-1;
        cell.timelable.text=[Utility TimeAgo:[self getDateFromUnixFormat:[TimeStampArray objectAtIndex:index-indexPath.row]]];
    cell.Titlelable.text=[ClosetnameArrray objectAtIndex:index-indexPath.row];
    cell.Titlelable.textColor=[UIColor colorFromHexString:@"#25AAA0"];
   // cell.Closetimage.placeholderImage=[UIImage imageNamed:@"defaultimage"];
  //  cell.Closetimage.imageURL=[NSURL URLWithString:[ClosetImageArray objectAtIndex:index-indexPath.row]];
        if ([[ClosetImageArray objectAtIndex:index-indexPath.row] isKindOfClass:[NSData class]]) {
            cell.Closetimage.image=[UIImage imageWithData:[ClosetImageArray objectAtIndex:index-indexPath.row]];
        }
        else{
          [cell.Closetimage loadImageFromURL:[NSURL URLWithString:[ClosetImageArray objectAtIndex:index-indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create image info
    ClosetCell *cell=(ClosetCell *)[tableView cellForRowAtIndexPath:indexPath];
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = cell.Closetimage.image;
    imageInfo.referenceRect = cell.Closetimage.frame;
    // imageInfo.referenceView = cell.closetimage.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

-(IBAction)OpenProfilePic:(id)sender
{
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = ProfileImage.image;
    imageInfo.referenceRect = ProfileImage.frame;
    // imageInfo.referenceView = cell.closetimage.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (NSDate *) getDateFromUnixFormat:(NSString *)unixFormat
{
    if ([unixFormat isKindOfClass:[NSNull class]]) {
        return [NSDate date];
    }
    return  [NSDate dateWithTimeIntervalSince1970:[unixFormat intValue]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
