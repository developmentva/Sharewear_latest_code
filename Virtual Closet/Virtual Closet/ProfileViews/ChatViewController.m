//
//  ChatViewController.m
//  Virtual Closet
//
//  Created by Apple on 08/10/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "ChatViewController.h"
#import "UILabel+NavigationTitle.h"
#import "GCHud.h"
#import "GCCacheSaver.h"
#import "SoundManager.h"
#import "AppDelegate.h"
#import "Flurry.h"
@interface ChatViewController ()<AMBubbleTableDataSource, AMBubbleTableDelegate>
{
    NSDateFormatter *dateFormatter;
    NSTimer *timer;
    SystemSoundID soundID;
    SystemSoundID SentsoundID;
    AppDelegate *App;
}
@property (nonatomic, strong) NSMutableArray* data;

@end

@implementation ChatViewController


-(void)StartTimer
{
    if (!NotOnView) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    }
    
}
- (void)timerCallback {
   // timer=nil;
    if ([CreatedAtArray count]>0) {
        [self GetAllmessages:[CreatedAtArray lastObject]];
    }
    
}
-(void)GetAllmessages:(NSString *)mid
{
    if (NotOnView) {
        return;
    }
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/get_messages.php?chat_id=140972547631384&my_fb_id=2222
   // [[GCHud Hud] showNormalHUD:@"Fetching List"];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:_ChatId forKey:@"chat_id"];
    [Param setObject:mid forKey:@"last_message"];
    [Param setObject:[Utility UserID] forKey:@"fb_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_messages.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        NSLog(@"%@",Dic);
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
             NSMutableDictionary *ChatDic=[GCCacheSaver getDictionaryWithName:@"History" inRelativePath:[NSString stringWithFormat:@"Chat_%@",_otherUser]];
            if (!ChatDic) {
                [GCCacheSaver saveDictionary:Dic withName:@"History" inRelativePath:[NSString stringWithFormat:@"Chat_%@",_otherUser]];
                [self AddMessagesToTheList:Dic FirstTime:YES];
                 AudioServicesPlaySystemSound(soundID);
               // [[SoundManager sharedManager] playSound:@"chatsound.mp3" looping:NO];
            }
            else
            {
                CreatedAtArray=[Dic objectForKey:@"createdAt"];
                MessagesArray=[Dic objectForKey:@"messages"];
                OtheruserIDArray=[Dic objectForKey:@"sender_fb_ids"];
                MessageIDArray=[Dic objectForKey:@"message_ids"];
                for (int i=0; i<CreatedAtArray.count; i++) {
                    [GCCacheSaver Updatedatabase:ChatDic WithItems:[NSArray arrayWithObjects:[CreatedAtArray objectAtIndex:i],[MessagesArray objectAtIndex:i],[OtheruserIDArray objectAtIndex:i],[MessageIDArray objectAtIndex:i], nil] Otheruser:_otherUser];
                }
                [self AddMessagesToTheList:Dic FirstTime:NO];
                 AudioServicesPlaySystemSound(soundID);
               // [[SoundManager sharedManager] playSound:@"chatsound.mp3" looping:NO];
            }
        }
        if ([[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
            //[self StartTimer];
        }
    } Error:^{
         //[self StartTimer];
    }];
}

-(void)AddMessagesToTheList:(NSMutableDictionary *)Dic FirstTime:(BOOL)frst
{
    CreatedAtArray=[Dic objectForKey:@"createdAt"];
    MessagesArray=[Dic objectForKey:@"messages"];
    OtheruserIDArray=[Dic objectForKey:@"sender_fb_ids"];
    MessageIDArray=[Dic objectForKey:@"message_ids"];
    for (int i=0; i<CreatedAtArray.count; i++) {
        NSString *Message=[MessagesArray objectAtIndex:i];
        NSDate *date=[self getDateFromUnixFormat:[CreatedAtArray objectAtIndex:i]];
        AMBubbleCellType Type=([[OtheruserIDArray objectAtIndex:i] isEqualToString:_otherUser])?AMBubbleCellReceived:AMBubbleCellSent;
        NSString *Username=([[OtheruserIDArray objectAtIndex:i] isEqualToString:_otherUser])?_OtherUserName:@"me";
        UIColor *color=([[OtheruserIDArray objectAtIndex:i] isEqualToString:_otherUser])?[UIColor redColor]:[UIColor greenColor];
        NSString *Avatar=([[OtheruserIDArray objectAtIndex:i] isEqualToString:_otherUser])?_OtherUserimage:[Utility UserImage];
        [self.data addObject:@{
                               @"text": Message,
                               @"date": date,
                               @"type": @(Type),
                               @"username": Username,
                               @"color": color,
                               @"avtar": Avatar
                               }];
    }
    //[self StartTimer];
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.data.count-1) inSection:0];
    if (frst) {
        [self.tableView reloadData];
        int64_t delayInSeconds = 0.6;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           [self scrollToBottomAnimated:YES];
                });
        
    }else
    {
        @try {
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
            int64_t delayInSeconds = 0.6;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self scrollToBottomAnimated:YES];
            });
            
        }
        @catch (NSException *exception) {
            
        }
      
    }
    
   
}


- (void)viewDidLoad
{
    
    [Flurry logEvent:@"CHAT_VIEW"];
    App=(AppDelegate *)[UIApplication sharedApplication].delegate;
    App.InChatView=YES;
    NSURL *fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/ReceivedMessage.caf"]; // see list below
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)fileURL,&soundID);
    
    fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/SentMessage.caf"]; // see list below
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)fileURL,&SentsoundID);
   
    
    //[SoundManager sharedManager].allowsBackgroundMusic = YES;
    ///[[SoundManager sharedManager] prepareToPlay];
    // Bubble Table setup
    dateFormatter = [[NSDateFormatter alloc] init];
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_back2"]];
    [self setDataSource:self]; // Weird, uh?
    [self setDelegate:self];
    self.data = [[NSMutableArray alloc]init];
    [self setTitle:@"Chat"];
    NSMutableDictionary *ChatDic=[GCCacheSaver getDictionaryWithName:@"History" inRelativePath:[NSString stringWithFormat:@"Chat_%@",_otherUser]];
    if (!ChatDic) {
        [self GetAllmessages:@""];
    }
    else{
        if ([[ChatDic objectForKey:@"message"] isEqualToString:@"success"]) {
            CreatedAtArray=[ChatDic objectForKey:@"createdAt"];
            [self AddMessagesToTheList:ChatDic FirstTime:NO];
            [self GetAllmessages:[CreatedAtArray lastObject]];
            
        }
    }
    [self StartTimer];
    // Set a style
    [self setTableStyle:AMBubbleTableStyleFlat];
    
    [self setBubbleTableOptions:@{AMOptionsBubbleDetectionType: @(UIDataDetectorTypeAll),
                                  AMOptionsBubblePressEnabled: @YES,
                                  AMOptionsBubbleSwipeEnabled: @NO}];
    
    // Call super after setting up the options
    [super viewDidLoad];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(14, 0, 0, 0)];
    
   UIImage * image = [UIImage imageNamed:@"back_btn"];
   UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(BackPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *RightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=RightButton;
    
    [UILabel SetTitle:@"Messages" OnView:self];
    //    [self fakeMessages];
}
-(void)BackPress:(id)sender
{
    if ([timer isValid]) {
        [timer invalidate];
    }
    [SlidingViewController Dissmissfrom:self];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if ([timer isValid]) {
        [timer invalidate];
    }
    NotOnView=YES;
    App.InChatView=NO;

    [super viewDidDisappear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    NotOnView=YES;
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}

- (void)fakeMessages
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self didSendText:@"Fake message here!"];
        [self fakeMessages];
    });
}

- (void)swipedCellAtIndexPath:(NSIndexPath *)indexPath withFrame:(CGRect)frame andDirection:(UISwipeGestureRecognizerDirection)direction
{
    NSLog(@"swiped");
}

#pragma mark - AMBubbleTableDataSource

- (NSInteger)numberOfRows
{
    return self.data.count;
}

- (AMBubbleCellType)cellTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.data[indexPath.row][@"type"] intValue];
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.data[indexPath.row][@"text"];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.data[indexPath.row][@"date"];
}

- (NSString*)avatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.data[indexPath.row][@"avtar"];
}

#pragma mark - AMBubbleTableDelegate

- (void)didSendText:(NSString*)text
{
    
    [self Sendmessages:text];
    [self.data addObject:@{ @"text": text,
                            @"date": [NSDate date],
                            @"type": @(AMBubbleCellSent),
                            @"username": @"me",
                            @"color": [UIColor greenColor],
                            @"avtar": [Utility UserImage]
                            }];
    NSLog(@"%@",self.data);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.data.count - 1) inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
     AudioServicesPlaySystemSound(SentsoundID);
    // [[SoundManager sharedManager] playSound:@"chatsound.mp3" looping:NO];
    // Either do this:
   // [self scrollToBottomAnimated:YES];
    // or this:
     [super reloadTableScrollingToBottom:YES];
}

-(void)Sendmessages:(NSString *)message
{
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/add_messages.php?message=hhhhh&sender_fb_id=2222&reciever_fb_id=5555
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:message forKey:@"message"];
    [Param setObject:[Utility UserID] forKey:@"sender_fb_id"];
    [Param setObject:_otherUser forKey:@"reciever_fb_id"];
     NSString *TimeStamp=[self Unix];
     [Param setObject:TimeStamp forKey:@"time_stamp"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/add_messages.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
             [GCCacheSaver Updatedatabase:nil WithItems:[NSArray arrayWithObjects:TimeStamp,message,[Utility UserID],[Dic objectForKey:@"message_id"], nil] Otheruser:_otherUser];
        }
    } Error:^{
    }];
}


- (NSString*)usernameForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.data[indexPath.row][@"username"];
}

- (UIColor*)usernameColorForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.data[indexPath.row][@"color"];
}


-(NSString *)Unix
{
    NSDate *date=[NSDate date];
//    dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    date = [date dateByAddingTimeInterval:interval];
    int startTime = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%i",startTime];
}

- (NSDate *) getDateFromUnixFormat:(NSString *)unixFormat
{
    if ([unixFormat isKindOfClass:[NSNull class]]) {
        return [NSDate date];
    }
    return  [NSDate dateWithTimeIntervalSince1970:[unixFormat intValue]];
//    [dateFormatter setDateFormat:@"HH:mm"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    NSString *dte=[dateFormatter stringFromDate:date];
    //return dte;
}
@end
