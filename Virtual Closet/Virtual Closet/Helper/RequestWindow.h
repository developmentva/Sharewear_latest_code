//
//  RequestWindow.h
//  Virtual Closet
//
//  Created by Apple on 19/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
#import "SZTextView.h"
#import "UtilityText.h"
#import "FlatDatePicker.h"
@class RequestWindow;
@protocol RequestDelegate <NSObject>

@optional
-(void)SendPressed:(NSString *)eventdate Pick:(NSString *)pickDate Return:(NSString *)returndate;
-(void)viewclosed;
@end
@interface RequestWindow : UIView<UITextFieldDelegate,UITextViewDelegate,FlatDatePickerDelegate>
{
    __weak IBOutlet UIView *ContainerView;
    __weak IBOutlet UITextField *EventnameText;
    __weak IBOutlet SZTextView *MessageText;
    __weak IBOutlet UIButton *dateText;
    __weak IBOutlet UIButton *Pickdate;
    __weak IBOutlet UIButton *ReturnDate;
    __weak IBOutlet UIButton *PickTime;
    __weak IBOutlet UIButton *ReturnTime;
    UIView *nibView;
    NSString *PickTimeStamp;
     NSString *ReturnTimeStamp;
    BOOL PickTimes;
    BOOL returntimes;
}
@property NSInteger TypeSlected;
//@property (nonatomic, strong)IBOutlet UIView *ContainerView;
@property (nonatomic, strong) FlatDatePicker *flatDatePicker;
@property(nonatomic,strong)NSString *ItemId;
@property(nonatomic,strong)NSString *OwnerID;
@property(nonatomic,strong)NSString *ClosetID;
@property(strong)id<RequestDelegate>delegate;
+(RequestWindow*)Request;
-(void)Initialize;
@end
