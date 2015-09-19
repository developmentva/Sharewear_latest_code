//
//  CreateClosetcell.h
//  Virtual Closet
//
//  Created by Apple on 17/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "IFTweetLabel.h"
//#import "EGOImageView.h"
@interface CreateClosetcell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *closetTitle;
@property (nonatomic, weak) IBOutlet UILabel *TimeLable;
@property (nonatomic, weak) IBOutlet UILabel *requestlable;
@property (nonatomic, weak) IBOutlet UIImageView *closetimage;
@property (nonatomic, weak) IBOutlet UIButton *requestbut;
@property (nonatomic, weak) IBOutlet UIButton *LikeBut;
@property (nonatomic, weak) IBOutlet UIButton *IconBut;

@property (nonatomic, weak) IBOutlet UIButton *F1But;
@property (nonatomic, weak) IBOutlet UIButton *F2But;
@property (nonatomic, weak) IBOutlet UIButton *inappropratorButton;
@property (nonatomic, weak) IBOutlet UIImageView *inappropratorImageview;
@end
