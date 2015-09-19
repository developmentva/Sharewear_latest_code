//
//  ChatViewController.h
//  Virtual Closet
//
//  Created by Apple on 08/10/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBubbleTableViewController.h"
#import "ServerParsing.h"
#import "Macro.h"
@interface ChatViewController : AMBubbleTableViewController
{
    NSMutableArray *CreatedAtArray;
    NSMutableArray *MessagesArray;
    NSMutableArray *OtheruserIDArray;
    NSMutableArray *MessageIDArray;
    BOOL NotOnView;
    
}
@property(nonatomic,strong)NSString *ChatId;
@property(nonatomic,strong)NSString *MyImage;
@property(nonatomic,strong)NSString *otherUser;
@property(nonatomic,strong)NSString *OtherUserName;
@property(nonatomic,strong)NSString *OtherUserimage;
@end
