//
//  AddFriendsViewController.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "ServerParsing.h"
#import "NIDropDown.h"
@interface AddFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate,UIAlertViewDelegate>
{
    NIDropDown *dropDown;
    NSMutableArray *FBFriendsArray;
    NSMutableArray *SelectedFBFriends;
    NSMutableArray *TotalTickArray;
    NSMutableArray *ClosetnameArrray;
    NSMutableArray *ClosetIDArray;
    __weak IBOutlet UIButton *ClosedtView;
    __weak IBOutlet UIImageView *tick;
}
@property (strong, nonatomic) IBOutlet UIButton *AddFrndBtn;

@property(nonatomic,strong)IBOutlet UITableView *Table;
@property(nonatomic,strong)NSString *ClosetIDs;
@property(nonatomic,strong)NSString *ClosetName;
@property(nonatomic,strong)NSString *IDCloset;
@property BOOL fromcloset,Backhidden;
@end
