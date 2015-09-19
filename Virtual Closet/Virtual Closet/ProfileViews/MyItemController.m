//
//  MyItemController.m
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "MyItemController.h"
#import "ItemCollectionCell.h"
#import "UILabel+NavigationTitle.h"
#import "NewItemController.h"
#import "ProfileViewController.h"
#import "SlidingViewController.h"
#import "GCCacheSaver.h"
#import "GCHud.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "UIViewController+JDSideMenu.h"
#import "SlidingViewController.h"
#import "UIImageView+Network.h"
#import "Flurry.h"
@implementation MyItemController
- (void)viewDidLoad {
    [Flurry logEvent:@"MYITEM_VIEW"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    UIImage *image = [UIImage imageNamed:@"list_icon1"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OpenProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=LeftButton;
    
//    image = [UIImage imageNamed:@"back_btn"];
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
//    [button setImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(BackPress:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *RightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem=RightButton;
    
     [UILabel SetTitle:@"My Items" OnView:self];
   
    
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

-(void)BackPress:(id)sender
{
   [SlidingViewController Dissmissfrom:self];
}
-(void)viewWillAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyiTems) name:@"refreshapi" object:nil];
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"items" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            MyItemsIdArray=[[Dic objectForKey:@"item_ids"] mutableCopy];
            MyItemsArray=[[Dic objectForKey:@"name"] mutableCopy];
            MyItemsBrandArray=[[Dic objectForKey:@"brand_arr"] mutableCopy];
            MyItemsColorArray=[[Dic objectForKey:@"color_arr"] mutableCopy];
            MyItemsDecripArray=[[Dic objectForKey:@"description_arr"] mutableCopy];
            MyItemsImageArray=[[Dic objectForKey:@"image_name_arr"] mutableCopy];
            MyItemsSizeArray=[[Dic objectForKey:@"size_arr"] mutableCopy];
            MyItemsStatusArray=[[Dic objectForKey:@"status_arr"] mutableCopy];
            MyItemsTypeArray=[[Dic objectForKey:@"type_arr"] mutableCopy];
            MyClosetIDArray=[[Dic objectForKey:@"closet_ids"] mutableCopy];
            MyClosetNameArray=[[Dic objectForKey:@"closet_name"] mutableCopy];
            MyObjectIDArray=[[Dic objectForKey:@"objectId"] mutableCopy];
            [_collection reloadData];
        }
    }
    [self getMyiTems];
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshapi" object:nil];
    [super viewWillDisappear:animated];
}

-(void)getMyiTems
{
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/get_items_by_user.php?fb_id=1431659760454917
    ///[[GCHud Hud] showNormalHUD:@"Fetching List"];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[Utility UserID] forKey:@"fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_items_by_user.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"items" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            MyItemsIdArray=[[Dic objectForKey:@"item_ids"] mutableCopy];
            MyItemsArray=[[Dic objectForKey:@"name"] mutableCopy];
            MyItemsBrandArray=[[Dic objectForKey:@"brand_arr"] mutableCopy];
            MyItemsColorArray=[[Dic objectForKey:@"color_arr"] mutableCopy];
            MyItemsDecripArray=[[Dic objectForKey:@"description_arr"] mutableCopy];
            MyItemsImageArray=[[Dic objectForKey:@"image_name_arr"] mutableCopy];
            MyItemsSizeArray=[[Dic objectForKey:@"size_arr"] mutableCopy];
            MyItemsStatusArray=[[Dic objectForKey:@"status_arr"] mutableCopy];
            MyItemsTypeArray=[[Dic objectForKey:@"type_arr"] mutableCopy];
            MyClosetIDArray=[[Dic objectForKey:@"closet_ids"] mutableCopy];
            MyClosetNameArray=[[Dic objectForKey:@"closet_name"] mutableCopy];
             MyObjectIDArray=[[Dic objectForKey:@"objectId"] mutableCopy];
            [_collection reloadData];
        }
        else if ([[Dic objectForKey:@"message"] isEqualToString:@"No item"]) {
            [self NoItem:Dic];
        }
        else if ([[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
            [self NoItem:Dic];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } Error:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

-(void)NoItem:(NSMutableDictionary *)Dic
{
    [GCCacheSaver saveDictionary:Dic withName:@"items" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    [MyItemsIdArray removeAllObjects];
    [MyItemsBrandArray removeAllObjects];
    [MyItemsColorArray removeAllObjects];
    [MyItemsDecripArray removeAllObjects];
    [MyItemsImageArray removeAllObjects];
    [MyItemsSizeArray removeAllObjects];
    [MyItemsStatusArray removeAllObjects];
    [MyItemsTypeArray removeAllObjects];
    [_collection reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MyItemsIdArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"itemcell";
    ItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.closetimage.layer.borderColor=[UIColor darkGrayColor].CGColor;
    cell.closetimage.layer.borderWidth=1;
    //cell.closetimage.placeholderImage=[UIImage imageNamed:@"defaultimage"];
    //cell.closetimage.imageURL=[NSURL URLWithString:[MyItemsImageArray objectAtIndex:indexPath.row]];
     if ([[MyItemsImageArray objectAtIndex:indexPath.row] isKindOfClass:[NSData class]]) {
         cell.closetimage.image=[UIImage imageWithData:[MyItemsImageArray objectAtIndex:indexPath.row]];
     }
     else{
       [cell.closetimage loadImageFromURL:[NSURL URLWithString:[MyItemsImageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
     }
    cell.EditBut.tag=indexPath.row;
    [cell.EditBut addTarget:self action:@selector(EditCloset:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UIStoryboard *Story=self.storyboard;
//    GCSViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"gcs"];
//    ProfileViewController *LeftView=[Story instantiateViewControllerWithIdentifier:@"profile"];
//    [SlidingViewController PushFromViewController:self CenterviewController:CenterView LeftviewController:LeftView Block:^(ICSDrawerController *drawer) {
//        CenterView.drawer=drawer;
//   }];
    // Create image info
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

-(void)EditCloset:(id)sender
{
    ItemDetailDic=[NSMutableDictionary new];
    [ItemDetailDic setObject:[MyItemsIdArray objectAtIndex:[sender tag]] forKey:@"itemid"];
     [ItemDetailDic setObject:[MyItemsArray objectAtIndex:[sender tag]] forKey:@"name"];
    [ItemDetailDic setObject:[MyItemsBrandArray objectAtIndex:[sender tag]] forKey:@"brand"];
    [ItemDetailDic setObject:[MyItemsColorArray objectAtIndex:[sender tag]] forKey:@"color"];
    [ItemDetailDic setObject:[MyItemsDecripArray objectAtIndex:[sender tag]] forKey:@"decrip"];
    [ItemDetailDic setObject:[MyItemsImageArray objectAtIndex:[sender tag]] forKey:@"image"];
    [ItemDetailDic setObject:[MyItemsSizeArray objectAtIndex:[sender tag]] forKey:@"size"];
    [ItemDetailDic setObject:[MyItemsStatusArray objectAtIndex:[sender tag]] forKey:@"status"];
    [ItemDetailDic setObject:[MyItemsTypeArray objectAtIndex:[sender tag]] forKey:@"type"];
    [ItemDetailDic setObject:[MyClosetNameArray objectAtIndex:[sender tag]] forKey:@"closetname"];
    [ItemDetailDic setObject:[MyClosetIDArray objectAtIndex:[sender tag]] forKey:@"id"];
    [ItemDetailDic setObject:[MyObjectIDArray objectAtIndex:[sender tag]] forKey:@"objid"];
    EditingExisting=YES;
    UIStoryboard *Story=self.storyboard;
    NewItemController *CenterView=[Story instantiateViewControllerWithIdentifier:@"newitem"];
   [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}

-(IBAction)AddItem:(id)sender
{
    UIStoryboard *Story=self.storyboard;
    NewItemController *CenterView=[Story instantiateViewControllerWithIdentifier:@"newitem"];
   [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}

@end
