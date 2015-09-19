//
//  MyItemController.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
BOOL EditingExisting;
NSMutableDictionary *ItemDetailDic;
@interface MyItemController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *MyItemsArray;
    NSMutableArray *MyItemsIdArray;
    NSMutableArray *MyItemsColorArray;
    NSMutableArray *MyItemsSizeArray;
    NSMutableArray *MyItemsBrandArray;
    NSMutableArray *MyItemsStatusArray;
    NSMutableArray *MyItemsTypeArray;
    NSMutableArray *MyItemsDecripArray;
    NSMutableArray *MyItemsImageArray;
    NSMutableArray *MyClosetIDArray;
    NSMutableArray *MyClosetNameArray;
     NSMutableArray *MyObjectIDArray;
}
@property(nonatomic,strong)IBOutlet UICollectionView *collection;
@end
