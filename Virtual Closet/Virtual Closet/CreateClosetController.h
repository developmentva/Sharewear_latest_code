//
//  CreateClosetController.h
//  Virtual Closet
//
//  Created by Apple on 17/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestWindow.h"
#import "ServerParsing.h"
#import "Macro.h"
#import "REFrostedViewController.h"
@interface CreateClosetController : UIViewController<UITableViewDataSource,UITableViewDelegate,RequestDelegate>
{
    NSMutableArray *TimeStampArray;
    NSMutableArray *NotificationArray;
    NSMutableArray *OwnerIdArray;
    NSMutableArray *ItemsArray;
    NSMutableArray *closetidArray;
    NSMutableArray *TypeArray;
    NSMutableArray *LikeArray;
    NSMutableArray *UserDetailArray;
    NSMutableArray *ClosetnameArray;
    NSMutableArray *FirstpartArray;
    NSMutableArray *LastPartArray;
    NSMutableArray *JoinStatusArray;
    NSMutableArray *inappropraterStatusArray;
    NSMutableArray *inappropraterStatusArray1;
    UIAlertView *alt;
    UIButton *btn ;
    NSString *str;
}
@property(nonatomic,strong)IBOutlet UITableView *Table;
@property BOOL History,Notrefresh;
@end
