//
//  CreateNewClosetController.m
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "CreateNewClosetController.h"
#import "SIAlertView.h"
#import "ProfileViewController.h"
#import "AddFriendsViewController.h"
#import "SlidingViewController.h"
#import "UILabel+NavigationTitle.h"
#import "GCHud.h"
#import "NewItemController.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "GCCacheSaver.h"
//#import "EGOImageView.h"
#import "JGProgressHUD.h"
#import "UIViewController+JDSideMenu.h"
#import "CreateClosetController.h"
#import "DBShared.h"
#import "UIImageView+Network.h"
#import "Flurry.h"
@implementation CreateNewClosetController

- (void)viewDidLoad {
    [Flurry logEvent:@"CREATE NEW CLOSE SET VIEW"];
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
    
    ViewBut.hidden=YES;
    ItemImagesArray=[NSMutableArray new];
    [Utility SaveClosetid:nil];
    [UILabel SetTitle:(!self.EditCloset)?@"Create a Closet":@"Edit Closet" OnView:self];
    if (self.EditCloset) {
        self.PrivacyType=self.EditedPrivacy;
        IconImage=UIImageJPEGRepresentation(self.EditedImage, 1.0);
        ViewBut.hidden=NO;
        self.Closetname.text=self.EditedClosetname;
        [Utility SaveClosetid:self.ClosetID];
        [Utility SaveClosetname:self.Closetname.text];
        if ([self.EditedPrivacy isEqualToString:@"Open"]) {
            _OpenTick.selected=YES;
            _PrivacyType=@"Open";
            AdFriendsBut.enabled=NO;
        }
        else if ([self.EditedPrivacy isEqualToString:@"Close"]) {
            _CloseTick.selected=YES;
            _PrivacyType=@"Close";
            AdFriendsBut.enabled=YES;
        }
        else if ([self.EditedPrivacy isEqualToString:@"Secret"]) {
            _SecretTick.selected=YES;
            _PrivacyType=@"Secret";
            AdFriendsBut.enabled=YES;
        }
        NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"detail" inRelativePath:self.ClosetID];
        if (Dic) {
            if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
                
                ItemsIDArray=[[Dic objectForKey:@"item_ids"] mutableCopy];
                ItemsBrandArray=[[Dic objectForKey:@"brand_arr"] mutableCopy];
                ItemsColorArray=[[Dic objectForKey:@"color_arr"] mutableCopy];
                ItemsDecriptionArray=[[Dic objectForKey:@"description_arr"] mutableCopy];
                // ItemsimageArray=[Dic objectForKey:@"image_name_arr"];
                ItemImagesArray=[[Dic objectForKey:@"image_name_arr"] mutableCopy];
                ItemsSizeArray=[[Dic objectForKey:@"size_arr"] mutableCopy];
                ItemsStatusArray=[[Dic objectForKey:@"status_arr"] mutableCopy];
                ItemsTypeArray=[[Dic objectForKey:@"type_arr"] mutableCopy];
                ItemsOwnerIDArray=[Dic objectForKey:@"owner_id"];
                ObjectIDArray=[[Dic objectForKey:@"objectId"] mutableCopy];
                [self AddToImagesCollection];
            }
        }
        [self getMyallClosets];
    }
    else{
        _OpenTick.selected=YES;
        _PrivacyType=@"Open";
        AdFriendsBut.enabled=NO;
    }
   
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)getMyallClosets
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:self.ClosetID forKey:@"closet_id"];
   // NSString *Clost=self.ClosetID;
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/get_items.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
       // ClosetId=Clost;
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"detail" inRelativePath:self.ClosetID];
            ItemsIDArray=[[Dic objectForKey:@"item_ids"] mutableCopy];
            ItemsBrandArray=[[Dic objectForKey:@"brand_arr"] mutableCopy];
            ItemsColorArray=[[Dic objectForKey:@"color_arr"] mutableCopy];
            ItemsDecriptionArray=[[Dic objectForKey:@"description_arr"] mutableCopy];
           // ItemsimageArray=[Dic objectForKey:@"image_name_arr"];
            ItemImagesArray=[[Dic objectForKey:@"image_name_arr"] mutableCopy];
            ItemsSizeArray=[[Dic objectForKey:@"size_arr"] mutableCopy];
            ItemsStatusArray=[[Dic objectForKey:@"status_arr"] mutableCopy];
            ItemsTypeArray=[[Dic objectForKey:@"type_arr"] mutableCopy];
            ItemsOwnerIDArray=[Dic objectForKey:@"owner_id"];
             ObjectIDArray=[[Dic objectForKey:@"objectId"] mutableCopy];
            [self AddToImagesCollection];
        }
        if ([[Dic objectForKey:@"message"] isEqualToString:@"No item"]) {
            [GCCacheSaver saveDictionary:Dic withName:@"detail" inRelativePath:self.ClosetID];
            [ItemsIDArray removeAllObjects];
            [ItemsBrandArray removeAllObjects];
            [ItemsColorArray removeAllObjects];
            [ItemsDecriptionArray removeAllObjects];
            [ItemImagesArray removeAllObjects];
            [ItemsSizeArray removeAllObjects];
            [ItemsStatusArray removeAllObjects];
            [ItemsTypeArray removeAllObjects];
            ItemsOwnerIDArray=nil;
             [ObjectIDArray removeAllObjects];
            [self AddToImagesCollection];
            
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

-(void)BackPress:(id)sender
{
    [Utility SaveClosetid:nil];
    [Utility SaveClosetname:nil];
    [SlidingViewController Dissmissfrom:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}
-(IBAction)ChoosePrivacy:(id)sender
{
    switch ([sender tag]) {
        case 0:
             _OpenTick.selected=YES;
             _CloseTick.selected=NO;
             _SecretTick.selected=NO;
            _PrivacyType=@"Open";
            AdFriendsBut.enabled=NO;
            break;
        case 1:
            _OpenTick.selected=NO;
            _CloseTick.selected=YES;
            _SecretTick.selected=NO;
            _PrivacyType=@"Close";
            AdFriendsBut.enabled=YES;
            break;
        case 2:
            _OpenTick.selected=NO;
            _CloseTick.selected=NO;
            _SecretTick.selected=YES;
            _PrivacyType=@"Secret";
            AdFriendsBut.enabled=YES;
            break;
        default:
            break;
    }
    somethingchanged=YES;
}

-(IBAction)AddImage:(id)sender
{
    [self.view endEditing:YES];
    ForItems=NO;
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


-(IBAction)AddFriends:(id)sender
{
     [self.view endEditing:YES];
    if ([_Closetname.text length ]==0) {
        [self ShowAlertWithText:@"Enter Closet name"];
        return;
    }
    if (!IconImage) {
        [self ShowAlertWithText:@"Add closet icon"];
        return;
    }
    NSString *strId =[NSString stringWithFormat:@"%@",[Utility GetClosetID]];
    if ([Utility GetClosetID]) {
        if ([strId isEqualToString:@"(null)"]) {
            [self CreateCloset:2];
            return;
        }
        [self AddFriend:[Utility GetClosetID] Name:[Utility GetClosetname]];
    }
    else{
       [self CreateCloset:2];
    }
}

-(void)AddFriend:(NSString *)cid Name:(NSString *)cname
{
    UIStoryboard *Story=self.storyboard;
    AddFriendsViewController *CenterView=[Story instantiateViewControllerWithIdentifier:@"addfriend"];
    CenterView.ClosetIDs=cid;
    CenterView.IDCloset=cid;
    CenterView.fromcloset=YES;
    CenterView.ClosetName=cname;
    CenterView.Backhidden=NO;
    [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}

-(IBAction)AddItems:(id)sender
{
     [self.view endEditing:YES];
    if ([_Closetname.text length ]==0) {
        [self ShowAlertWithText:@"Enter Closet name"];
        return;
    }
    if (!IconImage) {
        [self ShowAlertWithText:@"Add closet icon"];
        return;
    }
    if ([Utility GetClosetID]) {
        NSLog(@"hle %@",[Utility GetClosetID]);
        NSString *strId =[NSString stringWithFormat:@"%@",[Utility GetClosetID]];
        if ([strId isEqualToString:@"(null)"]) {
            [self CreateCloset:1];
            return;
        }
        [self AddNew:[Utility GetClosetID] Name:[Utility GetClosetname]];
    }
    else{
        [self CreateCloset:1];
    }
}


-(void)AddNew:(NSString *)cid Name:(NSString *)cname
{
    UIStoryboard *Story=self.storyboard;
    NewItemController *CenterView=[Story instantiateViewControllerWithIdentifier:@"newitem"];
    [CenterView setCreate:self];
    CenterView.IsNewItem=YES;
    CenterView.ClosetIDd=cid;
    CenterView.ClosetInamed=cname;
    EditingExisting=NO;
     [SlidingViewController PushFromViewController3:self CenterviewController:CenterView];
}

-(void)OpenCamer
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}


-(void)OpenGallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
   // picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)AddediTemImage:(UIImage *)image
{
    somethingchanged=NO;
    [ItemImagesArray addObject:image];
    [self AddToImagesCollection];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    ViewBut.hidden=NO;
    somethingchanged=YES;
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
    IconImage=UIImageJPEGRepresentation(image, -1.0);
}

-(IBAction)ViewImage:(id)sender
{
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = [UIImage imageWithData:IconImage];
    //imageInfo.referenceRect = cell.closetimage.frame;
    //imageInfo.referenceView = cell.closetimage.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)AddToImagesCollection
{
    for (UIImageView *img in Scroll.subviews) {
        [img removeFromSuperview];
    }
    int xCoord=30;
    int yCoord=0;
    int Width=120;
    int Height=180;
    int buffer = 18;
    for (int i=1; i<=ItemImagesArray.count; i++) {
        UIImageView *ItemImage=[[UIImageView alloc]init];
        ItemImage.frame=CGRectMake(xCoord, yCoord, Width, Height);
        if ([[ItemImagesArray objectAtIndex:i-1] isKindOfClass:[UIImage class]]) {
            ItemImage.image=[ItemImagesArray objectAtIndex:i-1];
        }
        else{

            [ItemImage loadImageFromURL:[NSURL URLWithString:[ItemImagesArray objectAtIndex:i-1]] placeholderImage:[UIImage imageNamed:@""] cachingKey:nil];
            UIButton *Delete=[UIButton buttonWithType:UIButtonTypeCustom];
            [Delete setImage:[UIImage imageNamed:@"Delete.png"] forState:UIControlStateNormal];
            Delete.frame=CGRectMake(ItemImage.frame.size.width-20, 0, 30, 30);
            [Delete addTarget:self action:@selector(Deleteitem:) forControlEvents:UIControlEventTouchUpInside];
            Delete.tag=i;
            [ItemImage addSubview:Delete];
            
        }
        ItemImage.userInteractionEnabled=YES;
        ItemImage.contentMode=UIViewContentModeScaleAspectFit;
        ItemImage.backgroundColor=[UIColor blackColor];
        [Scroll addSubview:ItemImage];
        xCoord += Width + buffer;
    }
    [Scroll setContentSize:CGSizeMake(xCoord, 0)];
}

-(void)Deleteitem:(UIButton *)sender
{
    JGProgressHUD*  Hud=  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [Hud showInView:self.view];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[ObjectIDArray objectAtIndex:[sender tag]-1] forKey:@"objectId"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/delete_item.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [Utility SaveClosetid:nil];
           // [self dismissViewControllerAnimated:YES completion:nil];
            [ItemsIDArray removeObjectAtIndex:[sender tag]-1];
            [ItemsBrandArray removeObjectAtIndex:[sender tag]-1];
            [ItemsColorArray removeObjectAtIndex:[sender tag]-1];
            [ItemsDecriptionArray removeObjectAtIndex:[sender tag]-1];
            // ItemsimageArray=[Dic objectForKey:@"image_name_arr"];
            [ItemImagesArray removeObjectAtIndex:[sender tag]-1];
            [ItemsSizeArray removeObjectAtIndex:[sender tag]-1];
            [ItemsStatusArray removeObjectAtIndex:[sender tag]-1];
            [ItemsTypeArray removeObjectAtIndex:[sender tag]-1];
            //ItemsOwnerIDArray=[Dic objectForKey:@"owner_id"];
            [ObjectIDArray removeObjectAtIndex:[sender tag]-1];
            [self AddToImagesCollection];
            
        }
        [Hud dismiss];
    } Error:^{
        [Hud dismiss];
    }];
}


-(IBAction)DonePressed:(id)sender
{
    if ([Utility GetClosetID]) {
        
        if (self.EditCloset) {
        if (somethingchanged) {
             [self CreateCloset:0];
            [SlidingViewController Dissmissfrom:self];
            return;
        }
        }
        [Utility SaveClosetid:nil];
        if (!self.EditCloset) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ShareWear" message:@"Congratulations you have created your closet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        }
        [SlidingViewController Dissmissfrom:self];
    }
    else{
        [self CreateCloset:0];
    }
   //
}


-(void)CreateCloset:(NSInteger)additem
{
   
    if ([_Closetname.text length ]==0) {
        [self ShowAlertWithText:@"Enter Closet name"];
        return;
    }
    if (!IconImage) {
        [self ShowAlertWithText:@"Add closet icon"];
        return;
    }
    NSString* RandonID=[NSString stringWithFormat:@"%i",arc4random()%7857];
    RandonID=[NSString stringWithFormat:@"%@%@",[self Unix],RandonID];
     NSString *strId =[NSString stringWithFormat:@"%@",[Utility GetClosetID]];
    //http://www.platinuminfosys.org/parse/parse.com-php-library-master/add_closet_controller.php?closet_name=closet1&closet_icon=gggg&privacy_type=2&fb_id=54654654654654&fb_name=hhhhhhh
    [[GCHud Hud] showNormalHUD:@"Saving"];
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:_Closetname.text forKey:@"closet_name"];
    [Param setObject:_PrivacyType forKey:@"privacy_type"];
    if (self.EditCloset) {
       [Param setObject:self.ClosetID forKey:@"closet_id"];
    }
    else{
        [Param setObject:[Utility UserID] forKey:@"fb_id"];
        if ([strId isEqualToString:@"(null)"]) {
            [Param setObject:RandonID forKey:@"closet_id"];
        }
        else{
           [Param setObject:self.ClosetID forKey:@"closet_id"];
        }

        
        [Param setObject:[Utility UserName] forKey:@"fb_name"];
    }
    
    NSString *Cname=_Closetname.text;
    NSString *PostUrl=(self.EditCloset)?@"http://vibrantappz.com/live/sw/edit_closet_details.php?":@"http://vibrantappz.com/live/sw/add_closet_controller.php?";
    [[ServerParsing server] PostWithImageAction:PostUrl WithParameter:Param image:IconImage ImageKeyName:@"closet_icon" Success:^(NSMutableDictionary *Dic) {
         NSLog(@"%@",Dic);
        somethingchanged=NO;
        [Utility SaveClosetid:[Dic objectForKey:@"closet_id"]];
        [Utility SaveClosetname:Cname];
        [[GCHud Hud] showSuccessHUD];
        if (additem==1) {
            [self AddNew:[Dic objectForKey:@"closet_id"] Name:Cname];
        }else if(additem==2)
        {
            [self AddFriend:[Dic objectForKey:@"closet_id"] Name:[Utility GetClosetname]];
        }
        else{
            
        }
    } Error:^{
         [[GCHud Hud] showErrorHUD];
    }];
    
    if (additem==0) {
        if (!self.EditCloset) {
            if ([strId isEqualToString:@"(null)"]) {
            [[DBShared shared] saveNewaddeditemDetail:Param ItemImage:IconImage Iscloset:YES Itemid:RandonID];
            }
            else
            {
            [[DBShared shared] saveNewaddeditemDetail:Param ItemImage:IconImage Iscloset:YES Itemid:self.ClosetID];
            }
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ShareWear" message:@"Congratulations you have created your closet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
       
    }
    //IconImage=nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIStoryboard *Story=self.storyboard;
    CreateClosetController *CenterView=[Story instantiateViewControllerWithIdentifier:@"create"];
    [SlidingViewController PushFromViewController2:self CenterviewController:CenterView];
   // [SlidingViewController Dissmissfrom:self];
}
-(IBAction)CancelPressed:(id)sender
{
   
    if ([Utility GetClosetID]) {
        [self DeleteCloset];
    }
    else{
        [Utility SaveClosetid:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)DeleteCloset
{
    NSMutableDictionary *Param=[NSMutableDictionary new];
    [Param setObject:[Utility GetClosetID] forKey:@"closet_id"];
    [[ServerParsing server] RequestPostAction:@"http://vibrantappz.com/live/sw/delete_closet.php?" WithParameter:Param Success:^(NSMutableDictionary *Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            [Utility SaveClosetid:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } Error:^{
        
    }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    somethingchanged=YES;
}
-(void)ShowAlertWithText:(NSString *)text
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ShearWear" message:text delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
-(NSString *)Unix
{
    NSDate *date=[NSDate date];
    int startTime = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%i",startTime];
}
@end
