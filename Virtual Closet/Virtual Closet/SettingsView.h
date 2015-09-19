//
//  SettingsView.h
//  Virtual Closet
//
//  Created by Apple on 19/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
#import "UtilityText.h"
@class SettingsView;
@interface SettingsView : UIView<UITextFieldDelegate>
{
     IBOutlet UIView *NibView;
    __weak IBOutlet UITextField *ShoeSizeText;
    __weak IBOutlet UITextField *DressSizeText;
    __weak IBOutlet UITextField *ColorText;
    __weak IBOutlet UITextField *pantText;
    __weak IBOutlet UITextField *BrandText;
    __weak IBOutlet UIButton *SaveBut;
    NSString *UserIs;
    BOOL ownerActive;
    UIAlertView *alert;
}
@property(strong,nonatomic)IBOutlet UIView *NibView;
+(SettingsView *)Settings;
-(void)initializeonVIEW:(UIView *)View FOrUser:(NSString *)user IsOwner:(BOOL)owner;
@end
