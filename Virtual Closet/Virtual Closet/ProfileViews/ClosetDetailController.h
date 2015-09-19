//
//  ClosetDetailController.h
//  Virtual Closet
//
//  Created by Apple on 19/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
@interface ClosetDetailController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *ItemsIDArray;
    NSMutableArray *ItemsColorArray;
    NSMutableArray *ItemsSizeArray;
    NSMutableArray *ItemsBrandArray;
    NSMutableArray *ItemsDecriptionArray;
    NSMutableArray *ItemsimageArray;
    NSMutableArray *ItemsStatusArray;
    NSMutableArray *ItemsTypeArray;
    NSString *ItemsOwnerIDArray;
}
@property(nonatomic,strong)IBOutlet UICollectionView *Collection;
@property(nonatomic,strong)NSString *ClosetId,*Closetname;
@end
