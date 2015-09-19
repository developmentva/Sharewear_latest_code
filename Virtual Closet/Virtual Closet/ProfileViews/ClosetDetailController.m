//
//  ClosetDetailController.m
//  Virtual Closet
//
//  Created by Apple on 19/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "ClosetDetailController.h"
#import "ItemCollectionCell.h"
//#import "singleClosetDetailController.h"
#import "ProfileViewController.h"
#import "SlidingViewController.h"
#import "UILabel+NavigationTitle.h"
#import "GCHud.h"
#import "GCCacheSaver.h"
#import "GSScrollerViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "UIImageView+Network.h"
#import "ItemViewerViewController.h"
#import "Flurry.h"
extern NSString *ItemI;
extern NSString *OwnerI;
extern NSString *ClosetI;
@implementation ClosetDetailController
@synthesize ClosetId;
- (void)viewDidLoad {
    [Flurry logEvent:@"CLOSESET_DETAIL_VIEW"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    UIImage *image = [UIImage imageNamed:@"list_icon1"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OpenProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=LeftButton;
    
    image = [UIImage imageNamed:@"back_btn"];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(BackPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *RightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=RightButton;
    
    
    [UILabel SetTitle:_Closetname OnView:self];
   
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)getMyallClosets
{
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:ClosetId forKey:@"closet_id"];
    NSString *Clost=ClosetId;
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_items.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        ClosetId=Clost;
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
              [GCCacheSaver saveDictionary:Dic withName:@"detail" inRelativePath:ClosetId];
            ItemsIDArray=[[Dic objectForKey:@"item_ids"] mutableCopy];
            ItemsBrandArray=[[Dic objectForKey:@"brand_arr"] mutableCopy];
            ItemsColorArray=[[Dic objectForKey:@"color_arr"] mutableCopy];
            ItemsDecriptionArray=[[Dic objectForKey:@"description_arr"] mutableCopy];
            ItemsimageArray=[[Dic objectForKey:@"image_name_arr"] mutableCopy];
            ItemsSizeArray=[[Dic objectForKey:@"size_arr"] mutableCopy];
            ItemsStatusArray=[[Dic objectForKey:@"status_arr"] mutableCopy];
            ItemsTypeArray=[[Dic objectForKey:@"type_arr"] mutableCopy];
            ItemsOwnerIDArray=[[Dic objectForKey:@"owner_id"] mutableCopy];
            
            [_Collection reloadData];
        }
        if ([[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"detail" inRelativePath:ClosetId];
            [ItemsIDArray removeAllObjects];
            [ItemsBrandArray removeAllObjects];
            [ItemsColorArray removeAllObjects];
            [ItemsDecriptionArray removeAllObjects];
            [ItemsimageArray removeAllObjects];
            [ItemsSizeArray removeAllObjects];
             ItemsStatusArray=[Dic objectForKey:@"status_arr"];
            [ItemsTypeArray removeAllObjects];
            ItemsOwnerIDArray=nil;
            [_Collection reloadData];

        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } Error:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
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
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"detail" inRelativePath:ClosetId];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            
            ItemsIDArray=[[Dic objectForKey:@"item_ids"] mutableCopy];
            ItemsBrandArray=[[Dic objectForKey:@"brand_arr"] mutableCopy];
            ItemsColorArray=[[Dic objectForKey:@"color_arr"] mutableCopy];
            ItemsDecriptionArray=[[Dic objectForKey:@"description_arr"] mutableCopy];
            ItemsimageArray=[[Dic objectForKey:@"image_name_arr"] mutableCopy];
            ItemsSizeArray=[[Dic objectForKey:@"size_arr"] mutableCopy];
            ItemsStatusArray=[[Dic objectForKey:@"status_arr"] mutableCopy];
            ItemsTypeArray=[[Dic objectForKey:@"type_arr"] mutableCopy];
            ItemsOwnerIDArray=[[Dic objectForKey:@"owner_id"] mutableCopy];
            [_Collection reloadData];
        }
    }
    [self getMyallClosets];
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ItemsIDArray.count;
}

-(NSData*) dataFrom64String : (NSString*) stringEncodedWithBase64
{
    NSData *dataFromBase64 = [[NSData alloc] initWithBase64Encoding:stringEncodedWithBase64];
    return dataFromBase64;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"itemcell";
    
    ItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.closetimage.layer.borderWidth=1;
    cell.closetimage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //cell.closetimage.placeholderImage=[UIImage imageNamed:@"defaultimage"];
    //cell.closetimage.imageURL=[NSURL URLWithString:[ItemsimageArray objectAtIndex:indexPath.row]];
     if ([[ItemsimageArray objectAtIndex:indexPath.row] isKindOfClass:[NSData class]]) {
         cell.closetimage.image=[UIImage imageWithData:[ItemsimageArray objectAtIndex:indexPath.row]];
     }
     else{
    [cell.closetimage loadImageFromURL:[NSURL URLWithString:[ItemsimageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
     }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *Story=self.storyboard;
    ItemViewerViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"itemv"];
    CenterView.ItemsIDArray=ItemsIDArray ;
    CenterView.OwnerID=ItemsOwnerIDArray;
    CenterView.ClosetID=ClosetId;
    CenterView.Closetname=_Closetname;
    CenterView.ItemsSizeArray=ItemsSizeArray ;
    CenterView.ItemsColorArray=ItemsColorArray ;
    CenterView.ItemsBrandArray=ItemsBrandArray ;
    CenterView.ItemsStatusArray=ItemsStatusArray ;
    CenterView.ItemsDecriptionArray=ItemsDecriptionArray ;
    CenterView.ItemsimageArray=ItemsimageArray;
    CenterView.index=indexPath.row;
//    ProfileViewController *LeftView=[Story instantiateViewControllerWithIdentifier:@"profile"];
//    [SlidingViewController PushFromViewController:self CenterviewController:CenterView LeftviewController:LeftView Block:^(ICSDrawerController *drawer) {
//        CenterView.drawer=drawer;
//        ItemI=[ItemsIDArray objectAtIndex:indexPath.row];
//        OwnerI=ItemsOwnerIDArray;
//        ClosetI=ClosetId;
//        CenterView.name=_Closetname;
//        CenterView.Size=[ItemsSizeArray objectAtIndex:indexPath.row];
//        CenterView.color=[ItemsColorArray objectAtIndex:indexPath.row];
//        CenterView.brand=[ItemsBrandArray objectAtIndex:indexPath.row];
//        CenterView.status=[ItemsStatusArray objectAtIndex:indexPath.row];
//        CenterView.note=[ItemsDecriptionArray objectAtIndex:indexPath.row];
//        CenterView.ImageUrl=[ItemsimageArray objectAtIndex:indexPath.row];
//    }];
    [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
    
    
//     UIStoryboard *Story=self.storyboard;
//     NSMutableArray *Controllers=[NSMutableArray new];
//    // NSMutableArray *ItemNameAr=[NSMutableArray new];
//     for (int i=0; i<ItemsimageArray.count; i++) {
//     singleClosetDetailController *CenterView=[Story instantiateViewControllerWithIdentifier:@"single"];
//         CenterView.ItemIds=[ItemsIDArray objectAtIndex:indexPath.row];
//         CenterView.OwnerIDs=ItemsOwnerIDArray;
//         CenterView.ClosetIDs=ClosetId;
//         CenterView.name=_Closetname;
//         CenterView.Size=[ItemsSizeArray objectAtIndex:indexPath.row];
//         CenterView.color=[ItemsColorArray objectAtIndex:indexPath.row];
//         CenterView.brand=[ItemsBrandArray objectAtIndex:indexPath.row];
//         CenterView.status=[ItemsStatusArray objectAtIndex:indexPath.row];
//         CenterView.note=[ItemsDecriptionArray objectAtIndex:indexPath.row];
//         CenterView.ImageUrl=[ItemsimageArray objectAtIndex:indexPath.row];
//         [Controllers addObject:CenterView];
//     }
//     GSScrollerViewController *scroller=[Story instantiateViewControllerWithIdentifier:@"scroller"];
//    scroller.ClosetId=ClosetId;
//    scroller.ViewcontrollerArray=Controllers;
//    [SlidingViewController PushFromViewController3:self CenterviewController:scroller];
////     ProfileViewController *LeftView=[Story instantiateViewControllerWithIdentifier:@"profile"];
////     [SlidingViewController PushFromViewController:self CenterviewController:scroller LeftviewController:LeftView Block:^(ICSDrawerController *drawer) {
////    // scroller.drawer=drawer;
////     }];
    
}
@end
