//
//  Notificationcell.h
//  Virtual Closet
//
//  Created by Apple on 19/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EGOImageView.h"
@interface Notificationcell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *Messagelable;
@property (nonatomic, weak) IBOutlet UILabel *timelable;
@property (nonatomic, weak) IBOutlet UILabel *PickDate;
@property (nonatomic, weak) IBOutlet UILabel *DropDate;
@property (nonatomic, weak) IBOutlet UITextView *MessaageText;
@property (nonatomic, weak) IBOutlet UIImageView *Friendimage;
@property (nonatomic, weak) IBOutlet UIButton *BubbleBut;
@property (nonatomic, weak) IBOutlet UIButton *AcceptBut;
@property (nonatomic, weak) IBOutlet UIButton *DeclineBut;
@property (nonatomic, weak) IBOutlet UIButton *PhotoEnlargeBut;
@end
