 //
//  MessagesController.m
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "MessagesController.h"
#import "messagecell.h"
#import "UIColor+Code.h"
#import "UILabel+NavigationTitle.h"
#import "GCHud.h"
#import "ChatViewController.h"
#import "GCCacheSaver.h"
#import "SlidingViewController.h"
#import "UIScrollView+PullToRefreshCoreText.h"
#import "UIViewController+JDSideMenu.h"
#import "UIImageView+Network.h"
#import "Flurry.h"
@implementation MessagesController
- (void)viewDidLoad {
    [Flurry logEvent:@"MESSAGE_VIEW"];
    self.Table.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
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
    
    __weak typeof(self) weakSelf = self;
    [_Table addPullToRefreshWithPullText:@"Pull To Refresh" pullTextColor:[UIColor blackColor] pullTextFont:DefaultTextFont refreshingText:@"Messages" refreshingTextColor:[UIColor blueColor] refreshingTextFont:DefaultTextFont action:^{
        [weakSelf loadItems];
    }];
    
     [UILabel SetTitle:@"Messages" OnView:self];
   
   
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)loadItems {
    __weak typeof(UIScrollView *) weakScrollView = _Table;
    __weak typeof(self) weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf GetAllInboxmessages];
        [weakScrollView finishLoading];
    });
}
-(void)GetAllInboxmessages
{
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/inbox.php?fb_id=5461655654
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[Utility UserID] forKey:@"fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/inbox.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
             [GCCacheSaver saveDictionary:Dic withName:@"message" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            UserImageArray=[[Dic objectForKey:@"img_arr"] mutableCopy];
            UsermessageArray=[[Dic objectForKey:@"message_arr"] mutableCopy];
            UsernameArray=[[Dic objectForKey:@"username_arr"] mutableCopy];
             UsermessageidArray=[[Dic objectForKey:@"chat_id"] mutableCopy];
            UserStatusArray=[[Dic objectForKey:@"status"] mutableCopy];
            UserIdArray=[[Dic objectForKey:@"user_ids"] mutableCopy];
            ReadArray=[[Dic objectForKey:@"reader"] mutableCopy];
            myImage =[Dic  objectForKey:@"my_img"];
            [_Table reloadData];
           
        }
        if ([[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"message" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
            [UserImageArray removeAllObjects];
            [UsermessageArray removeAllObjects];
            [UsernameArray removeAllObjects];
            [UsermessageidArray removeAllObjects];
            [UserStatusArray removeAllObjects];
            [ReadArray removeAllObjects];
            [UserIdArray removeAllObjects];
            myImage =nil;
            [_Table reloadData];
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
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetAllInboxmessages) name:@"refreshapi" object:nil];
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"message" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            UserImageArray=[[Dic objectForKey:@"img_arr"] mutableCopy];
            UsermessageArray=[[Dic objectForKey:@"message_arr"] mutableCopy];
            UsernameArray=[[Dic objectForKey:@"username_arr"] mutableCopy];
            UsermessageidArray=[[Dic objectForKey:@"chat_id"] mutableCopy];
            UserStatusArray=[[Dic objectForKey:@"status"] mutableCopy];
            UserIdArray=[[Dic objectForKey:@"user_ids"] mutableCopy];
            myImage =[Dic  objectForKey:@"my_img"];
            
            [_Table reloadData];
        }
    }
    [self GetAllInboxmessages];
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
    return UserIdArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"mcell";
    messagecell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.Messagelable.textColor=[UIColor colorFromHexString:@"#25AAA0"];
    cell.Messagelable.text=[UsermessageArray objectAtIndex:indexPath.row];
    cell.Friendimage.layer.borderColor=[UIColor darkGrayColor].CGColor;
    cell.Friendimage.layer.borderWidth=1;
   // cell.Friendimage.placeholderImage=[UIImage imageNamed:@"defaultimage"];
  //  cell.Friendimage.imageURL=[NSURL URLWithString:[UserImageArray objectAtIndex:indexPath.row]];
    [cell.Friendimage loadImageFromURL:[NSURL URLWithString:[UserImageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
    if ([[ReadArray objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        cell.Statusimage.image=[UIImage imageNamed:@"offlline"];
    }
   // cell.timelable.text=[Utility TimeAgo:[self getDateFromUnixFormat:[TimeStampArray objectAtIndex:indexPath.row]]];

    cell.NameLable.text=[UsernameArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   // messagecell *cell=(messagecell *)[tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *Story=self.storyboard;
    ChatViewController *Chat=[Story instantiateViewControllerWithIdentifier:@"chat"];
    Chat.ChatId=[UsermessageidArray objectAtIndex:indexPath.row];
    Chat.MyImage =myImage;
    Chat.otherUser=[UserIdArray objectAtIndex:indexPath.row];
    Chat.OtherUserName=[UsernameArray objectAtIndex:indexPath.row];
    Chat.OtherUserimage=[UserImageArray objectAtIndex:indexPath.row];
    [SlidingViewController PushFromViewController3:self CenterviewController:Chat];
//    UINavigationController *navcenter=[[UINavigationController alloc]initWithRootViewController:Chat];
//    [self presentViewController:navcenter animated:YES completion:nil];
}

@end
