//
//  MyClosetViewController.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
#import "REFrostedViewController.h"
@interface MyClosetViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *ClosetNameArray;
    NSMutableArray *ClosetIdArray;
    NSMutableArray *ClosetIconArray;
    NSMutableArray *ClosetStatusArray;
     NSMutableArray *ClosetPrivacyArray;
     NSMutableArray *OwnerIDArray;
}
@property(nonatomic,strong)IBOutlet UICollectionView *Collection;
@property BOOL Backvisible;
@end
