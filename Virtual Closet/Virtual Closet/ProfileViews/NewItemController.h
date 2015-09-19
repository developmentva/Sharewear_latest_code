//
//  NewItemController.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "ServerParsing.h"
#import "Macro.h"
#import "SZTextView.h"
#import "CreateNewClosetController.h"
//#import "EGOImageView.h"
@interface NewItemController : UIViewController<NIDropDownDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,RKCropImageViewDelegate>
{
     NIDropDown *dropDown;
    NSData *IconImage;
    __weak IBOutlet SZTextView *Descriptext;
    __weak IBOutlet UIView *BaseView;
    __weak IBOutlet UITextField *NametText;
    __weak IBOutlet UITextField *BrandText;
    __weak IBOutlet UIButton *ColorButton;
    __weak IBOutlet UIButton *SizeButton;
    __weak IBOutlet UIButton *ClosetButton;
    __weak IBOutlet UIButton *TypeButton;
    __weak IBOutlet UIImageView *IcoImg;
   __weak IBOutlet UIImageView *SelectedImageView;
    IBOutlet UIScrollView *Scroll;
    NSMutableArray *ClosetnameArrray;
    NSMutableArray *ClosetIDArray;
    BOOL closetSelected,Having;
}
@property BOOL IsNewItem;
@property(nonatomic,strong)CreateNewClosetController *Create;
@property(nonatomic,strong)NSString *ClosetIDd;
@property(nonatomic,strong)NSString *ClosetInamed;
@end
