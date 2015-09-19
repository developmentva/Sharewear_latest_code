//
//  ItemViewerViewController.h
//  ShareWear
//
//  Created by Apple on 06/12/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestWindow.h"
#import "ServerParsing.h"
#import "Macro.h"
//#import "EGOImageView.h"
typedef enum : NSInteger {
    MoveDirectionNone,
    MoveDirectionUp,
    MoveDirectionDown,
    MoveDirectionRight,
    MoveDirectionLeft
} SDirection;
@interface ItemViewerViewController : UIViewController<UIScrollViewDelegate,RequestDelegate>
{
    SDirection direction;
     IBOutlet UIView *ContainerView;
     IBOutlet UIView *ContainerInnerView;
     IBOutlet UIImageView *Imageview;
     IBOutlet UILabel *nameLbl;
     IBOutlet UILabel *sizeLbl;
     IBOutlet UILabel *colorLbl;
     IBOutlet UILabel *brandLbl;
     IBOutlet UILabel *statusLbl;
     IBOutlet UILabel *noteLbl;
    IBOutlet UIButton *Requestbutton;
    NSString *Status;
    BOOL WindowVisible,Liked;
    IBOutlet UIScrollView *Scroll;
    IBOutlet UIPageControl *Pagecont;
    NSString *ItemID;
     NSString *size;
     NSString *brand;
     NSString *color;
     NSString *note;
     NSString *imageurl;
}
@property(nonatomic,strong) NSMutableArray *ItemsIDArray;
@property(nonatomic,strong) NSMutableArray *ItemsColorArray;
@property(nonatomic,strong) NSMutableArray *ItemsSizeArray;
@property(nonatomic,strong) NSMutableArray *ItemsBrandArray;
@property(nonatomic,strong) NSMutableArray *ItemsDecriptionArray;
@property(nonatomic,strong) NSMutableArray *ItemsimageArray;
@property(nonatomic,strong) NSMutableArray *ItemsStatusArray;
@property(nonatomic,strong) NSMutableArray *ItemsTypeArray;
@property(nonatomic,strong) NSString *ItemsOwnerIDArray;
@property(nonatomic,strong) NSString *OwnerID;
@property(nonatomic,strong) NSString *ClosetID;
@property(nonatomic,strong) NSString *Closetname;
@property NSInteger index;
@property BOOL FromFeed;
@end
