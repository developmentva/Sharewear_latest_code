//
//  likeCell.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EGOImageView.h"
@interface likeCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *closetTitle;
@property (nonatomic, weak) IBOutlet UILabel *TimeLable;
@property (nonatomic, weak) IBOutlet UILabel *ColorLable;
@property (nonatomic, weak) IBOutlet UILabel *SizeLable;
@property (nonatomic, weak) IBOutlet UILabel *BrandLable;
@property (nonatomic, weak) IBOutlet UIButton *requestbut;
@property (nonatomic, weak) IBOutlet UIButton *CheckStatus;
@property (nonatomic, weak) IBOutlet UIButton *DeleteBut;
@property (nonatomic, weak) IBOutlet UIButton *PhotoEnlarge;
@property (nonatomic, weak) IBOutlet UIImageView *closetimage;
@end
