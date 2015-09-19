//
//  JoinClosetController.m
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "JoinClosetController.h"
#import "JoinCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PeopleInClosetCOntrollerViewController.h"
#import "ProfileViewController.h"
#import "SlidingViewController.h"
#import "UILabel+NavigationTitle.h"
#import "GCHud.h"
#import "GCCacheSaver.h"
#import "UIColor+Code.h"
#import "UIImageView+Network.h"
#import "UIViewController+JDSideMenu.h"
#import "Flurry.h"
@implementation JoinClosetController

- (void)viewDidLoad {
    [Flurry logEvent:@"JOIN CLOSE SET VIEW"];
    self.Table.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
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
    
    [UILabel SetTitle:@"Join Closet" OnView:self];
    searchString=[NSMutableString new];
    SearchArray=[NSMutableArray new];
    TotalTickArray=[NSMutableArray new];
    SearchTotalTickArray=[NSMutableArray new];
    ClosetnameArray=[NSMutableArray new];
    ClosetIconArray=[NSMutableArray new];
    ClosetIDArray=[NSMutableArray new];
    FBIDArray=[NSMutableArray new];
    PrivacyType=[NSMutableArray new];
    ObjectIDArray=[NSMutableArray new];
    SatatusArray=[NSMutableArray new];
    UpdatedArray=[NSMutableArray new];
    CreatedAtArray=[NSMutableArray new];
    SelectedClosetArrray=[NSMutableArray new];
    
   
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetAllClosets) name:@"refreshapi" object:nil];
    [self FirstLaunch];
    [self GetAllClosets];
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshapi" object:nil];
    [super viewWillDisappear:animated];
}

-(void)FirstLaunch
{
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"Join" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
   // [self RemoveValuesifAny];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
         [self SaveAllValues:Dic Index:0];
        }
//        NSArray *AllArrayList=[Dic objectForKey:@"result"];
//        for (int i=0; i<AllArrayList.count; i++) {
//            [self SaveAllValues:AllArrayList Index:i];
//            [TotalTickArray addObject:@"0"];
//        }
        [_Table reloadData];
    }
}

-(void)RemoveValuesifAny
{
    [TotalTickArray removeAllObjects];
    [SearchTotalTickArray removeAllObjects];
    [ClosetnameArray removeAllObjects];
    [ClosetIconArray removeAllObjects];
    [ClosetIDArray removeAllObjects];
    [FBIDArray removeAllObjects];
    [PrivacyType removeAllObjects];
    [ObjectIDArray removeAllObjects];
    [SatatusArray removeAllObjects];
    [UpdatedArray removeAllObjects];
    [CreatedAtArray removeAllObjects];
    [SelectedClosetArrray removeAllObjects];
}

-(void)SaveAllValues:(NSMutableDictionary *)Value Index:(int)i
{
    
//    [ClosetIconArray addObject:[[Value objectAtIndex:i] objectForKey:@"closet_icon"]];
//    [ClosetIDArray addObject:[[Value objectAtIndex:i] objectForKey:@"closet_id"]];
//    [ClosetnameArray addObject:[[Value objectAtIndex:i] objectForKey:@"closet_name"]];
//    [FBIDArray addObject:[[Value objectAtIndex:i] objectForKey:@"fb_id"]];
//    [ObjectIDArray addObject:[[Value objectAtIndex:i] objectForKey:@"objectId"]];
//    [PrivacyType addObject:[[Value objectAtIndex:i] objectForKey:@"privacy_type"]];
//    [SatatusArray  addObject:[[Value objectAtIndex:i] objectForKey:@"status"]];
//    [UpdatedArray addObject:[[Value objectAtIndex:i] objectForKey:@"updatedAt"]];
//    [CreatedAtArray addObject:[[Value objectAtIndex:i] objectForKey:@"createdAt"]];
    
    ClosetIconArray =[[Value objectForKey:@"closet_icon"] mutableCopy];
    ClosetIDArray =[[Value objectForKey:@"closet_id"] mutableCopy];
    ClosetnameArray =[[Value objectForKey:@"closet_name"] mutableCopy];
    FBIDArray =[[Value objectForKey:@"fb_id"] mutableCopy];
    ObjectIDArray =[[Value  objectForKey:@"objectId"] mutableCopy];
    PrivacyType =[[Value objectForKey:@"privacy_type"] mutableCopy];
    SatatusArray  =[[Value objectForKey:@"status"] mutableCopy];
    UpdatedArray =[[Value objectForKey:@"updatedAt"] mutableCopy];
    CreatedAtArray =[[Value objectForKey:@"time"] mutableCopy];
    [TotalTickArray removeAllObjects];
    for (int i=0; i<CreatedAtArray.count; i++) {
        [TotalTickArray addObject:@"0"];
    }
}

-(void)GetAllClosets
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //http://vibrantappz.com/live/sw/search_closet.php?closet_name=12312&fb_id=541468969323058
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:@"all" forKey:@"closet_name"];
     [Param setObject:[Utility UserID] forKey:@"fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/search_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"Join" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            [self SaveAllValues:Dic Index:0];
            [_Table reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        if ([[Dic objectForKey:@"message"] isEqualToString:@"empty"]||[[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
              [GCCacheSaver saveDictionary:Dic withName:@"Join" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
             [self RemoveValuesifAny];
              [_Table reloadData];
         }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (isSearching)?SearchArray.count:ClosetIDArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[TotalTickArray objectAtIndex:indexPath.row] containsString:(isSearching)?[[SearchArray objectAtIndex:indexPath.row] objectForKey:@"id"]:[ClosetIDArray objectAtIndex:indexPath.row]]) {
        [cell.contentView setBackgroundColor:[[UIColor colorFromHexString:@"#25AAA0"] colorWithAlphaComponent:.5]];
    }
    else{
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"joincell";
    JoinCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
      cell.createmsg.hidden=YES;
  // cell.iconimage.placeholderImage=[UIImage imageNamed:@"defaultimage"];
    cell.iconimage.layer.cornerRadius=cell.iconimage.frame.size.height/2;
    cell.iconimage.layer.masksToBounds=YES;
    cell.iconimage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.iconimage.layer.borderWidth=1;
    if (isSearching) {
        //cell.iconimage.imageURL=[NSURL URLWithString:AvoidNull([[SearchArray objectAtIndex:indexPath.row] objectForKey:@"icon"])];
         if ([[[SearchArray objectAtIndex:indexPath.row] objectForKey:@"icon"] isKindOfClass:[NSData class]]) {
             cell.iconimage.image=[UIImage imageWithData:[[SearchArray objectAtIndex:indexPath.row] objectForKey:@"icon"]];
         }
         else{
        [cell.iconimage loadImageFromURL:[NSURL URLWithString:AvoidNull([[SearchArray objectAtIndex:indexPath.row] objectForKey:@"icon"])] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
         }
        cell.Textlable.text=AvoidNull([[SearchArray objectAtIndex:indexPath.row] objectForKey:@"Name"]) ;
    }
    else{
    //cell.iconimage.imageURL=[NSURL URLWithString:AvoidNull([ClosetIconArray objectAtIndex:indexPath.row])];
        if ([[ClosetIconArray objectAtIndex:indexPath.row] isKindOfClass:[NSData class]]) {
            cell.iconimage.image=[UIImage imageWithData:[ClosetIconArray objectAtIndex:indexPath.row]];
        }
        else{
        [cell.iconimage loadImageFromURL:[NSURL URLWithString:AvoidNull([ClosetIconArray objectAtIndex:indexPath.row])] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
        }
       cell.Textlable.text=AvoidNull([ClosetnameArray objectAtIndex:indexPath.row]);
        cell.Indicatorimage.tag=indexPath.row;
        [cell.Indicatorimage addTarget:self action:@selector(Selection:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isSearching) {
        if ([[TotalTickArray objectAtIndex:indexPath.row] intValue]==0) {
            [TotalTickArray replaceObjectAtIndex:indexPath.row withObject:[[SearchArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
            [SelectedClosetArrray addObject:[NSString stringWithFormat:@"%li",(long)indexPath.row]];
            [_Table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [TotalTickArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
            [SelectedClosetArrray removeObject:[NSString stringWithFormat:@"%li",(long)indexPath.row]];
            [_Table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else{
        if ([[TotalTickArray objectAtIndex:indexPath.row] intValue]==0) {
            [TotalTickArray replaceObjectAtIndex:indexPath.row withObject:[ClosetIDArray objectAtIndex:indexPath.row]];
            [SelectedClosetArrray addObject:[NSString stringWithFormat:@"%li",(long)indexPath.row]];
            [_Table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
        }else{
            [TotalTickArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
            [SelectedClosetArrray removeObject:[NSString stringWithFormat:@"%li",(long)indexPath.row]];
            [_Table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

-(void)Selection:(id)sender
{
    JoinCell *cell=(JoinCell *)[_Table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    cell.Indicatorimage.hidden=NO;
    cell.Indicatorimage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:0.3/1.5 animations:^{
        cell.Indicatorimage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            cell.Indicatorimage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                cell.Indicatorimage.transform = CGAffineTransformIdentity;
                UIStoryboard *Story=self.storyboard;
                PeopleInClosetCOntrollerViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"people"];
                CenterView.ClosetID=[ClosetIDArray objectAtIndex:[sender tag]];
                if (isSearching) {
                    CenterView.ClosetID=[[SearchArray objectAtIndex:[sender tag]] objectForKey:@"id"];
                }
                CenterView.Closetname=[ClosetnameArray objectAtIndex:[sender tag]];
                 [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
            }];
        }];
    }];
    
    
}



-(IBAction)SearchPressed:(id)sender
{
    [self SearchCloset:Searchtext.text];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    if ([textField.text length]>0) {
//        [self SearchCloset:textField.text];
//    }
//    textField.text=nil;
    return YES;
}
-(void)SearchCloset:(NSString *)searchtext
{
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/search_closet.php?closet_name=Big%20D
    [[GCHud Hud] showNormalHUD:@"Searching"];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:searchtext forKey:@"closet_name"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/search_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            //isSearching=YES;
            [self RemoveValuesifAny];
            [self SaveAllValues:Dic Index:0];
//            NSArray *AllArrayList=[Dic objectForKey:@"result"];
//            for (int i=0; i<AllArrayList.count; i++) {
//                [self SaveAllValues:AllArrayList Index:i];
//            }

            [_Table reloadData];
            [[GCHud Hud] showSuccessHUD];
        }
    } Error:^{
        [[GCHud Hud] showErrorHUD];
    }];
}


-(IBAction)JoinCloset:(id)sender
{
    if (SelectedClosetArrray.count==0) {
        return;
    }
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/join_closet.php?closet_id=14095725767212&closet_name=closet1&closet_owner=54654654654654&join_id=5648512&join_name=hhhhhh
    [[GCHud Hud] showNormalHUD:@"Joining"];
    for (int i=0; i<SelectedClosetArrray.count; i++) {
        NSMutableDictionary *Param=[NSMutableDictionary new];
        int p=[[SelectedClosetArrray objectAtIndex:i] intValue];
        [Param setObject:[ClosetnameArray objectAtIndex:p] forKey:@"closet_name"];
         [Param setObject:[ClosetIDArray objectAtIndex:p] forKey:@"closet_id"];
         [Param setObject:[FBIDArray objectAtIndex:p]  forKey:@"closet_owner"];
         [Param setObject:[Utility UserID] forKey:@"join_id"];
         [Param setObject:[Utility UserName] forKey:@"join_name"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/request_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                if ([SelectedClosetArrray count]-1==i) {
                    [[GCHud Hud] showSuccessHUD];
                    [SelectedClosetArrray removeAllObjects];
                }
            }
        } Error:^{
            [[GCHud Hud] showErrorHUD];
        }];

    }
     [self FirstLaunch];
    [self GetAllClosets];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ShareWear" message:[NSString stringWithFormat:@"You have requested %lu closets",(unsigned long)SelectedClosetArrray.count] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [SearchArray removeAllObjects];
    if([string isEqualToString:@""])
    {
        isSearching=YES;
        searchString = [searchString substringToIndex:[searchString length] - 1];
        NSArray *temp=[ClosetnameArray  filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"SELF beginswith[cd] %@", searchString]];
        if([temp count]>0)
        {
            for(id inn in temp)
            {
                NSInteger indexx =[ClosetnameArray indexOfObject:inn];
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                [dic setValue:inn forKey:@"Name"];
                [dic setValue:[ClosetIDArray objectAtIndex:indexx] forKey:@"id"];
                [dic setValue:[ClosetIconArray objectAtIndex:indexx] forKey:@"icon"];
                [SearchArray addObject:dic];
            }
        }
        [self.Table reloadData];
    }
    else
    {
        searchString=[searchString stringByAppendingString:string];
    }
    if(string.length>0)
    {
        isSearching=YES;
        NSArray *temp=[ClosetnameArray filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"SELF beginswith[cd] %@", searchString]];
        if([temp count]>0)
        {
            for(id inn in temp)
            {
                NSInteger indexx =[ClosetnameArray indexOfObject:inn];
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                [dic setValue:inn forKey:@"Name"];
                [dic setValue:[ClosetIDArray objectAtIndex:indexx] forKey:@"id"];
                [dic setValue:[ClosetIconArray objectAtIndex:indexx] forKey:@"icon"];
                [SearchArray addObject:dic];
            }
        }
        [self.Table reloadData];
    }
    if ([searchString length]==0)
    {
        isSearching=NO;
        [self.Table reloadData];
    }
    return  YES;
}


@end
