//
//  TermsAndPrivacy.h
//  ShareWear
//
//  Created by Apple on 05/11/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsAndPrivacy : UIViewController<UIWebViewDelegate>
@property int type;;
@property(nonatomic,strong)IBOutlet UIWebView *WebviewObj;
@end
