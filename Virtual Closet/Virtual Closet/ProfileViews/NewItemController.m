
//
//  NewItemController.m
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "NewItemController.h"
#import "UILabel+NavigationTitle.h"
#import "NIDropDown.h"
#import "GCHud.h"
#import "UtilityText.h"
#import "QuartzCore/QuartzCore.h"
#import "SIAlertView.h"
#import "GCCacheSaver.h"
#import "ProfileViewController.h"
#import "CreateClosetController.h"
#import "SlidingViewController.h"
#import "MyClosetViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "DBShared.h"
#import "UIImageView+Network.h"
#import "Flurry.h"
extern BOOL EditingExisting;
extern NSMutableDictionary *ItemDetailDic;
@implementation NewItemController
@synthesize ClosetIDd,ClosetInamed;


- (void)viewDidLoad {
    [Flurry logEvent:@"NEWITEM_VIEW"];
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
    
    Descriptext.placeholder=@"Description";
   // UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    //[Scroll addGestureRecognizer:singleTap];
     [UILabel SetTitle:@"New Items" OnView:self];
    if (!EditingExisting) {
        if (_IsNewItem) {
            ClosetButton.enabled=NO;
            ClosetButton.alpha=.5;
            IcoImg.hidden=YES;
            [ClosetButton setTitle:self.ClosetInamed forState:UIControlStateNormal];
            self.ClosetIDd=[Utility GetClosetID];
            self.ClosetInamed=[Utility GetClosetname];
            self.navigationItem.rightBarButtonItem=RightButton;
        }
        else{
            self.ClosetIDd=[Utility GetClosetID];
            self.ClosetInamed=[Utility GetClosetname];
            NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"newitem" inRelativePath:@"List"];
            if (Dic) {
                if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                    ClosetnameArrray=[[Dic objectForKey:@"closet_names"] mutableCopy];
                    ClosetIDArray=[[Dic objectForKey:@"closet_id"] mutableCopy];
                }
            }
            [self GetAllClosets];
        }
    }
    else{
        NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"newitem" inRelativePath:@"List"];
        if (Dic) {
             Having=YES;
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                ClosetnameArrray=[[Dic objectForKey:@"closet_names"] mutableCopy];
                ClosetIDArray=[[Dic objectForKey:@"closet_id"] mutableCopy];
                Having=YES;
            }
        }
        self.navigationItem.rightBarButtonItem=RightButton;
        [self GetAllClosets];
        [ColorButton setTitle:[ItemDetailDic objectForKey:@"color"] forState:UIControlStateNormal];
        [SizeButton setTitle:[ItemDetailDic objectForKey:@"size"] forState:UIControlStateNormal];
        [ClosetButton setTitle:[self closetname] forState:UIControlStateNormal];
        [TypeButton setTitle:[ItemDetailDic objectForKey:@"type"] forState:UIControlStateNormal];
        BrandText.text=[ItemDetailDic objectForKey:@"brand"];
        Descriptext.text=[ItemDetailDic objectForKey:@"decrip"];
        NametText.text=[ItemDetailDic objectForKey:@"name"];
      //  SelectedImageView.imageURL=[NSURL URLWithString:[ItemDetailDic objectForKey:@"image"]];
        [SelectedImageView loadImageFromURL:[NSURL URLWithString:[ItemDetailDic objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"defaultimage"] cachingKey:nil];
        self.ClosetIDd=[ItemDetailDic objectForKey:@"id"];
        self.ClosetInamed=[ItemDetailDic objectForKey:@"closetname"];
        IconImage=UIImagePNGRepresentation(SelectedImageView.image);
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}


-(NSString*)closetname
{
    NSString *newString=[[ItemDetailDic objectForKey:@"closetname"] substringToIndex:1];
    NSString *str=[ItemDetailDic objectForKey:@"closetname"];
    if (![newString isEqualToString:@" "] ) {
        str=[NSString stringWithFormat:@"  %@",[ItemDetailDic objectForKey:@"closetname"]];
    }
    return str;
}

-(void)GetAllClosets
{
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSMutableDictionary *Param=[NSMutableDictionary new];
        [Param setObject:[Utility UserID] forKey:@"fb_id"];
        [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
             Having=YES;
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                 [GCCacheSaver saveDictionary:Dic withName:@"newitem" inRelativePath:@"List"];
                ClosetnameArrray=[[Dic objectForKey:@"closet_names"] mutableCopy];
                ClosetIDArray=[[Dic objectForKey:@"closet_id"] mutableCopy];
               
            }
             if ([[Dic objectForKey:@"message"] isEqualToString:@"fail"]) {
                 [GCCacheSaver saveDictionary:Dic withName:@"newitem" inRelativePath:@"List"];
                 [ClosetnameArrray removeAllObjects];
                 [ClosetIDArray removeAllObjects];
             }
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        } Error:^{
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
}



-(void)OpenProfile:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}


-(IBAction)AddImage:(id)sender
{
    [self.view endEditing:YES];
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Choose Image" andMessage:nil];
    [alertView addButtonWithTitle:@"Take Photo"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              [self OpenCamer];
                          }];
    [alertView addButtonWithTitle:@"Choose Existing Photo"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              [self OpenGallery];
                          }];
    [alertView addButtonWithTitle:@"Cancel"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button3 Clicked");
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
}

-(void)OpenCamer
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

-(void)OpenGallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    
}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
//    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
//        SelectedImageView.image=info[UIImagePickerControllerOriginalImage];
//        SelectedImageView.backgroundColor=[UIColor blackColor];
//        IconImage=UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], -1.0);
//    }
//    else{
//// IconImage =UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
//    SelectedImageView.image=info[UIImagePickerControllerOriginalImage];
//    SelectedImageView.backgroundColor=[UIColor blackColor];
//    IconImage=UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], -1.0);
//    }
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        NSLog(@"%@",info[UIImagePickerControllerOriginalImage]);
        // IconImage=UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
        RKCropImageController *cropController = [[RKCropImageController alloc] initWithImage:info[UIImagePickerControllerOriginalImage] isYes:YES];
        cropController.delegate = self;
        [self presentViewController:cropController animated:YES completion:nil];
    }
    else{
        //IconImage =UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
        RKCropImageController *cropController = [[RKCropImageController alloc] initWithImage:info[UIImagePickerControllerOriginalImage] isYes:NO];
        cropController.delegate = self;
        [self presentViewController:cropController animated:YES completion:nil];
    }
    
}
-(void)cropImageViewControllerDidFinished:(UIImage *)image{
    SelectedImageView.image=image;
    IconImage=UIImageJPEGRepresentation(image, -1.0);
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(IBAction)SelectColor:(id)sender
{
    [self.view endEditing:YES];
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Black", @"Blue", @"Yellow", @"Red", @"Green", @"Orange", @"Purple", @"Grey",@"Bronze",@"Brown",@"Baby Blue",@"Chocolate",@"coffee",@"Cyan",@"Gold",@"Lemon",@"magenta",@"Maroon",@"Navy Blue",@"Orange-red",@"Peach",@"Pink",@"Purple",@"Raspberry",@"Rose",@"Silver",@"Violet",@"White",@"",nil];
    if(dropDown == nil) {
        CGFloat f = ((40*arr.count)<200)?40*arr.count:200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
        closetSelected=NO;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

-(IBAction)SelectType:(id)sender
{
    [self.view endEditing:YES];
    
    NSArray * arr = [[NSArray alloc] init];
    
    arr = [NSArray arrayWithObjects:@"Shoes", @"Top", @"Bottom",@"Dresses",nil];
    if(dropDown == nil) {
        CGFloat f =  ((40*arr.count)<200)?40*arr.count:200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
        closetSelected=NO;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

-(IBAction)SelectSize:(id)sender
{
    [self.view endEditing:YES];
    if ([TypeButton.currentTitle isEqualToString:@"  Type"]) {
        [self ShowAlertWithText:@"Select Type"];
        return;
    }
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    if ([TypeButton.currentTitle isEqualToString:@"  Dresses"]) {
        for (int i=0; i<21; i++) {
            if (i%2==0) {
                [arr addObject:[NSString stringWithFormat:@"%i",i]];
            }
        }
    }
    if ([TypeButton.currentTitle isEqualToString:@"  Top"]) {
        arr=[NSMutableArray arrayWithObjects: @"XS", @"S", @"M", @"L", @"XL", @"XXL", @"0", @"2", @"4", @"6", @"8",@"10", @"12", @"14", @"16", @"18", @"20+" , nil];
    }
    if ([TypeButton.currentTitle isEqualToString:@"  Shoes"]) {
        arr=[NSMutableArray arrayWithObjects:@"5.0", @"5.5",@"6.0", @"6.5", @"7.0", @"7.5",@"8.0", @"8.5", @"9.0", @"9.5",@"10.0", @"10.5", @"11.0", nil];
    }
    if ([TypeButton.currentTitle isEqualToString:@"  Bottom"]) {
        arr=[NSMutableArray arrayWithObjects: @"XS", @"S", @"M", @"L", @"XL", @"XXL", @"0", @"2", @"4", @"6", @"8",@"10", @"12", @"14", @"16", @"18", @"20+" , nil];
    }
    
    if(dropDown == nil) {
        CGFloat f =  ((40*arr.count)<200)?40*arr.count:200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
        closetSelected=NO;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

-(IBAction)SelectCloset:(id)sender
{
    
    [self.view endEditing:YES];
    
    if (!Having) {
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:nil message:@"Loading..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [Alert show];
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [Alert dismissWithClickedButtonIndex:0 animated:YES];
        });
        
    }
    else{
        if ([ClosetnameArrray count]==0) {
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"ShareWear" message:@"You do not have any closet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [Alert show];
        }
    }
    if(dropDown == nil) {
        CGFloat f =  ((40*ClosetnameArrray.count)<200)?40*ClosetnameArrray.count:200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :ClosetnameArrray :nil :@"down"];
        dropDown.delegate = self;
         closetSelected=YES;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender AtIndex:(NSInteger)index {
    if (closetSelected) {
        self.ClosetIDd=[ClosetIDArray objectAtIndex:index];
         self.ClosetInamed=[ClosetnameArrray objectAtIndex:index];
    }
    
    [self rel];
}

-(void)rel{
    dropDown = nil;
}
-(IBAction)BackPress:(id)sender
{
    if (EditingExisting) {
        [SlidingViewController Dissmissfrom:self];
    }
    else{
    UIStoryboard *Story=self.storyboard;
    MyClosetViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"mycloset"];
    [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
    }
   // [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)SavePressed:(id)sender
{
    [self.view endEditing:YES];
      if (IconImage==nil) {
        [self ShowAlertWithText:@"Add image"];
        return;
    }
   else if ([NametText.text length]==0) {
        [self ShowAlertWithText:@"Add Item name"];
        return;
    }
   else if ([ColorButton.currentTitle isEqualToString:@"  Color"]) {
        [self ShowAlertWithText:@"Add Color"];
        return;
    }
   else if ([TypeButton.currentTitle isEqualToString:@"  Type"]) {
       [self ShowAlertWithText:@"Add Type"];
       return;
   }
   else if ([SizeButton.currentTitle isEqualToString:@"  Size"]) {
        [self ShowAlertWithText:@"Add Size"];
        return;
    }
 
  else  if ([ClosetButton.currentTitle isEqualToString:@"  Closets"]) {
      if ([ClosetnameArrray count]==0) {
          UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"ShareWear" message:@"You do not have any closet to Add" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
          [Alert show];
      }
     else
     {
        [self ShowAlertWithText:@"Add Closet"];
     }
        return;
    }
//  else if (![ClosetButton.currentTitle isEqualToString:@"  Closets"])
//  {
//      
//  }
    else
    {
    NSString* RandonID=[NSString stringWithFormat:@"%i",arc4random()%7857];
    RandonID=[NSString stringWithFormat:@"%@%@",[self Unix],RandonID];
    [[GCHud Hud] showNormalHUD:@"Adding item"];
    NSMutableDictionary *Dic=[NSMutableDictionary new];
    [Dic setObject:self.ClosetIDd forKey:@"closet_id"];
    [Dic setObject:ColorButton.currentTitle forKey:@"color"];
    [Dic setObject:SizeButton.currentTitle forKey:@"size"];
    [Dic setObject:TypeButton.currentTitle forKey:@"type"];
    [Dic setObject:BrandText.text forKey:@"brand"];
    [Dic setObject:Descriptext.text forKey:@"description"];
    [Dic setObject:[Utility UserID] forKey:@"closet_owner_fb_id"];
    [Dic setObject:NametText.text forKey:@"item_name"];
    [Dic setObject:self.ClosetInamed forKey:@"closet_name"];
    if (EditingExisting) {
       [Dic setObject:[ItemDetailDic objectForKey:@"itemid"] forKey:@"item_id"];
    }
    else{
       [Dic setObject:RandonID forKey:@"item_id"];
    }
    [[ServerParsing server] PostWithImageAction:(EditingExisting)?@"http://vibrantappz.com/live/sw/edit_item_details.php?":@"http://vibrantappz.com/live/sw/add_item_controller.php?" WithParameter:Dic image:IconImage ImageKeyName:@"image_name" Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            
            if (!_IsNewItem) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshapi" object:nil];
            }
        }
        [[GCHud Hud] showSuccessHUD];
    } Error:^{
         [[GCHud Hud] showErrorHUD];
    }];
    if (!EditingExisting) {
        [[DBShared shared] saveNewaddeditemDetail:Dic ItemImage:IconImage Iscloset:NO Itemid:RandonID];
    }
     if (_IsNewItem) {
    [self.Create AddediTemImage:[UIImage imageWithData:IconImage]];
    [SlidingViewController Dissmissfrom:self];
     }
     else{
         
         [ColorButton setTitle:@"  Color" forState:UIControlStateNormal];
          [SizeButton setTitle:@"  Size" forState:UIControlStateNormal];
          [ClosetButton setTitle:@"  Closet" forState:UIControlStateNormal];
         [TypeButton setTitle:@"  Type" forState:UIControlStateNormal];
         BrandText.text=@"Brand";
         Descriptext.text=@"Description";
         NametText.text=@"Name";
         
         
         UIStoryboard *Story=self.storyboard;
         CreateClosetController *CenterView=[Story instantiateViewControllerWithIdentifier:@"create"];
         CenterView.Notrefresh=YES;
         [SlidingViewController PushFromViewController2:self CenterviewController:CenterView];
     }
    }
    IconImage=nil;
}
-(NSString *)Unix
{
    NSDate *date=[NSDate date];
    int startTime = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%i",startTime];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}
-(void)ShowAlertWithText:(NSString *)text
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ShearWear" message:text delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UtilityText textFieldDidBeginEditing:textField view:BaseView];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UtilityText textFieldDidEndEditing:textField view:BaseView];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UtilityText textFieldDidBeginEditing:textView view:BaseView];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UtilityText textFieldDidEndEditing:textView view:BaseView];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
