//
//  AddFriendsViewController.m
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "JoinCell.h"
#import "SIAlertView.h"
#import "GCFacebookSDK.h"
#import "GCHud.h"
#import "NIDropDown.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel+NavigationTitle.h"
#import "GCCacheSaver.h"
#import "UserDetailViewController.h"
#import "ProfileViewController.h"
#import "SlidingViewController.h"
#import "UIColor+Code.h"
#import "UIViewController+JDSideMenu.h"
#import "UIImageView+Network.h"
#import "Flurry.h"
extern BOOL ownprofile;
@implementation AddFriendsViewController
@synthesize ClosetIDs,ClosetName,IDCloset;
- (void)viewDidLoad {
    [Flurry logEvent:@"ADD FRIEND VIEW "];
    if ((int)[[UIScreen mainScreen] bounds].size.height == 480)
    {
        self.AddFrndBtn.frame =CGRectMake(30, 432, 261, 38);
        self.Table.frame =CGRectMake(0, 157, 320, 262);
    }
    self.Table.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    UIImage *image = [UIImage imageNamed:@"list_icon1"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OpenProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=LeftButton;
    
    if (!self.Backhidden) {
        image = [UIImage imageNamed:@"back_btn"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(BackPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *RightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem=RightButton;
    }
    SelectedFBFriends=[NSMutableArray new];
     TotalTickArray=[NSMutableArray new];
    [UILabel SetTitle:@"Add Friends" OnView:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"Friends" inRelativePath:@"List"];
//    if (Dic) {
//        
//    }
//    else{
   // [[GCHud Hud] showNormalHUD:@"Fetching Facebook Friends"];
   // }
     NSMutableDictionary *Frnds=[GCCacheSaver getDictionaryWithName:@"Friends" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Frnds) {
        FBFriendsArray=[[Frnds objectForKey:@"Friends"] mutableCopy];
        for (int i=0; i<FBFriendsArray.count; i++) {
            [TotalTickArray addObject:@"0"];
        }
        [_Table reloadData];
    }
    [GCFacebookSDK getUserFriendsCallBack:^(BOOL success, id result) {
        [GCCacheSaver saveDictionary:[NSMutableDictionary dictionaryWithObject:result forKey:@"Friends"] withName:@"Friends" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
        if (success) {
        FBFriendsArray=[result mutableCopy];
        for (int i=0; i<FBFriendsArray.count; i++) {
            [TotalTickArray addObject:@"0"];
        }
        [_Table reloadData];
        }
         [[GCHud Hud] showSuccessHUD];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"newitem" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            ClosetnameArrray=[[Dic objectForKey:@"closet_names"] mutableCopy];
            ClosetIDArray=[[Dic objectForKey:@"closet_id"] mutableCopy];
        }
    }
    [self GetAllClosets];
    if (_fromcloset) {
        ClosedtView.hidden=YES;
        tick.hidden=YES;
        CGRect Frame=_Table.frame;
        Frame.origin.y=100;
        Frame.size.height=self.view.frame.size.height;
        _Table.frame=Frame;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)GetAllClosets
{
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[Utility UserID] forKey:@"fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"newitem" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            ClosetnameArrray=[[Dic objectForKey:@"closet_names"] mutableCopy];
            ClosetIDArray=[[Dic objectForKey:@"closet_id"] mutableCopy];
        }
        
    } Error:^{
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
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return FBFriendsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"joincells";
    JoinCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *DIc=[FBFriendsArray objectAtIndex:indexPath.row];
    cell.Textlable.text=[DIc objectForKey:@"name"];
   // cell.iconimage.placeholderImage=[UIImage imageNamed:@"defaultimage"];
   // cell.iconimage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[DIc objectForKey:@"id"]]];
    [cell.iconimage loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[DIc objectForKey:@"id"]]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
    cell.Indicatorimage.tag=indexPath.row;
    [cell.Indicatorimage addTarget:self action:@selector(Selection:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.fromcloset) {
        cell.createmsg.hidden=YES;
        [cell.btnCheck setHidden:NO];
        [cell.btnCheck addTarget:self action:@selector(btnCheckAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCheck setTag:indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
         if ([[TotalTickArray objectAtIndex:indexPath.row] intValue]==0) {
             [cell.btnCheck setSelected:NO];
         }
         else{
             [cell.btnCheck setSelected:YES];
         }
        
    }
    else{
        [cell.btnCheck setHidden:YES];
        cell.createmsg.tag=indexPath.row;
        [cell.createmsg addTarget:self action:@selector(Createmessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
   
   
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JoinCell *listCell=(JoinCell *)[self.Table cellForRowAtIndexPath:indexPath];
     NSDictionary *FrndDic=[FBFriendsArray objectAtIndex:indexPath.row];
    if ([[TotalTickArray objectAtIndex:indexPath.row] containsString:[FrndDic objectForKey:@"id"]]) {
        [cell.contentView setBackgroundColor:[[UIColor colorFromHexString:@"#25AAA0"] colorWithAlphaComponent:.5]];
        [listCell.btnCheck setSelected:NO];
    }
    else{
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
         [listCell.btnCheck setSelected:YES];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    JoinCell *cell = (JoinCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if ([[TotalTickArray objectAtIndex:indexPath.row] intValue]==0) {
//        [TotalTickArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
//        [SelectedFBFriends addObject:[FBFriendsArray objectAtIndex:indexPath.row]];
//        //[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//        cell.Indicatorimage.hidden=NO;
//    cell.Indicatorimage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
//    [UIView animateWithDuration:0.3/1.5 animations:^{
//        cell.Indicatorimage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.3/2 animations:^{
//            cell.Indicatorimage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.3/2 animations:^{
//                cell.Indicatorimage.transform = CGAffineTransformIdentity;
//            }];
//        }];
//    }];
//    }else{
//        [TotalTickArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
//        [SelectedFBFriends removeObjectAtIndex:indexPath.row];
//        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//    }
    if (!self.fromcloset){
    if ([[TotalTickArray objectAtIndex:indexPath.row] intValue]==0) {
        NSDictionary *FrndDic=[FBFriendsArray objectAtIndex:indexPath.row];
        [TotalTickArray replaceObjectAtIndex:indexPath.row withObject:[FrndDic objectForKey:@"id"]];
        [SelectedFBFriends addObject:[NSString stringWithFormat:@"%li",(long)indexPath.row]];
        [_Table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
    }else{
        [TotalTickArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
        [SelectedFBFriends removeObject:[NSString stringWithFormat:@"%li",(long)indexPath.row]];
        [_Table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
}

- (void)btnCheckAction:(UIButton *)btn{
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:btn.tag inSection:0];
    JoinCell *cell=(JoinCell *)[self.Table cellForRowAtIndexPath:indexPath];
    
    if ([[TotalTickArray objectAtIndex:indexPath.row] intValue]==0) {
        NSDictionary *FrndDic=[FBFriendsArray objectAtIndex:indexPath.row];
        [TotalTickArray replaceObjectAtIndex:indexPath.row withObject:[FrndDic objectForKey:@"id"]];
        [SelectedFBFriends addObject:[NSString stringWithFormat:@"%li",(long)indexPath.row]];
        [_Table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [cell.btnCheck setSelected:YES];
        
    }else{
        [TotalTickArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
        [SelectedFBFriends removeObject:[NSString stringWithFormat:@"%li",(long)indexPath.row]];
        [_Table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [cell.btnCheck setSelected:NO];
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
                 NSDictionary *FrndDic=[FBFriendsArray objectAtIndex:[sender tag]];
                UserDetailViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"user"];
                CenterView.backvisible=YES;
                [Utility SaveOtherUserid:[FrndDic objectForKey:@"id"]];
                [Utility SaveOtherUserImage:[FrndDic objectForKey:@"id"]];
                [Utility SaveOtherUserName:[FrndDic objectForKey:@"name"]];
                 ownprofile=NO;
                [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
            }];
        }];
    }];
    
    
}


-(IBAction)AddFriends:(id)sender
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"X friends have been added"];
    [alertView addButtonWithTitle:@"Cancel"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Cancel Clicked");
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
}

-(IBAction)SavePressed:(id)sender
{
    if ([SelectedFBFriends count]==0) {
        return;
    }
    if (!ClosetIDs) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Select closet first"];
        [alertView addButtonWithTitle:@"OK"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"Cancel Clicked");
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        [alertView show];
        return;
    }
    [[GCHud Hud] showNormalHUD:@"Inviting"];
    for (int i=0; i<SelectedFBFriends.count; i++) {
        int p=[[SelectedFBFriends objectAtIndex:i] intValue];
        NSDictionary *FrndDic=[FBFriendsArray objectAtIndex:p];
        NSMutableDictionary *Dic=[NSMutableDictionary new];
        [Dic setObject:ClosetIDs forKey:@"closet_id"];
        [Dic setObject:ClosetName forKey:@"closet_name"];
        [Dic setObject:[Utility UserID] forKey:@"closet_owner"];
        [Dic setObject:[FrndDic objectForKey:@"id"] forKey:@"join_id"];
        [Dic setObject:[FrndDic objectForKey:@"name"] forKey:@"join_name"];
        
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/join_closet.php?" WithParameter:Dic Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                
            }
            if (i==[SelectedFBFriends count]-1) {
                [[GCHud Hud] showSuccessHUD];
                SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:[NSString stringWithFormat:@"%lu friends have been added",(unsigned long)SelectedFBFriends.count]];
                [alertView addButtonWithTitle:@"OK"
                                         type:SIAlertViewButtonTypeCancel
                                      handler:^(SIAlertView *alertView) {
                                          NSLog(@"Cancel Clicked");
                                      }];
                alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
                alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
                [alertView show];
                [TotalTickArray removeAllObjects];
                for (int i=0; i<FBFriendsArray.count; i++) {
                    [TotalTickArray addObject:@"0"];
                }
                [ClosedtView setTitle:@"  Closet" forState:UIControlStateNormal];
                [_Table reloadData];
                [SlidingViewController Dissmissfrom:self];
            }
            
        } Error:^{
            [[GCHud Hud] showErrorHUD];
        }];
    }
    
   
}

-(void)Createmessage:(UIButton *)but
{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Send Message"
                          message:nil
                          delegate:self
                          cancelButtonTitle: @"Send"
                          otherButtonTitles:@"Cancel", nil ];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* answerField = [alert textFieldAtIndex:0];
    answerField.keyboardType = UIKeyboardTypeDefault;
    answerField.placeholder = @"Message";
    answerField.tag=but.tag;
    [alert show];
    
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==alertView.cancelButtonIndex) {
        NSString *message = [[alertView textFieldAtIndex:0] text];
         NSDictionary *DIc=[FBFriendsArray objectAtIndex:alertView.tag];
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:message forKey:@"message"];
        [Param setObject:[Utility UserID] forKey:@"sender_fb_id"];
        [Param setObject:[DIc objectForKey:@"id"] forKey:@"reciever_fb_id"];
        NSString *TimeStamp=[self Unix];
        [Param setObject:TimeStamp forKey:@"time_stamp"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/add_messages.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                [GCCacheSaver Updatedatabase:nil WithItems:[NSArray arrayWithObjects:TimeStamp,message,[Utility UserID],[Dic objectForKey:@"message_id"], nil] Otheruser:[DIc objectForKey:@"id"]];
            }
        } Error:^{
        }];
    }
}
-(NSString *)Unix
{
    NSDate *date=[NSDate date];
    int startTime = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%i",startTime];
}
-(IBAction)SelectCloset:(id)sender
{
    [self.view endEditing:YES];
    if(dropDown == nil) {
        CGFloat f =  ((40*ClosetnameArrray.count)<200)?40*ClosetnameArrray.count:200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :ClosetnameArrray :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender AtIndex:(NSInteger)index {
    ClosetIDs=[ClosetIDArray objectAtIndex:index];
    ClosetName=[ClosetnameArrray objectAtIndex:index];
    [self rel];
}

-(void)rel{
    dropDown = nil;
}

@end
