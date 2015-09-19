//
//  CreateClosetController.m
//  Virtual Closet
//
//  Created by Apple on 17/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "CreateClosetController.h"
#import "CreateClosetcell.h"
#import "UIColor+Code.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel+NavigationTitle.h"
#import "GCCacheSaver.h"
#import "AppDelegate.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "ProfileViewController.h"
#import "UserDetailViewController.h"
#import "SlidingViewController.h"
#import "Utility.h"
#import "MyClosetViewController.h"
#import "ItemViewerViewController.h"
#import "UIImageView+AFNetworkingJSAdditions.h"
#import "UIScrollView+PullToRefreshCoreText.h"
#import "JoinClosetController.h"
#import "UIViewController+JDSideMenu.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImageView+Network.h"
#import "DBShared.h"
#import "Flurry.h"
@implementation CreateClosetController
- (void)viewDidLoad {
    [Flurry logEvent:@"CREATE CLOSE SET VIEW"];
    alt =[[UIAlertView alloc]init];
    self.Table.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    UIImage *image = [UIImage imageNamed:@"list_icon1"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OpenProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=LeftButton;
    __weak typeof(self) weakSelf = self;
    [_Table addPullToRefreshWithPullText:@"Pull To Refresh" pullTextColor:[UIColor blackColor] pullTextFont:DefaultTextFont refreshingText:@"Refreshing" refreshingTextColor:[UIColor blueColor] refreshingTextFont:DefaultTextFont action:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [weakSelf loadItems];
    }];
    
    [UILabel SetTitle:(self.History)?@"History":@"ShareWear" OnView:self];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshapi" object:nil];
    [super viewWillDisappear:animated];
}
- (void)loadItems {
   // __weak typeof(UIScrollView *) weakScrollView = _Table;
    __weak typeof(self) weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf GetAllFeeds];
        //[weakScrollView finishLoading];
    });
}

-(void)GetAllFeeds
{
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    __weak typeof(UIScrollView *) weakScrollView = _Table;
    NSMutableDictionary *param=[NSMutableDictionary new];
    [param setObject:[Utility UserID] forKey:@"fb_id"];
    if (self.History) {
        [param setObject:@"history" forKey:@"type"];
    }
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_f.php" WithParameter:param Success:^(NSMutableDictionary *Dic) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [weakScrollView finishLoading];
            [GCCacheSaver saveDictionary:Dic withName:(self.History)?@"History":@"feeds" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            
            TimeStampArray=[[Dic objectForKey:@"time_stamp"] mutableCopy];
            NotificationArray=[[Dic objectForKey:@"notification"] mutableCopy];
            OwnerIdArray=[[Dic objectForKey:@"owner"] mutableCopy];
            ItemsArray=[[Dic objectForKey:@"item_detail"] mutableCopy];
            TypeArray=[[Dic objectForKey:@"type"] mutableCopy];
            LikeArray=[[Dic objectForKey:@"liked"] mutableCopy];
            UserDetailArray=[[Dic objectForKey:@"user_detail"] mutableCopy];
            FirstpartArray=[[Dic objectForKey:@"first_part"] mutableCopy];
            LastPartArray=[[Dic objectForKey:@"last_part"] mutableCopy];
            JoinStatusArray=[[Dic objectForKey:@"join_status"] mutableCopy];
            inappropraterStatusArray=[[Dic objectForKey:@"inappropriate"]mutableCopy ];
            [_Table reloadData];
        }
        if ([[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
            [GCCacheSaver saveDictionary:Dic withName:(self.History)?@"History":@"feeds" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            [TimeStampArray removeAllObjects];
            [NotificationArray removeAllObjects];
            [OwnerIdArray removeAllObjects];
            [ItemsArray removeAllObjects];
            [TypeArray removeAllObjects];
            [LikeArray removeAllObjects];
            [inappropraterStatusArray removeAllObjects];
            [UserDetailArray removeAllObjects];
            [FirstpartArray removeAllObjects];
            [LastPartArray removeAllObjects];
            [JoinStatusArray removeAllObjects];
            [_Table reloadData];
        }
    } Error:^{
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
    // [(AppDelegate *)[UIApplication sharedApplication].delegate PushToHome];
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetAllFeeds) name:@"refreshapi" object:nil];
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:(self.History)?@"History":@"feeds" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        TimeStampArray=[[Dic objectForKey:@"time_stamp"] mutableCopy];
        NotificationArray=[[Dic objectForKey:@"notification"] mutableCopy];
        OwnerIdArray=[[Dic objectForKey:@"owner"] mutableCopy];
        ItemsArray=[[Dic objectForKey:@"item_detail"] mutableCopy];
        TypeArray=[[Dic objectForKey:@"type"] mutableCopy];
        LikeArray=[[Dic objectForKey:@"liked"] mutableCopy];
        UserDetailArray=[[Dic objectForKey:@"user_detail"] mutableCopy];
        FirstpartArray=[[Dic objectForKey:@"first_part"] mutableCopy];
        LastPartArray=[[Dic objectForKey:@"last_part"] mutableCopy];
        JoinStatusArray=[[Dic objectForKey:@"join_status"] mutableCopy];
        inappropraterStatusArray=[[Dic objectForKey:@"inappropriate"]mutableCopy ];
        if (inappropraterStatusArray.count==0)
        {
            inappropraterStatusArray1 =[[NSMutableArray alloc]init];
            NSLog(@"nil");
            for (int i =0; i<ItemsArray.count; i++)
            {
                NSString *str1=[[ItemsArray valueForKey:@"status"]objectAtIndex:i];
                [inappropraterStatusArray1 addObject:str1];
            }
        }
        [_Table reloadData];
    }
    if (!self.Notrefresh) {
        [self GetAllFeeds];
    }
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return TimeStampArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"createcell";
    CreateClosetcell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSInteger index=TimeStampArray.count-1;
    cell.TimeLable.text=[Utility TimeAgo:[self getDateFromUnixFormat:[TimeStampArray objectAtIndex:index-indexPath.row]]];
    [cell.inappropratorButton addTarget:self action:@selector(inappropratorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     cell.inappropratorButton.selected =!cell.inappropratorButton.selected;
    cell.inappropratorButton.tag=indexPath.row;
    if (self.History) {
        cell.closetTitle.text=[NotificationArray objectAtIndex:index-indexPath.row];
        CGSize maximumLabelSize = CGSizeMake(194,9999);
        CGSize expectedLabelSize = [cell.closetTitle.text sizeWithFont:cell.closetTitle.font
                                                     constrainedToSize:maximumLabelSize
                                                         lineBreakMode:cell.closetTitle.lineBreakMode];
        CGRect newFrame = cell.closetTitle.frame;
        newFrame.size.height = expectedLabelSize.height;
        cell.closetTitle.frame = newFrame;
    }
    else{
        NSInteger type=0;
        if ([[TypeArray objectAtIndex:index-indexPath.row] isEqualToString:@"item"]) {
            type=1;
        }
        else if ([[TypeArray objectAtIndex:index-indexPath.row] isEqualToString:@"closet"]) {
            type=2;
        }
        else if ([[TypeArray objectAtIndex:index-indexPath.row] isEqualToString:@"join"]) {
            type=3;
        }
        [self Adjustclickabletext:cell.F1But b1value:[FirstpartArray objectAtIndex:index-indexPath.row] EndButton:cell.F2But b2value:[LastPartArray objectAtIndex:index-indexPath.row] Onlable:cell.closetTitle lvalue:[NotificationArray objectAtIndex:index-indexPath.row] type:type];
        cell.F1But.tag=indexPath.row;
        [cell.F1But addTarget:self action:@selector(FirstButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.F2But.tag=indexPath.row;
        [cell.F2But addTarget:self action:@selector(SecondButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.closetimage.image=[UIImage imageNamed:@"defaultimage"];
    if ([[[ItemsArray objectAtIndex:index-indexPath.row] objectForKey:@"image_name"] isKindOfClass:[NSData class]]) {
        cell.closetimage.image=[UIImage imageWithData:[[ItemsArray objectAtIndex:index-indexPath.row] objectForKey:@"image_name"]];
    }
    else{
        [cell.closetimage loadImageFromURL:[NSURL URLWithString:[[ItemsArray objectAtIndex:index-indexPath.row] objectForKey:@"image_name"]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
    }
    cell.closetimage.layer.borderColor=[UIColor darkGrayColor].CGColor;
    cell.closetimage.layer.borderWidth=1;
    cell.requestbut.tag=indexPath.row;
    [cell.requestbut addTarget:self action:@selector(RequestPress:) forControlEvents:UIControlEventTouchUpInside];
    cell.LikeBut.tag=indexPath.row;
    cell.IconBut.tag=indexPath.row;
    [cell.IconBut addTarget:self action:@selector(IconPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.LikeBut addTarget:self action:@selector(LikePress:) forControlEvents:UIControlEventTouchUpInside];
    cell.LikeBut.hidden=NO;
     cell.requestbut.hidden=NO;
    cell.inappropratorButton.hidden=NO;
    if ([[LikeArray objectAtIndex:index-indexPath.row] isEqualToString:@"1"]) {
        cell.LikeBut.selected=YES;
    }
    else if ([[LikeArray objectAtIndex:index-indexPath.row] isEqualToString:@"0"]) {
        cell.LikeBut.selected=NO;
    }
    else if ([[LikeArray objectAtIndex:index-indexPath.row] isEqualToString:@"2"]) {
        cell.LikeBut.hidden=YES;
    }
    if ([[OwnerIdArray objectAtIndex:index-indexPath.row] isEqualToString:[Utility UserID]]) {
        cell.LikeBut.hidden=YES;
    }
    if (self.History) {
        cell.LikeBut.hidden=YES;
        cell.requestbut.hidden=YES;
        if ([[OwnerIdArray objectAtIndex:index-indexPath.row] isEqualToString:[Utility UserID]]) {
        cell.inappropratorButton.hidden=YES;
        }
    }
    if (![[TypeArray objectAtIndex:index-indexPath.row] isEqualToString:@"item"]||[[OwnerIdArray objectAtIndex:index-indexPath.row] isEqualToString:[Utility UserID]])
    {
        cell.requestbut.hidden=YES;
        cell.inappropratorButton.hidden=YES;
    }
    return cell;
}
-(void)FirstButtonPressed:(UIButton *)but
{
    NSInteger index=TimeStampArray.count-1;
    if ([[TypeArray objectAtIndex:index-but.tag] isEqualToString:@"item"]) {
        [self ItemPressed:index-[but tag]];
    }
    else if ([[TypeArray objectAtIndex:index-but.tag] isEqualToString:@"join"]) {
        UIStoryboard *Story=self.storyboard;
        UserDetailViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"user"];
        [Utility SaveOtherUserid:AvoidNull([OwnerIdArray objectAtIndex:index-[but tag]])];
        [Utility SaveOtherUserImage:AvoidNull([OwnerIdArray objectAtIndex:index-[but tag]])];
        [Utility SaveOtherUserName:AvoidNull([[UserDetailArray objectAtIndex:index-[but tag]] objectForKey:@"username"])];
        ownprofile=NO;
        CenterView.backvisible=YES;
        [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
    }
    else
    {
        if ([[JoinStatusArray objectAtIndex:index-but.tag] isEqualToString:@"1"]) {
            [self MyClosets];
        }else{
            [self JoinCloset];
        }
    }
}

-(void)JoinCloset
{
    UIStoryboard *Story=self.storyboard;
    JoinClosetController *CenterView=[Story instantiateViewControllerWithIdentifier:@"Join"];
    [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}
-(void)SecondButtonPressed:(UIButton *)but
{
    NSInteger index=TimeStampArray.count-1;
    if ([[TypeArray objectAtIndex:index-but.tag] isEqualToString:@"item"]) {
        if ([[JoinStatusArray objectAtIndex:index-but.tag] isEqualToString:@"1"]) {
            [self MyClosets];
        }else{
            [self JoinCloset];
        }
    }
    else
    {
        UIStoryboard *Story=self.storyboard;
        UserDetailViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"user"];
        [Utility SaveOtherUserid:AvoidNull([OwnerIdArray objectAtIndex:index-[but tag]])];
        [Utility SaveOtherUserImage:AvoidNull([OwnerIdArray objectAtIndex:index-[but tag]])];
        [Utility SaveOtherUserName:AvoidNull([[UserDetailArray objectAtIndex:index-[but tag]] objectForKey:@"username"])];
        if ([[OwnerIdArray objectAtIndex:index-[but tag]] isEqualToString:[Utility UserID]]) {
            ownprofile=YES;
            settingsclick=NO;
        }
        else{
            ownprofile=NO;
        }
        CenterView.backvisible=YES;
        [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
    }
}

-(void)Adjustclickabletext:(UIButton *)button1 b1value:(NSString *)v1 EndButton:(UIButton*)Button2 b2value:(NSString *)v2 Onlable:(UILabel *)string lvalue:(NSString *)l1 type:(NSInteger)ty
{
    CGSize stringsize = [v1 sizeWithFont:[UIFont systemFontOfSize:17]];
    [button1 setFrame:CGRectMake(button1.frame.origin.x,button1.frame.origin.y,stringsize.width, stringsize.height)];
    [button1 setTitle:v1 forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor colorFromHexString:@"#25AAA0"] forState:UIControlStateNormal];
    stringsize = [v2 sizeWithFont:[UIFont systemFontOfSize:17]];
    [Button2 setTitleColor:[UIColor colorFromHexString:@"#25AAA0"] forState:UIControlStateNormal];
    [Button2 setTitle:v2 forState:UIControlStateNormal];
    NSMutableString *mu = [NSMutableString stringWithString:l1];
    for (int i=0; i< v1.length+5; i++) {
        [mu insertString:@" " atIndex:0];
    }
    l1 = [v1 stringByAppendingString:[NSString stringWithFormat:@" %@",l1]];
    
    CGSize maximumLabelSize = CGSizeMake(194,9999);
    CGSize expectedLabelSize = [l1 sizeWithFont:string.font
                              constrainedToSize:maximumLabelSize
                                  lineBreakMode:string.lineBreakMode];
    //adjust the label the the new height.
    CGRect newFrame = string.frame;
    newFrame.size.height = expectedLabelSize.height;
    string.frame = newFrame;
    string.text=l1;
    if (string.lineBreakMode) {
        
    }
    
    NSString *t_st;
    
    switch (ty) {
        case 1:
            t_st=@"to";
            break;
        case 2:
            t_st=@"by";
            break;
        case 3:
            t_st=@"join";
            break;
            
        default:
            break;
    }
    
    @try {
        CGSize matchSize = [t_st sizeWithFont:string.font];
        NSRange matchRange =[l1 rangeOfString:t_st options:NSCaseInsensitiveSearch];
        NSRange measureRange = NSMakeRange(0, matchRange.location);
        NSString *measureText = [l1 substringWithRange:measureRange];
        CGSize measureSize = [measureText sizeWithFont:string.font forWidth:194 lineBreakMode:string.lineBreakMode];
        CGRect matchFrame = CGRectMake(newFrame.origin.x+measureSize.width , newFrame.origin.y+newFrame.size.height-Button2.frame.size.height,stringsize.width, matchSize.height);
        [Button2 setFrame:matchFrame] ;
        if (Button2.frame.origin.x+Button2.frame.size.width>200) {
            [Button2 setFrame:CGRectMake(newFrame.origin.x,newFrame.origin.y+newFrame.size.height,stringsize.width, stringsize.height)];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
 
    
  
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)IconPress:(UIButton *)sender
{
    // Create image info
    CreateClosetcell *cell=(CreateClosetcell *)[_Table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
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
-(void)RequestPress:(UIButton *)sender
{
    NSInteger index=TimeStampArray.count-1;
    [[RequestWindow Request] setDelegate:self];
    [[RequestWindow Request] Initialize];
    [[NSUserDefaults standardUserDefaults] setObject:AvoidNull([[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"id"]) forKey:@"itemid"];
    [[NSUserDefaults standardUserDefaults] setObject:AvoidNull([OwnerIdArray objectAtIndex:index-[sender tag]]) forKey:@"ownerid"];
    [[NSUserDefaults standardUserDefaults] setObject:AvoidNull([[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"closet_id"]) forKey:@"closetrid"];
}

-(void)LikePress:(UIButton *)sender
{
    NSInteger index=TimeStampArray.count-1;
    //    if ([[LikeArray objectAtIndex:index-[sender tag]] isEqualToString:@"1"]) {
    //        return;
    //    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    CreateClosetcell *cell=(CreateClosetcell *)[_Table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    [UIView animateWithDuration:0.3/1.5 animations:^{
        cell.LikeBut.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.5, 2.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            cell.LikeBut.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0,1.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                cell.LikeBut.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    if (sender.selected) {
        [LikeArray replaceObjectAtIndex:index-[sender tag] withObject:@"0"];
        sender.selected=NO;
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:[Utility UserID] forKey:@"fb_id"];
        [Param setObject:[[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"id"] forKey:@"item_id"];
        //www.platinuminfosys.org/parse/parse.com-php-library-master/unlike.php?fb_id=10152357374552681&item_id=12312
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/unlike.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                [self GetAllFeeds];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } Error:^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }
    else{
        [LikeArray replaceObjectAtIndex:index-[sender tag] withObject:@"1"];
        sender.selected=YES;
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:[Utility UserID] forKey:@"liker_fb_id"];
        [Param setObject:[[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"id"] forKey:@"item_id"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/add_liked_items.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                [self GetAllFeeds];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } Error:^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
        NSMutableDictionary *Params=[NSMutableDictionary new];
        [Params setObject:[[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"brand"] forKey:@"brand"];
        [Params setObject:[[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"closet_id"] forKey:@"closet_id"];
        [Params setObject:[OwnerIdArray objectAtIndex:index-[sender tag]] forKey:@"closet_owner_fb_id"];
        [Params setObject:[[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"color"] forKey:@"color"];
        [Params setObject:[self Unix] forKey:@"createdAt"];
        [Params setObject:[[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"desc"] forKey:@"description"];
        [Params setObject:[[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"image_name"] forKey:@"image_name"];
        [Params setObject:[[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"size"] forKey:@"size"];
        [Params setObject:[[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"status"] forKey:@"status"];
        [[DBShared shared] savemylikes:Params Itemid:[[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"id"]];
        [[DBShared shared] SaveLikeAtindex:[[ItemsArray objectAtIndex:index-[sender tag]] objectForKey:@"closet_id"] Condition:YES];
    }
}

- (void)inappropratorButtonAction: (UIButton *)sender{
    
    NSInteger index=TimeStampArray.count-1;
    CreateClosetcell *cell=(CreateClosetcell *)[_Table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
   cell.inappropratorButton.selected =!cell.inappropratorButton.selected;
    if (!cell.inappropratorButton.selected)
    {
       // alt =[[UIAlertView alloc]init];
    alt.frame=CGRectMake(108, cell.frame.origin.y+cell.frame.size.height, 194, 55);
        alt.delegate=self;
    UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 194, 55)];
        img.image =[UIImage imageNamed:@"alert.png"];
        [alt addSubview:img];
    btn =[[UIButton alloc]initWithFrame:CGRectMake(22, 22, 145, 19)];
        btn.tag =sender.tag;
        NSLog(@"cell tag =%ld",(long)sender.tag);
        if (inappropraterStatusArray.count==0)
        {
            [btn addTarget:self action:@selector(ChangeAlert:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"markgrey"] forState:UIControlStateNormal];
            [alt addSubview:btn];
            str =@"Mark as inappropriate?";
        }
        else
        {
        if ([[NSString stringWithFormat:@"%@",[inappropraterStatusArray objectAtIndex:index-sender.tag]]isEqualToString:@"0"]) {
            str =@"Mark as inappropriate?";
            [btn addTarget:self action:@selector(ChangeAlert:) forControlEvents:UIControlEventTouchUpInside];
            [btn setUserInteractionEnabled:YES];
            [btn setImage:[UIImage imageNamed:@"markgrey"] forState:UIControlStateNormal];
            [alt addSubview:btn];
        }
        else if([[NSString stringWithFormat:@"%@",[inappropraterStatusArray objectAtIndex:index-sender.tag]]isEqualToString:@"1"]){
             str =@"You already mark this post as inappropriate";
            [btn setUserInteractionEnabled:NO];
            [btn setImage:[UIImage imageNamed:@"mark"] forState:UIControlStateNormal];
            [alt addSubview:btn];
        }
        }
        
    [self.Table addSubview:alt];
    }
    else
    {
        [alt removeFromSuperview];
    }
   }
-(void)ChangeAlert:(UIButton*)sender
{
    if ([str isEqualToString:@"You already mark this post as inappropriate"]) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag=sender.tag+5000;
        [alert show];
    }
    else
    {
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=sender.tag+5000;
    [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag>=5000) {
        if (buttonIndex) {
            [alt removeFromSuperview];
            long senderValue=alertView.tag-5000;
            NSInteger index=TimeStampArray.count-1;
            [btn setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            NSMutableDictionary *Param=[NSMutableDictionary new];
            [Param setObject:[Utility UserID] forKey:@"by"];
            if ([[TypeArray objectAtIndex:index-senderValue]isEqualToString:@"item"]) {
                [Param setObject:@"item"forKey:@"type"];
                [Param setObject:[[ItemsArray objectAtIndex:index-senderValue] objectForKey:@"id"] forKey:@"id"];
            }
            else{
                [Param setObject:@"closet" forKey:@"type"];
                [Param setObject:[[ItemsArray objectAtIndex:index-senderValue] objectForKey:@"closet_id"] forKey:@"id"];
            }
            
            
            [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/add_inappropriate.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
                if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                     [btn setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
                    [self GetAllFeeds];
                }
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            } Error:^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }];

        }
        else
        {
            [alt removeFromSuperview];
        }
    }
}
-(NSString *)Unix
{
    NSDate *date=[NSDate date];
    int startTime = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%i",startTime];
}
-(void)viewclosed
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"itemid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ownerid"];
   // [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"closetrid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)SendPressed:(NSString *)eventdate Pick:(NSString *)pickDate Return:(NSString *)returndate
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"itemid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ownerid"];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"closetrid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *) getDateFromUnixFormat:(NSString *)unixFormat{
    if ([unixFormat isKindOfClass:[NSNull class]]) {
        return [NSDate date];
    }
    return  [NSDate dateWithTimeIntervalSince1970:[unixFormat intValue]];
}

//- (void)handleNotification:(NSNotification *)notification
//{
//     NSInteger index=TimeStampArray.count-1;
//    UIButton *But=[[notification userInfo] valueForKey:@"but"];
//    NSString *Value=[NotificationArray objectAtIndex:index-[But tag]];
//    Value=[Value stringByReplacingOccurrencesOfString:@"@" withString:@""];
//    Value=[Value stringByReplacingOccurrencesOfString:@"#" withString:@""];
//    Value=[Value stringByReplacingOccurrencesOfString:@"_" withString:@" "];
//    NSArray *SPiltString;
//    BOOL isItemAdded=NO;
//    if ([[TypeArray objectAtIndex:index-But.tag] isEqualToString:@"item"]) {
//        SPiltString=[Value componentsSeparatedByString:@"has"];
//        isItemAdded=YES;
//    }
//    else{
//         SPiltString=[Value componentsSeparatedByString:@"created"];
//    }
//    if ([self isContain:But.currentTitle InArray:[NSArray arrayWithObject:[self RemoveSpaces:[SPiltString objectAtIndex:0]]]]) {
//        if (isItemAdded) {
//            NSLog(@"item");
//            [self ItemPressed:index-[But tag]];
//        }
//        else{
//            NSLog(@"closet");
//            [self MyClosets];
//        }
//    }
//    else{
//        if (isItemAdded) {
//            NSLog(@"closet");
//            [self MyClosets];
//        }
//        else{
//            NSLog(@"user");
//
//            UIStoryboard *Story=self.storyboard;
//            UserDetailViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"user"];
//            [Utility SaveOtherUserid:AvoidNull([OwnerIdArray objectAtIndex:index-[But tag]])];
//            [Utility SaveOtherUserImage:AvoidNull([OwnerIdArray objectAtIndex:index-[But tag]])];
//            [Utility SaveOtherUserName:AvoidNull([[UserDetailArray objectAtIndex:index-[But tag]] objectForKey:@"username"])];
//            if ([[OwnerIdArray objectAtIndex:index-[But tag]] isEqualToString:[Utility UserID]]) {
//                ownprofile=YES;
//                settingsclick=NO;
//            }
//            else{
//                ownprofile=NO;
//            }
//            [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
//        }
//    }
//}

-(void)ItemPressed:(int)index
{
    //    UIStoryboard *Story=self.storyboard;
    //    singleClosetDetailController *CenterView=[Story instantiateViewControllerWithIdentifier:@"single"];
    //    ItemI=AvoidNull([[ItemsArray objectAtIndex:index] objectForKey:@"id"]);
    //    OwnerI=AvoidNull([OwnerIdArray objectAtIndex:index]);
    //    ClosetI=AvoidNull([[ItemsArray objectAtIndex:index] objectForKey:@"closet_id"]);
    //    CenterView.ItemIds=AvoidNull([[ItemsArray objectAtIndex:index] objectForKey:@"id"]);
    //    CenterView.OwnerIDs=AvoidNull([OwnerIdArray objectAtIndex:index]);
    //    CenterView.ClosetIDs=AvoidNull([[ItemsArray objectAtIndex:index] objectForKey:@"closet_id"]);
    //    CenterView.name=AvoidNull([[ItemsArray objectAtIndex:index] objectForKey:@"closet_detail"]);
    //    CenterView.Size=AvoidNull([[ItemsArray objectAtIndex:index] objectForKey:@"size"]);
    //    CenterView.color=AvoidNull([[ItemsArray objectAtIndex:index] objectForKey:@"color"]);
    //    CenterView.brand=AvoidNull([[ItemsArray objectAtIndex:index] objectForKey:@"brand"]);
    //    CenterView.status=AvoidNull([[ItemsArray objectAtIndex:index] objectForKey:@"status"]);
    //    CenterView.note=AvoidNull([[ItemsArray objectAtIndex:index] objectForKey:@"descrip"]);
    //    CenterView.ImageUrl=AvoidNull([[ItemsArray objectAtIndex:index] objectForKey:@"image_name"]);
    //    [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
    
    
    UIStoryboard *Story=self.storyboard;
    ItemViewerViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"itemv"];
    CenterView.ItemsIDArray=ItemsArray ;
    CenterView.OwnerID=[OwnerIdArray objectAtIndex:index];
    CenterView.ClosetID=[[ItemsArray objectAtIndex:index] objectForKey:@"closet_id"];
    CenterView.Closetname=[[ItemsArray objectAtIndex:index] objectForKey:@"closet_detail"];
    CenterView.index=index;
    CenterView.FromFeed=YES;
    [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}

-(void)MyClosets
{
    UIStoryboard *Story=self.storyboard;
    MyClosetViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"mycloset"];
    CenterView.Backvisible=YES;
    [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}

-(NSString *)RemoveSpaces:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(BOOL)isContain:(NSString *)title InArray:(NSArray *)arry
{
    if ([arry containsObject:[self RemoveSpaces:title]]) {
        return YES;
    }
    return NO;
}
@end
