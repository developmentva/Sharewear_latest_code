//
//  UserDetailViewController.h
//  Virtual Closet
//
//  Created by Apple on 19/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
//#import "EGOImageView.h"
@interface UserDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *OptionBase;
    __weak IBOutlet UIImageView *ButtonBase;
    __weak IBOutlet UIButton *Itembut,*SaveBut,*SettingBut;
    __weak IBOutlet UIImageView *ProfileImage;
    __weak IBOutlet UILabel *Username;
    __weak IBOutlet UILabel *FriendsCount;
    __weak IBOutlet UILabel *ClosetCount;
    __weak IBOutlet UIView *Container,*FriendBase;
    __weak IBOutlet UITableView *Table;
     __weak IBOutlet UITableView *HistoryTable;
    __weak IBOutlet UICollectionView *Collection;
    id PreviousBut;
    NSMutableArray *MyItemsArray;
    NSMutableArray *MyItemsIdArray;
    NSMutableArray *MyItemsColorArray;
    NSMutableArray *MyItemsSizeArray;
    NSMutableArray *MyItemsBrandArray;
    NSMutableArray *MyItemsStatusArray;
    NSMutableArray *MyItemsTypeArray;
    NSMutableArray *MyItemsDecripArray;
    NSMutableArray *MyItemsImageArray;
    NSMutableArray *ClosetnameArrray;
    NSMutableArray *ClosetIDArray;
    NSMutableArray *ClosetImageArray;
    
    NSMutableArray *TimeStampArray;
    NSMutableArray *NotificationArray;
    NSMutableArray *OwnerIdArray;
    NSMutableArray *ItemsArray;
    NSMutableArray *closetidArray;
    NSMutableArray *TypeArray;
    
    BOOL history;
}
@property BOOL OwnProfile,backvisible;
@property(nonatomic,strong)NSString *ImageUrl,*UserName;
@property(nonatomic,strong)NSString *UserID;
@end
