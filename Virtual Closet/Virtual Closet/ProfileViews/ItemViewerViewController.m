//
//  ItemViewerViewController.m
//  ShareWear
//
//  Created by Apple on 06/12/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "ItemViewerViewController.h"
#import "SIAlertView.h"
#import "UILabel+NavigationTitle.h"
#import "GCHud.h"
#import "GCCacheSaver.h"
#import "UIViewController+JDSideMenu.h"
#import "SlidingViewController.h"
#import "DBShared.h"
#import "UIImageView+Network.h"
#import "Flurry.h"

@interface ItemViewerViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ItemViewerViewController

- (void)viewDidLoad {
    [Flurry logEvent:@"ITEM_VIWER_VIEW"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    
    UIImage *image = [UIImage imageNamed:@"list_icon1"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OpenProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=LeftButton;
    
    image = [UIImage imageNamed:@"back_btn"];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(BackPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *RightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=RightButton;
    
    self.navigationController.navigationItem.title=@"My Items";
    ContainerView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.4];
    ContainerView.hidden=YES;
    ContainerInnerView.hidden=YES;
    [UILabel SetTitle:self.Closetname OnView:self];
    if (self.FromFeed) {
        ItemID=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"id"];
        brand=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"brand"];
        size=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"size"];
        color=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"color"];
        note=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"descrip"];
        Status=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"status"];
        imageurl=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"image_name"];
         [Imageview loadImageFromURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
        //Imageview.image =[UIImage imageWithData:[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"image_name"]];
        Scroll.delegate=nil;
    }
    else{
    ItemID=[self.ItemsIDArray objectAtIndex:self.index];
    brand=[self.ItemsBrandArray objectAtIndex:self.index];
    size=[self.ItemsSizeArray objectAtIndex:self.index];
    color=[self.ItemsColorArray objectAtIndex:self.index];
    note=[self.ItemsDecriptionArray objectAtIndex:self.index];
    Status=[self.ItemsStatusArray objectAtIndex:self.index];
    imageurl=[self.ItemsimageArray objectAtIndex:self.index];
    [self CreateMultipleimages];
    }
    
    nameLbl.text=[NSString stringWithFormat:@"Added by %@",self.Closetname];
    sizeLbl.text=[NSString stringWithFormat:@"Size: %@",size];
    colorLbl.text=[NSString stringWithFormat:@"Color: %@",color];
    if ([brand length]>0) {
        brandLbl.text=[NSString stringWithFormat:@"Brand: %@",brand];
    }
    else{
        noteLbl.center=brandLbl.center;
    }
    if ([note length]>0) {
        noteLbl.text=[NSString stringWithFormat:@"Note: %@",note];
    }
    
   
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(handleSingleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [Scroll addGestureRecognizer:singleTapGestureRecognizer];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer.delegate=self;
    [Scroll addGestureRecognizer:recognizer];

    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)OpenProfile:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

-(void)BackPress:(id)sender
{
    [SlidingViewController Dissmissfrom:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CreateMultipleimages
{
    NSInteger width=320;
    NSInteger height=Scroll.frame.size.height;
    NSInteger Y=0;
    NSInteger X=0;
    for (int i=0; i<self.ItemsimageArray.count; i++) {
        UIImageView *itemImage=[[UIImageView alloc]initWithFrame:CGRectMake(X, Y, width, height)];
        itemImage.userInteractionEnabled=YES;
        itemImage.contentMode=UIViewContentModeScaleAspectFit;
        [itemImage loadImageFromURL:[NSURL URLWithString:[self.ItemsimageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
        [Scroll addSubview:itemImage];
       
        X=X+320;
    }
    [Scroll setContentSize:CGSizeMake(self.view.frame.size.width*self.ItemsimageArray.count, Scroll.frame.size.height)];
    Pagecont.numberOfPages=self.ItemsimageArray.count;
    [self ScrollToVisibleIndex:self.index];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

-(void)ScrollToVisibleIndex:(NSInteger )index
{
    CGRect frame;
    frame.origin.x = Scroll.frame.size.width * index;
    frame.origin.y = 0;
    frame.size = Scroll.frame.size;
    [Scroll scrollRectToVisible:frame animated:YES];
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = Scroll.frame.size.width * Pagecont.currentPage;
    frame.origin.y = 0;
    frame.size = Scroll.frame.size;
    [Scroll scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    Pagecont.currentPage = page; // you need to have a **iVar** with getter for pageControl
    
    if (self.FromFeed) {
        ItemID=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"id"];
        brand=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"brand"];
        size=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"size"];
        color=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"color"];
        note=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"descrip"];
        Status=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"status"];
        imageurl=[[self.ItemsIDArray objectAtIndex:self.index] objectForKey:@"image_name"];
    }
    else{
    ItemID=[self.ItemsIDArray objectAtIndex:page];
     brand=[self.ItemsBrandArray objectAtIndex:page];
     size=[self.ItemsSizeArray objectAtIndex:page];
     color=[self.ItemsColorArray objectAtIndex:page];
     note=[self.ItemsDecriptionArray objectAtIndex:page];
     Status=[self.ItemsStatusArray objectAtIndex:page];
    imageurl=[self.ItemsimageArray objectAtIndex:page];
    }
    nameLbl.text=[NSString stringWithFormat:@"Added by %@",self.Closetname];
    sizeLbl.text=[NSString stringWithFormat:@"Size: %@",size];
    colorLbl.text=[NSString stringWithFormat:@"Color: %@",color];
    if (brand) {
        brandLbl.text=[NSString stringWithFormat:@"Brand: %@",brand];
    }
    else{
        noteLbl.center=brandLbl.center;
    }
    if (note) {
        noteLbl.text=[NSString stringWithFormat:@"Note: %@",note];
    }
}
- (void)handleSwipe:(UIPanGestureRecognizer *)gesture
{
    if ([self.OwnerID isEqualToString:[Utility UserID]]) {
        return;
    }
    if (WindowVisible) {
        return;
    }
    if (Liked) {
        return;
    }
    CGPoint translation = [gesture translationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        direction = MoveDirectionNone;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged && direction == MoveDirectionNone)
    {
        direction = [self determineCameraDirectionIfNeeded:translation];
        
        // ok, now initiate movement in the direction indicated by the user's gesture
        
        switch (direction) {
            case MoveDirectionDown:
                NSLog(@"Start moving down");
                break;
                
            case MoveDirectionUp:
            {
                //http://www.platinuminfosys.org/parse/parse.com-php-library-master/add_liked_items.php?liker_fb_id=5465445&item_id=140957293614181
                Liked=YES;
                [[GCHud Hud] showNormalHUD:@"Like"];
                NSMutableDictionary *Param=[NSMutableDictionary new];
                [Param setObject:[Utility UserID] forKey:@"liker_fb_id"];
                [Param setObject:ItemID forKey:@"item_id"];
                [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/add_liked_items.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
                    [[GCHud Hud] showSuccessHUD];
                    if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Great" andMessage:@"You have added this item to My Likes"];
                        [alertView addButtonWithTitle:@"OK"
                                                 type:SIAlertViewButtonTypeCancel
                                              handler:^(SIAlertView *alertView) {
                                                  NSLog(@"OK Clicked");
                                              }];
                        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
                        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
                        [alertView show];
                        //[self LikeSaved];
                    }
                    if ([[Dic objectForKey:@"message"] isEqualToString:@"already"]) {
                        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Great" andMessage:@"You have already added this item to My Likes"];
                        [alertView addButtonWithTitle:@"OK"
                                                 type:SIAlertViewButtonTypeCancel
                                              handler:^(SIAlertView *alertView) {
                                                  NSLog(@"OK Clicked");
                                              }];
                        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
                        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
                        [alertView show];
                        //[self LikeSaved];
                    }
                } Error:^{
                    [[GCHud Hud] showErrorHUD];
                }];
                
                NSMutableDictionary *Params=[NSMutableDictionary new];
                [Params setObject:brand forKey:@"brand"];
                [Params setObject:_ClosetID forKey:@"closet_id"];
                [Params setObject:_OwnerID forKey:@"closet_owner_fb_id"];
                [Params setObject:color forKey:@"color"];
                [Params setObject:[self Unix] forKey:@"createdAt"];
                [Params setObject:note forKey:@"description"];
                [Params setObject:imageurl forKey:@"image_name"];
                [Params setObject:size forKey:@"size"];
                [Params setObject:Status forKey:@"status"];
                [[DBShared shared] savemylikes:Params Itemid:ItemID];
                
                break;
            }
                
            case MoveDirectionRight:
                NSLog(@"Start moving right");
                break;
                
            case MoveDirectionLeft:
                NSLog(@"Start moving left");
                break;
                
            default:
                break;
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        // now tell the camera to stop
        NSLog(@"Stop");
    }
}

-(void)LikeSaved
{
    NSMutableArray *iTemArray;
    NSMutableArray *iTemIDArray;
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"likes" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            iTemArray=[[Dic objectForKey:@"items"] mutableCopy];
            iTemIDArray=[[Dic objectForKey:@"ids"] mutableCopy];
        }
        else
        {
            iTemArray=[NSMutableArray new];
            iTemIDArray=[NSMutableArray new];
        }
    }
    [iTemIDArray addObject:@"3253254"];
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:brand forKey:@"brand"];
    [dic setObject:_ClosetID forKey:@"closet_id"];
    [dic setObject:_OwnerID forKey:@"closet_owner_fb_id"];
    [dic setObject:color forKey:@"color"];
    [dic setObject:[self Unix] forKey:@"createdAt"];
    [dic setObject:note forKey:@"description"];
    [dic setObject:imageurl forKey:@"image_name"];
    [dic setObject:size forKey:@"size"];
    [dic setObject:Status forKey:@"status"];
    [iTemArray addObject:dic];
    
    
    dic=[NSMutableDictionary new];
    [dic setObject:iTemArray forKey:@"items"];
    [dic setObject:iTemIDArray forKey:@"ids"];
    [dic setObject:@"success" forKey:@"message"];
    [GCCacheSaver saveDictionary:dic withName:@"likes" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
}
-(NSString *)Unix
{
    NSDate *date=[NSDate date];
    int startTime = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%i",startTime];
}

CGFloat const gestureMinimumTranslation = 20.0;
- (SDirection)determineCameraDirectionIfNeeded:(CGPoint)translation
{
    
    if (direction != MoveDirectionNone)
        return direction;
    
    // determine if horizontal swipe only if you meet some minimum velocity
    
    if (fabs(translation.x) > gestureMinimumTranslation)
    {
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0)
            gestureHorizontal = YES;
        else
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0);
        
        if (gestureHorizontal)
        {
            if (translation.x > 0.0)
                return MoveDirectionRight;
            else
                return MoveDirectionLeft;
        }
    }
    // determine if vertical swipe only if you meet some minimum velocity
    
    else if (fabs(translation.y) > gestureMinimumTranslation)
    {
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0)
            gestureVertical = YES;
        else
            gestureVertical = (fabs(translation.y / translation.x) > 5.0);
        
        if (gestureVertical)
        {
            if (translation.y > 0.0)
                return MoveDirectionDown;
            else
                return MoveDirectionUp;
        }
    }
    
    return direction;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle singletap
    Requestbutton.hidden=NO;
    if ([_OwnerID isEqualToString:[Utility UserID]]) {
        Requestbutton.hidden=YES;
    }
    if (WindowVisible) {
        return;
    }
    [[self currentViewController].view bringSubviewToFront:ContainerView];
    ContainerView.alpha=0.0f;
    ContainerView.hidden=NO;
    [UIView animateWithDuration:.5 animations:^{
        ContainerView.alpha=1.0;
    }completion:^(BOOL finished) {
        [self transitionInCompletion:^{
            WindowVisible=YES;
        }];
    }];
}
-(IBAction)CloseWindow:(id)sender
{
    [self transitionOutCompletion:^{
        ContainerInnerView.hidden=YES;
        ContainerView.hidden=YES;
        WindowVisible=NO;
        ContainerInnerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

-(IBAction)RequestPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:ItemID forKey:@"itemid"];
    [[NSUserDefaults standardUserDefaults] setObject:_OwnerID forKey:@"ownerid"];
    [[NSUserDefaults standardUserDefaults] setObject:_ClosetID forKey:@"closetrid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self transitionOutCompletion:^{
        ContainerInnerView.hidden=YES;
        ContainerView.hidden=YES;
        ContainerInnerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [[RequestWindow Request] setDelegate:self];
        [[RequestWindow Request] Initialize];
    }];
}
-(void)viewclosed
{
    WindowVisible=NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"itemid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ownerid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"closetrid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)transitionInCompletion:(void(^)(void))completion
{
    ContainerInnerView.hidden=NO;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
    animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.5;
    animation.delegate = self;
    [animation setValue:completion forKey:@"handler"];
    [ContainerInnerView.layer addAnimation:animation forKey:@"bouce"];
    int64_t delayInSeconds = 0.6;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        completion();
    });
}

- (void)transitionOutCompletion:(void(^)(void))completion
{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(1), @(1.2), @(0.01)];
    animation.keyTimes = @[@(0), @(0.4), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.35;
    animation.delegate = self;
    [animation setValue:completion forKey:@"handler"];
    [ContainerInnerView.layer addAnimation:animation forKey:@"bounce"];
    ContainerInnerView.transform = CGAffineTransformMakeScale(0.00, 0.00);
    int64_t delayInSeconds = .7;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        completion();
    });
}

- (UIViewController *)currentViewController
{
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}


-(void)SendPressed:(NSString *)eventdate Pick:(NSString *)pickDate Return:(NSString *)returndate
{
    //    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Request Sent" andMessage:[NSString stringWithFormat:@"You have requested this dress for this event on %@ \nPickup on %@\nReturn on %@",eventdate,pickDate,returndate]];
    //    [alertView addButtonWithTitle:@"Done"
    //                             type:SIAlertViewButtonTypeCancel
    //                          handler:^(SIAlertView *alertView) {
    //                             alertView = [[SIAlertView alloc] initWithTitle:@"Request Confirmation" andMessage:[NSString stringWithFormat:@"Congrats! you can use this dress for this event on %@ \nPickup on %@\nReturn on %@\n\nYou'll look beautiful!",eventdate,pickDate,returndate]];
    //                              [alertView addButtonWithTitle:@"Done"
    //                                                       type:SIAlertViewButtonTypeCancel
    //                                                    handler:^(SIAlertView *alertView) {
    //                                                        NSLog(@"OK Clicked");
    //                                                    }];
    //                              alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    //                              alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    //                              [alertView show];
    //                          }];
    //    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    //    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    //    [alertView show];
    
    WindowVisible=NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"itemid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ownerid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"closetrid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
