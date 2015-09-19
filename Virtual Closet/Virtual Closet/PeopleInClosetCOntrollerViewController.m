//
//  PeopleInClosetCOntrollerViewController.m
//  Virtual Closet
//
//  Created by Apple on 19/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "PeopleInClosetCOntrollerViewController.h"
#import "JoinCell.h"
#import "UILabel+NavigationTitle.h"
#import "GCCacheSaver.h"
#import "UserDetailViewController.h"
#import "ProfileViewController.h"
#import "SlidingViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "UIImageView+Network.h"
#import "Flurry.h"
@interface PeopleInClosetCOntrollerViewController ()

@end

@implementation PeopleInClosetCOntrollerViewController

- (void)viewDidLoad {
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
    
     [UILabel SetTitle:[NSString stringWithFormat:@"People in %@",_Closetname] OnView:self];
    
   
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)GetAllPeoples
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableDictionary *param=[NSMutableDictionary new];
    [param setObject:_ClosetID forKey:@"closet_id"];
    NSString *clost=_ClosetID;
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/closet_members.php?" WithParameter:param Success:^(NSMutableDictionary *Dic) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            _ClosetID=clost;
            [GCCacheSaver saveDictionary:Dic withName:@"People" inRelativePath:[NSString stringWithFormat:@"List_%@_%@",[Utility UserID],_ClosetID]];
            JoinidArray=[[Dic objectForKey:@"join_id"] mutableCopy];
            JoinNameArray=[[Dic objectForKey:@"join_name"] mutableCopy];
            JoinStatusArray=[[Dic objectForKey:@"status"] mutableCopy];
            JoinImageArray=[[Dic objectForKey:@"profile_pic"] mutableCopy];
            [_Table reloadData];
        }
         if ([[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
             [GCCacheSaver saveDictionary:Dic withName:@"People" inRelativePath:[NSString stringWithFormat:@"List_%@_%@",[Utility UserID],_ClosetID]];
             [JoinidArray removeAllObjects];
             [JoinNameArray removeAllObjects];
             [JoinStatusArray removeAllObjects];
             [JoinImageArray removeAllObjects];
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
-(void)viewWillAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetAllPeoples) name:@"refreshapi" object:nil];
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"People" inRelativePath:[NSString stringWithFormat:@"List_%@_%@",[Utility UserID],_ClosetID]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            JoinidArray=[[Dic objectForKey:@"join_id"] mutableCopy];
            JoinNameArray=[[Dic objectForKey:@"join_name"] mutableCopy];
            JoinStatusArray=[[Dic objectForKey:@"status"] mutableCopy];
            JoinImageArray=[[Dic objectForKey:@"profile_pic"] mutableCopy];
            [_Table reloadData];
        }
    }
    [self GetAllPeoples];
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshapi" object:nil];
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return JoinidArray.count;
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
    
    static NSString *CellIdentifier = @"joincells";
    JoinCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.iconimage.layer.cornerRadius=cell.iconimage.frame.size.height/2;
    cell.iconimage.layer.masksToBounds=YES;
    cell.iconimage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.iconimage.layer.borderWidth=1;
    cell.Textlable.text=[JoinNameArray objectAtIndex:indexPath.row];
   // cell.iconimage.placeholderImage=[UIImage imageNamed:@"defaultimage"];
    //cell.iconimage.imageURL=[NSURL URLWithString:[JoinImageArray objectAtIndex:indexPath.row]];
    [cell.iconimage loadImageFromURL:[NSURL URLWithString:[JoinImageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
    cell.Indicatorimage.hidden=YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *Story=self.storyboard;
    UserDetailViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"user"];
    [Utility SaveOtherUserid:AvoidNull([JoinidArray objectAtIndex:indexPath.row])];
    [Utility SaveOtherUserImage:AvoidNull([JoinImageArray objectAtIndex:indexPath.row])];
    [Utility SaveOtherUserName:AvoidNull([JoinNameArray objectAtIndex:indexPath.row])];
    if ([[JoinidArray objectAtIndex:indexPath.row] isEqualToString:[Utility UserID]]) {
        ownprofile=YES;
        settingsclick=NO;
    }
    else{
        ownprofile=NO;
    }
   [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}

@end
