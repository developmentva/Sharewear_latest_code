//
//  ClosetCollection.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AsyncImageView.h"
//#import "EGOImageView.h"
@interface ClosetCollection : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *closetimage;
@property (nonatomic, weak) IBOutlet UILabel *Closetname;
@property (nonatomic, weak) IBOutlet UIButton *DeclineButton;
@property (nonatomic, weak) IBOutlet UIButton *AcceptButton;
@property (nonatomic, weak) IBOutlet UIButton *EditButton;
@end
