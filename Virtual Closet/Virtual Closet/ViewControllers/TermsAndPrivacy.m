//
//  TermsAndPrivacy.m
//  ShareWear
//
//  Created by Apple on 05/11/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "TermsAndPrivacy.h"
#import "UILabel+NavigationTitle.h"
#import "Flurry.h"
@implementation TermsAndPrivacy


-(void)viewDidLoad
{
    [Flurry logEvent:@"TERMS AND PRIVACY VIEW"];
    UIImage * image = [UIImage imageNamed:@"back_btn"];
   UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(BackPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *RightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=RightButton;
    [UILabel SetTitle:(self.type==1)?@"Terms of Use":@"Privacy Policy" OnView:self];
    [self loadDocument:(self.type==1)?@"terms":@"policy" inView:self.WebviewObj];
    [super viewDidLoad];
}

-(void)BackPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView
{
//    //!!!!!!!!!!!!!!!!  Show On Webview !!!!!!!!!!!!!!
//    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    
//    // Assuming data is in UTF8.
//    NSString *string = [NSString stringWithUTF8String:[data bytes]];
//    
//    // if data is in another encoding, for example ISO-8859-1
//    string = [[NSString alloc]
//                        initWithData:data encoding: NSISOLatin1StringEncoding];
//
//    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadHTMLString:string baseURL:nil];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:documentName ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:nil];
    [webView.scrollView setContentSize: CGSizeMake(0, webView.scrollView.contentSize.height)];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    //!!!!!!!!!!!!!!!!  Check Clicked URl !!!!!!!!!!!!!!
//    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
//        NSURL *url = request.URL;
//        NSString *urlString = url.absoluteString;
//        if ( [ urlString isEqualToString: @"http://www.example.com/"] ) {
//            [[UIApplication sharedApplication] openURL:[request URL]];
//        }
//        else{
//            NSString *email = [NSString stringWithFormat:@"%@?&subject=Subject!", urlString];
//            email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
//        }
//        return NO;
//    }
    
    return YES;
}


@end
