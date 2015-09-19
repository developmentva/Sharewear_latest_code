//
//  GSScrollerViewController.m
//  ShareWear
//
//  Created by Apple on 10/11/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "GSScrollerViewController.h"
//#import "singleClosetDetailController.h"
#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "GCCacheSaver.h"
#import "TTSlidingPageTitle.h"
@interface GSScrollerViewController ()
 @property (strong, nonatomic) TTScrollSlidingPagesController *slider;
@end

@implementation GSScrollerViewController
@synthesize ViewcontrollerArray;
- (void)viewDidLoad {
    [super viewDidLoad];

    //initial setup of the TTScrollSlidingPagesController.
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    self.slider.titleScrollerInActiveTextColour = [UIColor grayColor];
    self.slider.titleScrollerBottomEdgeColour = [UIColor darkGrayColor];
    self.slider.titleScrollerBottomEdgeHeight = 2;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        self.slider.hideStatusBarWhenScrolling = YES;//this property normally only makes sense on iOS7+. See the documentation in TTScrollSlidingPagesController.h. If you wanted to use it in iOS6 you'd have to make sure the status bar overlapped the TTScrollSlidingPagesController.
    }
    
    //set the datasource.
    self.slider.dataSource = self;
    self.slider.delegate=self;
    
    //add the slider's view to this view as a subview, and add the viewcontroller to this viewcontrollers child collection (so that it gets retained and stays in memory! And gets all relevant events in the view controller lifecycle)
    self.slider.view.frame = self.view.frame;
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
}
-(void)BackPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark TTSlidingPagesDataSource methods
//-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
//    return self.ViewcontrollerArray.count; //just return 7 pages as an example
//}
//
//-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
//    singleClosetDetailController  *viewController=(singleClosetDetailController *)[self.ViewcontrollerArray objectAtIndex:index];
//    return [[TTSlidingPage alloc] initWithContentViewController:viewController];
//}
//
//-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
//    return [[TTSlidingPageTitle alloc] initWithHeaderText:@"Page 2"];
//}
//
//#pragma mark - delegate
//-(void)didScrollToViewAtIndex:(NSUInteger)index
//{
//    NSLog(@"scrolled to view");
//    singleClosetDetailController  *viewController=(singleClosetDetailController *)[self.ViewcontrollerArray objectAtIndex:index];
//    [viewController setNeedsStatusBarAppearanceUpdate];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
