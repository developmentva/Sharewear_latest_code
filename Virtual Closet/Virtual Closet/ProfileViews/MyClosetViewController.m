//
//  MyClosetViewController.m
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "MyClosetViewController.h"
#import "ClosetCollection.h"
#import "ClosetDetailController.h"
#import "ProfileViewController.h"
#import "SlidingViewController.h"
#import "UILabel+NavigationTitle.h"
#import "GCHud.h"
#import "CreateNewClosetController.h"
#import "GCCacheSaver.h"
#import "AppDelegate.h"
#import "UIImageView+Network.h"
#import "UIViewController+JDSideMenu.h"
#import "Flurry.h"
@implementation MyClosetViewController
- (void)viewDidLoad {
    [Flurry logEvent:@"MYCLOSESET_VIEW"];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    UIImage *image = [UIImage imageNamed:@"list_icon1"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OpenProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=LeftButton;
    
    if (self.Backvisible) {
        image = [UIImage imageNamed:@"back_btn"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(BackPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *RightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem=RightButton;
    }
   
    
     [UILabel SetTitle:@"My Closets" OnView:self];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyallClosets) name:@"refreshapi" object:nil];
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"closet" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            ClosetNameArray=[[Dic objectForKey:@"closet_names"] mutableCopy];
            ClosetIdArray=[[Dic objectForKey:@"closet_id"] mutableCopy];
            ClosetIconArray=[[Dic objectForKey:@"closet_icon"] mutableCopy];
            ClosetStatusArray=[[Dic objectForKey:@"status"] mutableCopy];
            ClosetPrivacyArray=[[Dic objectForKey:@"privacy_type"] mutableCopy];
            OwnerIDArray=[[Dic objectForKey:@"owner_id_arr"] mutableCopy];
            [_Collection reloadData];
        }
    }
     [self getMyallClosets];
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshapi" object:nil];
    [super viewWillDisappear:animated];
}

-(IBAction)CreateNew:(id)sender
{
//    UIStoryboard *Story=self.storyboard;
//    CreateNewClosetController *CenterView=[Story instantiateViewControllerWithIdentifier:@"createnew"];
//    ProfileViewController *LeftView=[Story instantiateViewControllerWithIdentifier:@"profile"];
//    [SlidingViewController PushFromViewController:self CenterviewController:CenterView LeftviewController:LeftView Block:^(ICSDrawerController *drawer) {
//        CenterView.drawer=drawer;
//    }];
    [(AppDelegate *)[UIApplication sharedApplication].delegate PushToHome:self];
}


-(void)getMyallClosets
{
    
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/all_closet_list.php?fb_id=5648512
   // [[GCHud Hud] showNormalHUD:@"Fetching List"];
  //  [[UIApplication sharedApplication] ]
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[Utility UserID] forKey:@"fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/all_closet_list.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"closet" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            ClosetNameArray=[[Dic objectForKey:@"closet_names"] mutableCopy];
            ClosetIdArray=[[Dic objectForKey:@"closet_id"] mutableCopy];
            ClosetIconArray=[[Dic objectForKey:@"closet_icon"] mutableCopy];
            ClosetStatusArray=[[Dic objectForKey:@"status"] mutableCopy];
             ClosetPrivacyArray=[[Dic objectForKey:@"privacy_type"] mutableCopy];
             OwnerIDArray=[[Dic objectForKey:@"owner_id_arr"] mutableCopy];
            [_Collection reloadData];
        }
        if ([[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"closet" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            [ClosetNameArray removeAllObjects];
            [ClosetIdArray removeAllObjects];
            [ClosetIconArray removeAllObjects];
            [ClosetStatusArray removeAllObjects];
            [ClosetPrivacyArray removeAllObjects];
             [OwnerIDArray removeAllObjects];
            [_Collection reloadData];
        }
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        // [[GCHud Hud] showSuccessHUD];
    } Error:^{
        // [[GCHud Hud] showErrorHUD];
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

-(void)OpenProfile:(id)sender
{
//    if ([self.sideMenuController isMenuVisible]) {
//        [self.sideMenuController hideMenuAnimated:YES];
//    }
//    else{
//        [self.sideMenuController showMenuAnimated:YES];
//    }
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ClosetNameArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"collection";
    
    ClosetCollection *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.closetimage.layer.cornerRadius=cell.closetimage.frame.size.height/2;
    cell.closetimage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.closetimage.layer.borderWidth=1;
    cell.closetimage.layer.masksToBounds=YES;
    //cell.closetimage.placeholderImage=[UIImage imageNamed:@"defaultimage"];
    NSInteger index=ClosetNameArray.count-1;
    cell.closetimage.contentMode = UIViewContentModeScaleAspectFill;
   // [cell.closetimage setImageURL:[NSURL URLWithString:[self RemoveNull:[ClosetIconArray objectAtIndex:index-indexPath.row]]]];
    if ([[ClosetIconArray objectAtIndex:index-indexPath.row] isKindOfClass:[NSData class]]) {
        cell.closetimage.image=[UIImage imageWithData:[ClosetIconArray objectAtIndex:index-indexPath.row]];
    }
    else{
    [cell.closetimage loadImageFromURL:[NSURL URLWithString:[self RemoveNull:[ClosetIconArray objectAtIndex:index-indexPath.row]]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
    }
   // cell.closetimage.imageURL=[NSURL URLWithString:[self RemoveNull:[ClosetIconArray objectAtIndex:index-indexPath.row]]];
    cell.Closetname.text=[self RemoveNull:[ClosetNameArray objectAtIndex:index-indexPath.row]];
    cell.DeclineButton.hidden=YES;
    cell.AcceptButton.hidden=YES;
    cell.EditButton.hidden=YES;
    cell.DeclineButton.tag=indexPath.row;
    cell.AcceptButton.tag=indexPath.row;
    cell.EditButton.tag=indexPath.row;
    [cell.EditButton addTarget:self action:@selector(EditCloset:) forControlEvents:UIControlEventTouchUpInside];
    [cell.DeclineButton addTarget:self action:@selector(DeclineCloset:) forControlEvents:UIControlEventTouchUpInside];
    [cell.AcceptButton addTarget:self action:@selector(AcceptCloset:) forControlEvents:UIControlEventTouchUpInside];
    if ([[self RemoveNull:[ClosetStatusArray objectAtIndex:index-indexPath.row]] intValue]==1) {
        cell.EditButton.hidden=NO;
    }else if ([[self RemoveNull:[ClosetStatusArray objectAtIndex:index-indexPath.row]] intValue]==2) {
        cell.DeclineButton.hidden=NO;
        cell.AcceptButton.hidden=NO;
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index=ClosetNameArray.count-1;
    UIStoryboard *Story=self.storyboard;
    ClosetDetailController *CenterView=[Story instantiateViewControllerWithIdentifier:@"detail"];
    CenterView.ClosetId=[self RemoveNull:[ClosetIdArray objectAtIndex:index-indexPath.row]];
    CenterView.Closetname=[self RemoveNull:[ClosetNameArray objectAtIndex:index-indexPath.row]];
    [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}

-(void)EditCloset:(id)sender
{
     NSInteger index=ClosetNameArray.count-1;
    ClosetCollection *cell=(ClosetCollection *)[_Collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    UIStoryboard *Story=self.storyboard;
    CreateNewClosetController *CenterView=[Story instantiateViewControllerWithIdentifier:@"createnew"];
    CenterView.EditCloset=YES;
    CenterView.EditedPrivacy=[ClosetPrivacyArray objectAtIndex:index-[sender tag]];
    CenterView.EditedClosetname=[ClosetNameArray objectAtIndex:index-[sender tag]];
    CenterView.ClosetID=[ClosetIdArray objectAtIndex:index-[sender tag]];
    CenterView.EditedImage=cell.closetimage.image;
    [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}
-(void)DeclineCloset:(id)sender
{
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/response_to_closet.php?fb_id=5648512&closet_id=14095725767212&status=0
     NSInteger index=ClosetNameArray.count-1;
    [[GCHud Hud] showNormalHUD:@"Canceling"];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    //[Param setObject:[Utility UserID] forKey:@"fb_id"];
    [Param setObject:[OwnerIDArray objectAtIndex:index-[sender tag]] forKey:@"fb_id"];
    [Param setObject:[Utility UserID] forKey:@"current_id"];
    [Param setObject:[ClosetIdArray objectAtIndex:index-[sender tag]] forKey:@"closet_id"];
     [Param setObject:@"decline" forKey:@"status"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/response_to_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [self getMyallClosets];
        }
        [[GCHud Hud] showSuccessHUD];
    } Error:^{
        [[GCHud Hud] showErrorHUD];
    }];
}
-(void)AcceptCloset:(id)sender
{
     NSInteger index=ClosetNameArray.count-1;
    [[GCHud Hud] showNormalHUD:@"Accepting"];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[OwnerIDArray objectAtIndex:index-[sender tag]] forKey:@"fb_id"];
    [Param setObject:[Utility UserID] forKey:@"current_id"];
    [Param setObject:[ClosetIdArray objectAtIndex:index-[sender tag]] forKey:@"closet_id"];
    [Param setObject:@"accept" forKey:@"status"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/response_to_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [ClosetStatusArray replaceObjectAtIndex:index-[sender tag] withObject:@"0"];
            [_Collection reloadData];
        }
        [[GCHud Hud] showSuccessHUD];
        
    } Error:^{
       [[GCHud Hud] showErrorHUD];
    }];
}

-(NSString *)RemoveNull:(NSString *)value
{
    if ([value isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return value;
}
@end
