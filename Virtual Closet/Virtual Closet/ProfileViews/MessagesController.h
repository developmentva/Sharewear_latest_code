//
//  MessagesController.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
@interface MessagesController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *UsernameArray;
    NSMutableArray *UserImageArray;
    NSMutableArray *UsermessageArray;
     NSMutableArray *UsermessageidArray;
     NSMutableArray *UserStatusArray;
    NSMutableArray *UserIdArray;
     NSMutableArray *ReadArray;
    NSString *myImage;
}
@property(nonatomic,strong)IBOutlet UITableView *Table;
@end
