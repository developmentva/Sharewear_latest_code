//
//  NotificationCOntroller.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
@interface NotificationCOntroller : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *ToggleView;
    __weak IBOutlet UIButton *ItemBut,*ClosetBut;
    __weak IBOutlet UIImageView *BaseImage;
    NSMutableArray *TimeStampArray;
    NSMutableArray *NotificationArray;
    NSMutableArray *ItemDetailArray;
    NSMutableArray *TypeArray;
    NSMutableArray *StatusArray;
    NSMutableArray *NotiIDArray;
     NSMutableArray *RequestedByIDArray;
    NSMutableArray *RequestedDetailIDArray;
     NSMutableArray *RowSelectedArray;
    
    
    NSMutableArray *SentNotiIDArray;
    NSMutableArray *SentNotiArray;
    NSMutableArray *SentItemArray;
    NSMutableArray *SentUIDArray;
    NSMutableArray *SentTimeStampArray;
    NSMutableArray *SentTypeArray;
    NSMutableArray *SentStatusArray;
    BOOL IsCloset;
    
    IBOutlet UISegmentedControl *segment;
}
@property(nonatomic,strong)IBOutlet UITableView *Table;
@end
