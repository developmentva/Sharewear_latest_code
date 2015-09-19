//
//  PeopleInClosetCOntrollerViewController.h
//  Virtual Closet
//
//  Created by Apple on 19/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
BOOL ownprofile,settingsclick;
@interface PeopleInClosetCOntrollerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *JoinidArray;
    NSMutableArray *JoinNameArray;
    NSMutableArray *JoinStatusArray;
    NSMutableArray *JoinImageArray;
}

@property(nonatomic,strong)IBOutlet UITableView *Table;
@property(nonatomic,strong)NSString *ClosetID;
@property(nonatomic,strong)NSString *Closetname;
@end
