//
//  RequestWindow.m
//  Virtual Closet
//
//  Created by Apple on 19/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "RequestWindow.h"
#import "GCHud.h"
#import "SIAlertView.h"
RequestWindow *Window;
@implementation RequestWindow
@synthesize delegate;
@synthesize ItemId;
@synthesize OwnerID;
@synthesize ClosetID;
+(RequestWindow *)Request
{
    if (!Window) {
        Window=[[RequestWindow alloc]init];
    }
    return Window;
}

-(void)Initialize
{
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"RequestWindow" owner:self options:nil];
   nibView = [nibObjects objectAtIndex:0];
    nibView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.4];
//    CGRect Frame=ContainerView.frame;
//    Frame.origin.y=100;
//    ContainerView.frame=Frame;
    UIView *CurrentView=[self currentViewController].view;
    [CurrentView addSubview:nibView];
    MessageText.placeholder=@"Message";
    Window.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:[self currentViewController].view];
    Window.flatDatePicker.delegate = Window;
    Window.flatDatePicker.title = @"Select date";
    Window.flatDatePicker.datePickerMode = FlatDatePickerModeDate;
    //ContainerView.center=CurrentView.center;
//    [UIView animateWithDuration:0.7 animations:^{
//        CGRect Frame=ContainerView.frame;
//        Frame.origin.y=[[UIScreen mainScreen] bounds].size.height-Frame.size.height;
//        ContainerView.frame=Frame;
//    }];
    [self transitionInCompletion:^{
        NSLog(@"Completion");
    } ShowPop:YES];
}

- (void)transitionInCompletion:(void(^)(void))completion ShowPop:(BOOL)show
{
    switch (show) {
        case YES:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [ContainerView.layer addAnimation:animation forKey:@"bouce"];
        }
            break;
        case NO:
        {
            CGPoint point = ContainerView.center;
            point.y += self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:.3
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 ContainerView.center = point;
                                 CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                                 ContainerView.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        default:
            break;
    }
}

- (UIViewController *)currentViewController
{
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}


-(IBAction)SendHit:(id)sender
{
     [self endEditing:YES];
    if ([EventnameText.text length]==0) {
        [self ShowAlertWithText:@"Add Event name"];
        return;
    }
//    if ([dateText.currentTitle isEqualToString:@"Date"]) {
//        [self ShowAlertWithText:@"Add Date"];
//        return;
//    }
//    if ([dateText.currentTitle isEqualToString:@"Pick Date"]) {
//        [self ShowAlertWithText:@"Add Pick Date"];
//        return;
//    }
//    if ([dateText.currentTitle isEqualToString:@"Return Date"]) {
//        [self ShowAlertWithText:@"Add Return Date"];
//        return;
//    }
    if ([MessageText.text length]==0) {
        [self ShowAlertWithText:@"Add message"];
        return;
    }
    [[GCHud Hud] showNormalHUD:@"Requesting"];
    NSMutableDictionary *param=[NSMutableDictionary new];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"itemid"] forKey:@"item_id"];
    [param setObject:[Utility UserID] forKey:@"req_by_fb_id"];
    [param setObject:[Utility UserName] forKey:@"fb_name"];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"ownerid"] forKey:@"item_of_fb_id"];
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"closetrid"] forKey:@"item_of_closet_id"];
    [param setObject:EventnameText.text forKey:@"event"];
    [param setObject:strpick forKey:@"pickup_date"];
    [param setObject:StrReturn forKey:@"return_date"];
    [param setObject:MessageText.text forKey:@"message"];
   // [param setObject:dateText.currentTitle forKey:@"basic_date"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/request_item.php?" WithParameter:param Success:^(NSMutableDictionary *Dic) {
        [[GCHud Hud] showSuccessHUD];
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
        }
    } Error:^{
        [[GCHud Hud] showErrorHUD];
    }];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Request Sent"];
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                              [UIView animateWithDuration:0.7 animations:^{
                                  CGRect Frame=ContainerView.frame;
                                  Frame.origin.y=[[UIScreen mainScreen] bounds].size.height;
                                  ContainerView.frame=Frame;
                              }completion:^(BOOL finished) {
                                  [self removeFromSuperview];
                                  PickTimes=NO;
                                  returntimes=NO;
                                  [Window.delegate SendPressed:dateText.currentTitle Pick:Pickdate.currentTitle Return:ReturnDate.currentTitle];
                              }];

                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
//    [self transitionInCompletion:^{
//        [self removeFromSuperview];
//        PickTimes=NO;
//        returntimes=NO;
//        [Window.delegate SendPressed:dateText.currentTitle Pick:Pickdate.currentTitle Return:ReturnDate.currentTitle];
//    } ShowPop:NO];
}
-(IBAction)DateSelect:(id)sender
{
    [self endEditing:YES];
    switch ([sender tag]) {
        case 0:
            Window.TypeSlected=0;
            break;
        case 1:
            Window.TypeSlected=1;
            break;
        case 2:
            Window.TypeSlected=2;
            break;
            
        default:
            break;
    }
    PickTimes=NO;
    returntimes=NO;
    Window.flatDatePicker.title = @"Select date";
    Window.flatDatePicker.datePickerMode = FlatDatePickerModeDate;
    Window.flatDatePicker.delegate = Window;
    [Window.flatDatePicker show];
}

#pragma mark - FlatDatePicker Delegate
NSString *strpick,*StrReturn;
- (void)flatDatePicker:(FlatDatePicker *)datePicker didValid:(UIButton *)sender date:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *value = [dateFormatter stringFromDate:date];
    switch (Window.TypeSlected) {
        case 0:
            [dateText setTitle:value forState:UIControlStateNormal];
            break;
        case 1:
        {
//            if (!PickTimes) {
//                Window.flatDatePicker.title = @"Select time";
//                Window.flatDatePicker.datePickerMode = FlatDatePickerModeTime;
//                [Window.flatDatePicker show];
//                PickTimes=YES;
//            }
//            else{
            strpick=[self Unix:date];
            //PickTimeStamp=[str copy];
            [Pickdate setTitle:value forState:UIControlStateNormal];
            //}
            break;
        }
        case 2:
        {
//            if (!returntimes) {
//                Window.flatDatePicker.title = @"Select time";
//                Window.flatDatePicker.datePickerMode = FlatDatePickerModeTime;
//                [Window.flatDatePicker show];
//                returntimes=YES;
//            }
//            else
//            {
            StrReturn=[self Unix:date];
           // ReturnTimeStamp=[str copy];
            [ReturnDate setTitle:value forState:UIControlStateNormal];
           // }
            break;
        }
            
        default:
            break;
    }
}
-(IBAction)CloseView:(id)sender
{
    [self endEditing:YES];
    [self transitionInCompletion:^{
        PickTimes=NO;
        returntimes=NO;
        [Window.delegate viewclosed];
        [self removeFromSuperview];
    } ShowPop:NO];
//    [UIView animateWithDuration:0.7 animations:^{
//        CGRect Frame=ContainerView.frame;
//        Frame.origin.y=[[UIScreen mainScreen] bounds].size.height;
//        ContainerView.frame=Frame;
//    }completion:^(BOOL finished) {
//        PickTimes=NO;
//        returntimes=NO;
//        [Window.delegate viewclosed];
//        [self removeFromSuperview];
//    }];

}
-(void)ShowAlertWithText:(NSString *)text
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ShearWear" message:text delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UtilityText textFieldDidBeginEditing:textField view:nibView];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UtilityText textFieldDidEndEditing:textField view:nibView];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UtilityText textFieldDidBeginEditing:textView view:nibView];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
     [UtilityText textFieldDidEndEditing:textView view:nibView];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

-(NSString *)Unix:(NSDate *)date
{
    NSDateFormatter*  dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    date = [date dateByAddingTimeInterval:interval];
    int startTime = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%i",startTime];
}

@end
