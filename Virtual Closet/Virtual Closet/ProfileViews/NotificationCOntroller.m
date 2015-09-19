//
//  NotificationCOntroller.m
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "NotificationCOntroller.h"
#import "Notificationcell.h"
#import "UILabel+NavigationTitle.h"
#import "GCCacheSaver.h"
#import "JGProgressHUD.h"
#import "UIViewController+JDSideMenu.h"
#import "SlidingViewController.h"
#import "UIImageView+Network.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "UIColor+Code.h"
#import "Flurry.h"
@implementation NotificationCOntroller
- (void)viewDidLoad {
    [Flurry logEvent:@"NOTIFICATION_VIEW"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    self.Table.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    UIImage *image = [UIImage imageNamed:@"list_icon1"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OpenProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=LeftButton;
    segment.tintColor=[UIColor colorFromHexString:@"#25aaa0"];
//    image = [UIImage imageNamed:@"back_btn"];
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
//    [button setImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(BackPress:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *RightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem=RightButton;
     ItemBut.selected=YES;
    ToggleView.layer.cornerRadius=2;
    ToggleView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    ToggleView.layer.borderWidth=2;
    ToggleView.layer.masksToBounds=YES;
     [UILabel SetTitle:@"Notifications" OnView:self];
   RowSelectedArray =[NSMutableArray new];
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

-(IBAction)ToggledPress:(UIButton *)sender
{
    if ([sender tag]==0) {
        ItemBut.selected=YES;
        ClosetBut.selected=NO;
        IsCloset=NO;
    }
    else{
        ItemBut.selected=NO;
        ClosetBut.selected=YES;
        IsCloset=YES;
    }
    [_Table reloadData];
    [UIView animateWithDuration:.5 animations:^{
        BaseImage.center=sender.center;
    }completion:^(BOOL finished) {
    }];
}

-(void)GetClosetsNotification
{
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/closet_requests_list.php?fb_id=10152357374552681&status=1
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[Utility UserID] forKey:@"fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_notification.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        NSLog(@"closet %@",Dic);
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"Notification" inRelativePath:[NSString stringWithFormat:@"closet_%@",[Utility UserID]]];
            TimeStampArray=[[Dic objectForKey:@"time_stamp"] mutableCopy];
            NotificationArray=[[Dic objectForKey:@"notification"] mutableCopy];
            ItemDetailArray=[[Dic objectForKey:@"item_detail"] mutableCopy];
            StatusArray=[[Dic objectForKey:@"status"] mutableCopy];
             NotiIDArray=[[Dic objectForKey:@"notification_id"] mutableCopy];
            TypeArray=[[Dic objectForKey:@"type"] mutableCopy];
            RequestedByIDArray=[[Dic objectForKey:@"by"] mutableCopy];
            RequestedDetailIDArray=[[Dic objectForKey:@"request_detail"] mutableCopy];
            [RowSelectedArray removeAllObjects];
            for (int i=0; i<TimeStampArray.count; i++) {
                [RowSelectedArray addObject:@"NO"];
            }
        }
         if ([[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
             [GCCacheSaver saveDictionary:Dic withName:@"Notification" inRelativePath:[NSString stringWithFormat:@"closet_%@",[Utility UserID]]];
             [TimeStampArray removeAllObjects];
             [NotificationArray removeAllObjects];
             [ItemDetailArray removeAllObjects];
             [StatusArray removeAllObjects];
             [NotiIDArray removeAllObjects];
             [RequestedByIDArray removeAllObjects];
             [RequestedDetailIDArray removeAllObjects];
             [TypeArray removeAllObjects];
         }
         [_Table reloadData];
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } Error:^{
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}
-(void)GetSentClosetsNotification
{
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/closet_requests_list.php?fb_id=10152357374552681&status=1
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[Utility UserID] forKey:@"fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/sent_notification.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        NSLog(@"closet %@",Dic);
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"NotificationSent" inRelativePath:[NSString stringWithFormat:@"closet_%@",[Utility UserID]]];
            SentItemArray=[[Dic objectForKey:@"item_detail"] mutableCopy];
            SentNotiArray=[[Dic objectForKey:@"notification"] mutableCopy];
            SentNotiIDArray=[[Dic objectForKey:@"notification_id"] mutableCopy];
            SentStatusArray=[[Dic objectForKey:@"status"] mutableCopy];
            SentTimeStampArray=[[Dic objectForKey:@"time_stamp"] mutableCopy];
            SentTypeArray=[[Dic objectForKey:@"type"] mutableCopy];
            SentUIDArray=[[Dic objectForKey:@"uid"] mutableCopy];
        }
        if ([[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"NotificationSent" inRelativePath:[NSString stringWithFormat:@"closet_%@",[Utility UserID]]];
            [SentItemArray removeAllObjects];
            [SentNotiArray removeAllObjects];
            [SentNotiIDArray removeAllObjects];
            [SentStatusArray removeAllObjects];
            [SentTimeStampArray removeAllObjects];
            [SentTypeArray removeAllObjects];
            [SentUIDArray removeAllObjects];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } Error:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}
-(IBAction)SegmentSelection:(id)sender
{
    if (segment.selectedSegmentIndex==0) {
        [self GetClosetsNotification];
    }
    else{
        [self GetSentClosetsNotification];
    }
    [_Table reloadData];
}
//-(void)GetItemsNotification
//{
//    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/get_requests_list.php?item_of_fb_id=10152357374552681&status=1
//     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    NSMutableDictionary *Param=[NSMutableDictionary new];
//    [Param setObject:[Utility UserID] forKey:@"item_of_fb_id"];
//    [[ServerParsing server] RequestPostAction:@"http://www.platinuminfosys.org/parse/parse.com-php-library-master/get_requests_list.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
//         NSLog(@"Item %@",Dic);
//        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
//            [GCCacheSaver saveDictionary:Dic withName:@"Notification" inRelativePath:@"items"];
//            ItemRequestarray=[Dic objectForKey:@"results"];
//        }
//        [_Table reloadData];
//         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    } Error:^{
//         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    }];
//}


-(void)BackPress:(id)sender
{
    [SlidingViewController Dissmissfrom:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"Notification" inRelativePath:[NSString stringWithFormat:@"closet_%@",[Utility UserID]]];
    if (Dic) {
        TimeStampArray=[[Dic objectForKey:@"time_stamp"] mutableCopy];
        NotificationArray=[[Dic objectForKey:@"notification"] mutableCopy];
        ItemDetailArray=[[Dic objectForKey:@"item_detail"] mutableCopy];
        StatusArray=[[Dic objectForKey:@"status"] mutableCopy];
        NotiIDArray=[[Dic objectForKey:@"notification_id"] mutableCopy];
        TypeArray=[[Dic objectForKey:@"type"] mutableCopy];
        RequestedByIDArray=[[Dic objectForKey:@"by"] mutableCopy];
         RequestedDetailIDArray=[[Dic objectForKey:@"request_detail"] mutableCopy];
        for (int i=0; i<TimeStampArray.count; i++) {
            [RowSelectedArray addObject:@"NO"];
        }
        [_Table reloadData];
    }
    
    Dic=[GCCacheSaver getDictionaryWithName:@"NotificationSent" inRelativePath:[NSString stringWithFormat:@"closet_%@",[Utility UserID]]];
    if (Dic) {
        SentItemArray=[[Dic objectForKey:@"item_detail"] mutableCopy];
        SentNotiArray=[[Dic objectForKey:@"notification"] mutableCopy];
        SentNotiIDArray=[[Dic objectForKey:@"notification_id"] mutableCopy];
        SentStatusArray=[[Dic objectForKey:@"status"] mutableCopy];
        SentTimeStampArray=[[Dic objectForKey:@"time_stamp"] mutableCopy];
        SentTypeArray=[[Dic objectForKey:@"type"] mutableCopy];
        SentUIDArray=[[Dic objectForKey:@"uid"] mutableCopy];
    }
    [self GetClosetsNotification];
     [self GetSentClosetsNotification];
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (segment.selectedSegmentIndex==0)?TimeStampArray.count:SentTimeStampArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==0) {
        if ([[RowSelectedArray objectAtIndex:indexPath.row] isEqualToString:@"YES"]) {
            return 171;
        }
        return 113;
    }
    else{
        return 113;
    }
   
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JGProgressHUD *Hud=  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        [Hud showInView:self.view];
        //http://vibrantappz.com/live/sw/delete_notification.php?notification_id=67fRMjj51L
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:[NotiIDArray objectAtIndex:indexPath.row] forKey:@"notification_id"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/delete_notification.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            NSLog(@"closet %@",Dic);
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                 [self GetClosetsNotification];
            }
            [Hud dismiss];
            [_Table reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        } Error:^{
             [Hud dismiss];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"noticell";
    Notificationcell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (segment.selectedSegmentIndex==0) {
    cell.Friendimage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.Friendimage.layer.borderWidth=1;
    [cell.Friendimage loadImageFromURL:[NSURL URLWithString:[[ItemDetailArray objectAtIndex:indexPath.row] objectForKey:@"image_name"]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
    cell.Messagelable.text=[NotificationArray objectAtIndex:indexPath.row];
    cell.Messagelable.text=[cell.Messagelable.text stringByReplacingOccurrencesOfString:@"@" withString:@""];
    cell.Messagelable.text=[cell.Messagelable.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
    cell.Messagelable.text=[cell.Messagelable.text stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    cell.timelable.text=[Utility TimeAgo:[self getDateFromUnixFormat:[TimeStampArray objectAtIndex:indexPath.row]]];
    cell.AcceptBut.tag=indexPath.row;
    cell.DeclineBut.tag=indexPath.row;
    [cell.AcceptBut addTarget:self action:@selector(AcceptPress:) forControlEvents:UIControlEventTouchUpInside];
     [cell.DeclineBut addTarget:self action:@selector(DeclinePress:) forControlEvents:UIControlEventTouchUpInside];
    cell.PhotoEnlargeBut.tag=indexPath.row;
    [cell.PhotoEnlargeBut addTarget:self action:@selector(IconPress:) forControlEvents:UIControlEventTouchUpInside];
    
    if (![[StatusArray objectAtIndex:indexPath.row] isEqualToString:@"pending"]) {
        cell.AcceptBut.hidden=YES;
        cell.DeclineBut.hidden=YES;
    }
    cell.PickDate.hidden=YES;
    cell.DropDate.hidden=YES;
    cell.MessaageText.hidden=YES;
    
     if ([[RowSelectedArray objectAtIndex:indexPath.row] isEqualToString:@"YES"]) {
         cell.PickDate.hidden=NO;
         cell.DropDate.hidden=NO;
         cell.MessaageText.hidden=NO;
         NSDictionary *Detail=[RequestedDetailIDArray objectAtIndex:indexPath.row];
         cell.PickDate.text=[NSString stringWithFormat:@"Pickdate: %@",[Detail objectForKey:@"pickup_date                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               "]];
         cell.DropDate.text=[NSString stringWithFormat:@"Returndate: %@",[Detail objectForKey:@"return_date                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               "]];
         cell.MessaageText.text=[NSString stringWithFormat:@"Pickdate: %@",[Detail objectForKey:@"message"]];
     }
    }
    else{
        cell.PickDate.hidden=YES;
        cell.DropDate.hidden=YES;
        cell.MessaageText.hidden=YES;
        cell.AcceptBut.hidden=YES;
        cell.DeclineBut.hidden=YES;
        cell.Friendimage.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.Friendimage.layer.borderWidth=1;
        [cell.Friendimage loadImageFromURL:[NSURL URLWithString:[[SentItemArray objectAtIndex:indexPath.row] objectForKey:@"image_name"]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
        cell.Messagelable.text=[SentNotiArray objectAtIndex:indexPath.row];
        cell.Messagelable.text=[cell.Messagelable.text stringByReplacingOccurrencesOfString:@"@" withString:@""];
        cell.Messagelable.text=[cell.Messagelable.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
        cell.Messagelable.text=[cell.Messagelable.text stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        cell.timelable.text=[Utility TimeAgo:[self getDateFromUnixFormat:[SentTimeStampArray objectAtIndex:indexPath.row]]];
        cell.PhotoEnlargeBut.tag=indexPath.row;
        [cell.PhotoEnlargeBut addTarget:self action:@selector(IconPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==1) {
        return;
    }
    if ([[RowSelectedArray objectAtIndex:indexPath.row] isEqualToString:@"YES"]) {
        [RowSelectedArray replaceObjectAtIndex:indexPath.row withObject:@"NO"];
         [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        [RowSelectedArray replaceObjectAtIndex:indexPath.row withObject:@"YES"];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)IconPress:(UIButton *)sender
{
    // Create image info
    Notificationcell *cell=(Notificationcell *)[_Table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = cell.Friendimage.image;
    imageInfo.referenceRect = cell.Friendimage.frame;
    // imageInfo.referenceView = cell.closetimage.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}
-(void)AcceptPress:(id)sender
{
    JGProgressHUD *Hud=  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [Hud showInView:self.view];
    if ([[TypeArray objectAtIndex:[sender tag]] isEqualToString:@"closet"]) {
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:[RequestedByIDArray objectAtIndex:[sender tag]] forKey:@"fb_id"];
        [Param setObject:[[ItemDetailArray objectAtIndex:[sender tag]] objectForKey:@"closet_id"] forKey:@"closet_id"];
        [Param setObject:@"accept" forKey:@"status"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/response_to_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                [self GetClosetsNotification];
            }
            [Hud dismiss];
        } Error:^{
             [Hud dismiss];
        }];
    }
    else if ([[TypeArray objectAtIndex:[sender tag]] isEqualToString:@"closet_join"]) {
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:[RequestedByIDArray objectAtIndex:[sender tag]] forKey:@"fb_id"];
        [Param setObject:[Utility UserID] forKey:@"current_id"];
        [Param setObject:[[ItemDetailArray objectAtIndex:[sender tag]] objectForKey:@"closet_id"] forKey:@"closet_id"];
        [Param setObject:@"accept" forKey:@"status"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/response_to_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                [self GetClosetsNotification];
            }
            [Hud dismiss];
        } Error:^{
            [Hud dismiss];
        }];
    }
    else{
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:[Utility UserID] forKey:@"item_of_fb_id"];
        [Param setObject:[[ItemDetailArray objectAtIndex:[sender tag]] objectForKey:@"id"] forKey:@"item_req_id"];
        [Param setObject:@"accept" forKey:@"status"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/response_to_request.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                [self GetClosetsNotification];
            }
             [Hud dismiss];
        } Error:^{
             [Hud dismiss];
        }];
    }
}

-(void)DeclinePress:(id)sender
{
    JGProgressHUD *Hud=  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [Hud showInView:self.view];
    if ([[TypeArray objectAtIndex:[sender tag]] isEqualToString:@"closet"]) {
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[RequestedByIDArray objectAtIndex:[sender tag]] forKey:@"fb_id"];
    [Param setObject:[[ItemDetailArray objectAtIndex:[sender tag]] objectForKey:@"closet_id"] forKey:@"closet_id"];
    [Param setObject:@"decline" forKey:@"status"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/response_to_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [self GetClosetsNotification];
        }
         [Hud dismiss];
    } Error:^{
         [Hud dismiss];
    }];
    }
    else  if ([[TypeArray objectAtIndex:[sender tag]] isEqualToString:@"closet_join"]) {
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:[RequestedByIDArray objectAtIndex:[sender tag]] forKey:@"fb_id"];
        [Param setObject:[Utility UserID] forKey:@"current_id"];
        [Param setObject:[[ItemDetailArray objectAtIndex:[sender tag]] objectForKey:@"closet_id"] forKey:@"closet_id"];
        [Param setObject:@"decline" forKey:@"status"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/response_to_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                [self GetClosetsNotification];
            }
            [Hud dismiss];
        } Error:^{
            [Hud dismiss];
        }];
    }
    else{
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:[Utility UserID] forKey:@"item_of_fb_id"];
        [Param setObject:[[ItemDetailArray objectAtIndex:[sender tag]] objectForKey:@"id"] forKey:@"item_req_id"];
        [Param setObject:@"decline" forKey:@"status"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/response_to_request.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                [self GetClosetsNotification];
            }
             [Hud dismiss];
        } Error:^{
             [Hud dismiss];
        }];
    }
}


- (NSDate *) getDateFromUnixFormat:(NSString *)unixFormat
{
    if ([unixFormat isKindOfClass:[NSNull class]]) {
        return [NSDate date];
    }
    return  [NSDate dateWithTimeIntervalSince1970:[unixFormat intValue]];
}

@end
