//
//  MyLikesController.m
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "MyLikesController.h"
#import "likeCell.h"
#import "UILabel+NavigationTitle.h"
#import "GCHud.h"
#import "GCCacheSaver.h"
#import "SlidingViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "UIImageView+Network.h"
#import "DBShared.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "Flurry.h"
@implementation MyLikesController
- (void)viewDidLoad {
    [Flurry logEvent:@"MYLIKE_VIEW"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    self.Table.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
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
    
     [UILabel SetTitle:@"My Likes" OnView:self];
   
    
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
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMylikes) name:@"refreshapi" object:nil];
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"likes" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            iTemArray=[[Dic objectForKey:@"items"] mutableCopy];
            iTemIDArray=[[Dic objectForKey:@"ids"] mutableCopy];
            [_Table reloadData];
        }
        if ([[Dic objectForKey:@"message"] isEqualToString:@"empty"] ||[[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"likes" inRelativePath:@"List"];
            [iTemArray removeAllObjects];
            [iTemIDArray removeAllObjects];
            [_Table reloadData];
        }
    }
    [self getMylikes];
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshapi" object:nil];
    [super viewWillDisappear:animated];
}

-(void)getMylikes
{
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/get_liked_items.php?liker_fb_id=5465445
   // [[GCHud Hud] showNormalHUD:@"Fetching List"];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[Utility UserID] forKey:@"liker_fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_liked_items.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
             [GCCacheSaver saveDictionary:Dic withName:@"likes" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            iTemArray=[[Dic objectForKey:@"items"] mutableCopy];
             iTemIDArray=[[Dic objectForKey:@"ids"] mutableCopy];
            [_Table reloadData];
        }
        if ([[Dic objectForKey:@"message"] isEqualToString:@"empty"] ||[[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"likes" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            [iTemArray removeAllObjects];
             [iTemIDArray removeAllObjects];
            [_Table reloadData];
        }
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      //  [[GCHud Hud] showSuccessHUD];
    } Error:^{
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
       // [[GCHud Hud] showErrorHUD];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return iTemArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"likecell";
    likeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    NSInteger index=iTemArray.count-1;
    cell.TimeLable.text=[Utility TimeAgo:[self getDateFromUnixFormat:[[iTemArray objectAtIndex:index-indexPath.row] objectForKey:@"createdAt"]]];
   // cell.closetTitle.textColor=[UIColor colorFromHexString:@"#25AAA0"];
    cell.closetimage.layer.borderColor=[UIColor darkGrayColor].CGColor;
    cell.closetimage.layer.borderWidth=1;
   // cell.closetimage.placeholderImage=[UIImage imageNamed:@"defaultimage"];
   // cell.closetimage.imageURL=[NSURL URLWithString:[[iTemArray objectAtIndex:index-indexPath.row] objectForKey:@"image_name"]];
    if ([[[iTemArray objectAtIndex:index-indexPath.row] objectForKey:@"image_name"] isKindOfClass:[NSData class]]) {
        cell.closetimage.image=[UIImage imageWithData:[[iTemArray objectAtIndex:index-indexPath.row] objectForKey:@"image_name"]];
    }
    else{
    [cell.closetimage loadImageFromURL:[NSURL URLWithString:[[iTemArray objectAtIndex:index-indexPath.row] objectForKey:@"image_name"]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
    }
    cell.closetTitle.text=[[iTemArray objectAtIndex:indexPath.row] objectForKey:@"description"];
    cell.ColorLable.text=[NSString stringWithFormat:@"Color: %@",[[iTemArray objectAtIndex:index-indexPath.row] objectForKey:@"color"]];
    cell.SizeLable.text=[NSString stringWithFormat:@"Size: %@",[[iTemArray objectAtIndex:index-indexPath.row] objectForKey:@"size"]];
    cell.BrandLable.text=[NSString stringWithFormat:@"Brand: %@",[[iTemArray objectAtIndex:index-indexPath.row] objectForKey:@"brand"]];
    cell.DeleteBut.tag=indexPath.row;
     cell.requestbut.tag=indexPath.row;
     cell.CheckStatus.tag=indexPath.row;
    [cell.DeleteBut addTarget:self action:@selector(DeletePress:) forControlEvents:UIControlEventTouchUpInside];
    [cell.requestbut addTarget:self action:@selector(RequestPress:) forControlEvents:UIControlEventTouchUpInside];
    [cell.CheckStatus addTarget:self action:@selector(StatusPress:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.PhotoEnlarge.tag=indexPath.row;
    [cell.PhotoEnlarge addTarget:self action:@selector(IconPress:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.CheckStatus.hidden=YES;
    return cell;
}
-(void)IconPress:(UIButton *)sender
{
    // Create image info
    likeCell *cell=(likeCell *)[_Table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = cell.closetimage.image;
    imageInfo.referenceRect = cell.closetimage.frame;
    // imageInfo.referenceView = cell.closetimage.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}
-(void)DeletePress:(UIButton *)sender
{
    NSInteger index=iTemArray.count-1;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[Utility UserID] forKey:@"fb_id"];
    [Param setObject:[iTemIDArray objectAtIndex:index-[sender tag]] forKey:@"item_id"];
    //www.platinuminfosys.org/parse/parse.com-php-library-master/unlike.php?fb_id=10152357374552681&item_id=12312
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/unlike.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
           
            //[self getMylikes];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } Error:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [[DBShared shared] SaveLikeAtindex:[[iTemArray objectAtIndex:index-[sender tag]] objectForKey:@"closet_id"] Condition:NO];
    [[DBShared shared] DeleteLikeAtIndex:index-[sender tag]];
     [iTemArray removeObjectAtIndex:sender.tag];
    [_Table reloadData];

}
-(void)RequestPress:(UIButton *)sender
{
     NSInteger index=iTemArray.count-1;
    [[RequestWindow Request] setDelegate:self];
    [[RequestWindow Request] Initialize];
    [[NSUserDefaults standardUserDefaults] setObject:[iTemIDArray objectAtIndex:index-[sender tag]] forKey:@"itemid"];
    [[NSUserDefaults standardUserDefaults] setObject:[[iTemArray objectAtIndex:index-[sender tag]] objectForKey:@"closet_owner_fb_id"] forKey:@"ownerid"];
    [[NSUserDefaults standardUserDefaults] setObject:[[iTemArray objectAtIndex:index-[sender tag]] objectForKey:@"closet_id"] forKey:@"closetrid"];
}
-(void)StatusPress:(UIButton *)sender
{
    
}

-(void)viewclosed
{
    
}

-(void)SendPressed:(NSString *)eventdate Pick:(NSString *)pickDate Return:(NSString *)returndate
{
    
}

- (NSDate *) getDateFromUnixFormat:(NSString *)unixFormat
{
    if ([unixFormat isKindOfClass:[NSNull class]]) {
        return [NSDate date];
    }
    return  [NSDate dateWithTimeIntervalSince1970:[unixFormat intValue]];
}

@end
