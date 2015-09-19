//
//  UtilityText.m
//  MyVite
//
//  Created by Apple on 05/05/14.
//
//

#import "UtilityText.h"
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 236;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
static CGFloat animatedDistance = 0.0;

const int kTagConfirmationPopUp = 1;
const int kTagInformationPopUp = 2;

const float kDefaultCellFontSize = 12.0;
@implementation UtilityText


//TextField
+ (void)textFieldDidBeginEditing:(UIView *)textField view:(UIView*)view
{
	CGRect textFieldRect =
	[view.window convertRect:textField.bounds fromView:textField];
	CGRect viewRect =
	[view.window convertRect:view.bounds fromView:view];
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator =
	midline - viewRect.origin.y
	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator =
	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
	* viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
	{
		heightFraction = 0.0;
	}
	else if (heightFraction > 1.0)
	{
		heightFraction = 1.0;
	}
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	}
	else
	{
		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
	}
	CGRect viewFrame = view.frame;
	viewFrame.origin.y -= animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[view setFrame:viewFrame];
	
	[UIView commitAnimations];
}

+ (void)textFieldDidEndEditing:(UIView*)textField view:(UIView*)view
{
	CGRect viewFrame = view.frame;
	viewFrame.origin.y += animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[view setFrame:viewFrame];
	
	[UIView commitAnimations];
}


@end
