//
//  SettingsView.m
//  Virtual Closet
//
//  Created by Apple on 19/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "SettingsView.h"
#import "GCCacheSaver.h"
#import "Flurry.h"
SettingsView *view;
@implementation SettingsView
@synthesize NibView;
+(SettingsView*)Settings
{
    if (!view) {
        view=[[SettingsView alloc]init];
    }
    return view;
}

-(void)initializeonVIEW:(UIView *)View FOrUser:(NSString *)user IsOwner:(BOOL)owner
{
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SettingsView" owner:self options:nil];
    UIView *nibView = [nibObjects objectAtIndex:0];
    [View addSubview:nibView];
    [View sendSubviewToBack:NibView];
    CGRect Frame=nibView.frame;
    Frame.origin.y=230;
    nibView.frame=Frame;
    UserIs=user;
    ownerActive=owner;
    if (!owner) {
        SaveBut.hidden=YES;
        ShoeSizeText.userInteractionEnabled=NO;
        DressSizeText.userInteractionEnabled=NO;
        ColorText.userInteractionEnabled=NO;
        pantText.userInteractionEnabled=NO;
        BrandText.userInteractionEnabled=NO;
    }
    [self DisplayMetaData:user];
}

-(void)DisplayMetaData:(NSString *)user
{
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"UserSettings" inRelativePath:[NSString stringWithFormat:@"Settings_%@",user]];
    ShoeSizeText.text=[[Dic objectForKey:@"ShoeSize"] mutableCopy];
    DressSizeText.text=[[Dic objectForKey:@"DressSize"] mutableCopy];
    ColorText.text=[[Dic objectForKey:@"Blouse"] mutableCopy];
    pantText.text=[[Dic objectForKey:@"pantsize"] mutableCopy];
   // BrandText.text=[[Dic objectForKey:@"Preffered"] mutableCopy];
}

-(IBAction)SaveSettings:(id)sender
{
//    if ([ShoeSizeText.text length]==0) {
//        [self ShowAlertWithText:@"Add Shoe size"];
//        return;
//    }
//    if ([DressSizeText.text length]==0) {
//        [self ShowAlertWithText:@"Add Dress size"];
//        return;
//    }
//    if ([ColorText.text length]==0) {
//        [self ShowAlertWithText:@"Add Blouse"];
//        return;
//    }
//    if ([pantText.text length]==0) {
//        [self ShowAlertWithText:@"Add Pant size"];
//        return;
//    }
//    if ([BrandText.text length]==0) {
//        [self ShowAlertWithText:@"Add Preffered brand"];
//        return;
//    }
    alert= [[UIAlertView alloc]initWithTitle:@"ShareWear" message:@"Do you want to update your profile?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
    [self endEditing:YES];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  //  if (alert.tag !=5) {
    if (buttonIndex ==1){
    
    }
    else
    {
       [self UpdateSettings];
    }
//}

}
//-(void)test:(UIAlertView*)x{
//    [alert dismissWithClickedButtonIndex:0 animated:YES];
//}
-(void)UpdateSettings
{
    alert= [[UIAlertView alloc]initWithTitle:nil message:@"Successfully Updated" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //[self performSelector:@selector(test:) withObject:alert afterDelay:1];
    [alert show];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //http://platinuminfosys.org/parse/parse.com-php-library-master/update_settings.php?fb_id=10152357374552681&color=red&shoe=9&size=42&brand=peter&prefrence=all
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[Utility UserID] forKey:@"fb_id"];
    [Param setObject:ColorText.text forKey:@"blouse"];
    [Param setObject:ShoeSizeText.text forKey:@"shoe"];
    [Param setObject:DressSizeText.text forKey:@"size"];
    [Param setObject:pantText.text forKey:@"pant"];
   // [Param setObject:PrefrenceText.text forKey:@"prefrence"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/update_settings.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [self StoreSettings:Dic];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    } Error:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}
-(void)StoreSettings:(NSMutableDictionary *)dic
{
    NSMutableDictionary *Settings=[NSMutableDictionary new];
    [Settings setObject:ShoeSizeText.text forKey:@"ShoeSize"];
    [Settings setObject:DressSizeText.text forKey:@"DressSize"];
    [Settings setObject:ColorText.text forKey:@"Blouse"];
    [Settings setObject:pantText.text forKey:@"pantsize"];
   // [Settings setObject:BrandText.text forKey:@"Preffered"];
    [GCCacheSaver saveDictionary:Settings withName:@"UserSettings" inRelativePath:[NSString stringWithFormat:@"Settings_%@",UserIs]];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UtilityText textFieldDidBeginEditing:textField view:NibView];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UtilityText textFieldDidEndEditing:textField view:NibView];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

-(void)ShowAlertWithText:(NSString *)text
{
    alert=[[UIAlertView alloc]initWithTitle:@"ShearWear" message:text delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
