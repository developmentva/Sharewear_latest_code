//
//  ProfileViewController.h
//  Virtual Closet
//
//  Created by Apple on 17/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EGOImageView.h"
BOOL settingsclick;
@interface ProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *IconImageArray;
    NSMutableArray *titleArray;
    IBOutlet UILabel *UserName;
    IBOutlet UIImageView *ProfileImage;
}
@property(nonatomic,strong)IBOutlet UITableView *Table;
@end
