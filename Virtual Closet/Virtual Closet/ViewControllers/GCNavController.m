//
//  GCNavController.m
//  ShareWear
//
//  Created by Apple on 25/11/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "GCNavController.h"

@interface GCNavController ()

@end

@implementation GCNavController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender{
    // Dismiss keyboard (optional)

    //
//    [self.view endEditing:YES];
//    [self.frostedViewController.view endEditing:YES];
//    
//    // Present the view controller
//    //
//    [self.frostedViewController panGestureRecognized:sender];
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
