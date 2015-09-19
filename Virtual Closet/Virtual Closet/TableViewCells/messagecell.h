//
//  messagecell.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EGOImageView.h"
@interface messagecell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *NameLable;
@property (nonatomic, weak) IBOutlet UILabel *Messagelable;
@property (nonatomic, weak) IBOutlet UILabel *timelable;
@property (nonatomic, weak) IBOutlet UIImageView *Friendimage;
@property (nonatomic, weak) IBOutlet UIImageView *Statusimage;
@end
