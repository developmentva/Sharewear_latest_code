//
//  UtilityText.h
//  MyVite
//
//  Created by Apple on 05/05/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UtilityText : NSObject
+ (void)textFieldDidBeginEditing:(UIView *)textField view:(UIView*)view;
+ (void)textFieldDidEndEditing:(UIView*)textField view:(UIView*)view;
@end
