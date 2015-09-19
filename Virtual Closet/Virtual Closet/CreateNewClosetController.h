//
//  CreateNewClosetController.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
#import "RKCropImageController.h"
BOOL EditingExisting;
@interface CreateNewClosetController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,RKCropImageViewDelegate>
{
    __weak IBOutlet UIView *NameBaseView;
    __weak IBOutlet UIView *PrivacyBaseView;
    __weak IBOutlet UIView *AddItemsBaseView;
    __weak IBOutlet UIView *ImagesBaseView;
    __weak IBOutlet UIView *LowerBaseView;
    __weak IBOutlet UIScrollView *Scroll;
    __weak IBOutlet UIButton *ViewBut;
    BOOL ForItems,somethingchanged;
    NSData *IconImage;
    NSMutableArray *ItemImagesArray;
    
    NSMutableArray *ItemsIDArray;
    NSMutableArray *ItemsColorArray;
    NSMutableArray *ItemsSizeArray;
    NSMutableArray *ItemsBrandArray;
    NSMutableArray *ItemsDecriptionArray;
    NSMutableArray *ObjectIDArray;
    NSMutableArray *ItemsStatusArray;
    NSMutableArray *ItemsTypeArray;
    NSString *ItemsOwnerIDArray;
    IBOutlet UIButton *AdFriendsBut;
    
}
@property(nonatomic,strong)IBOutlet UIButton *OpenTick;
@property(nonatomic,strong)IBOutlet UIButton *CloseTick;
@property(nonatomic,strong)IBOutlet UIButton *SecretTick;
@property(nonatomic,strong)IBOutlet UITextField *Closetname;
@property(nonatomic,strong)UIImage *ClosetIcon;
@property(nonatomic,strong)NSString *PrivacyType;
@property(nonatomic,strong)NSString *ClosetID;
@property(nonatomic,strong)NSString *EditedClosetname;
@property(nonatomic,strong)NSString *EditedPrivacy;
@property(nonatomic,strong) UIImage *EditedImage;
@property BOOL EditCloset;
-(void)AddediTemImage:(UIImage *)image;
@end
