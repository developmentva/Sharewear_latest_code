//
//  GSScrollerViewController.h
//  ShareWear
//
//  Created by Apple on 10/11/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSlidingPagesDataSource.h"
#import "TTSliddingPageDelegate.h"
@interface GSScrollerViewController : UIViewController<TTSlidingPagesDataSource, TTSliddingPageDelegate>
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
@property (weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *ViewcontrollerArray;
@property (nonatomic,strong) NSMutableArray *ItemNameArray;
@property (nonatomic,strong) NSString *ClosetId;
@end
