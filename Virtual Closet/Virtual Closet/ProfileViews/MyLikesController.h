//
//  MyLikesController.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
#import "RequestWindow.h"
@interface MyLikesController : UIViewController<UITableViewDataSource,UITableViewDelegate,RequestDelegate>
{
    NSMutableArray *iTemArray;
    NSMutableArray *iTemIDArray;
}
@property(nonatomic,strong)IBOutlet UITableView *Table;
@end
