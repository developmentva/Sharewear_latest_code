//
//  DBShared.m
//  ShareWear
//
//  Created by Apple on 20/11/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "DBShared.h"
#import "GCCacheSaver.h"
#import "Utility.h"
DBShared *DB;
@implementation DBShared
+(DBShared *)shared
{
    if (DB==nil) {
        DB=[[DBShared alloc] init];
    }
    return DB;
}

NSString *RandonID;
-(void)saveNewaddeditemDetail:(NSMutableDictionary *)param ItemImage:(NSData *)imgdata Iscloset:(BOOL)closet Itemid:(NSString *)RID
{
    RandonID=RID;
    NSMutableArray *TimeStampArray;
    NSMutableArray *NotificationArray;
    NSMutableArray *OwnerIdArray;
    NSMutableArray *ItemsArray;
    NSMutableArray *TypeArray;
    NSMutableArray *LikeArray;
    NSMutableArray *UserDetailArray;
    NSMutableArray *FirstpartArray;
    NSMutableArray *LastPartArray;
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"feeds" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
        TimeStampArray=[[Dic objectForKey:@"time_stamp"] mutableCopy];
        NotificationArray=[[Dic objectForKey:@"notification"] mutableCopy];
        OwnerIdArray=[[Dic objectForKey:@"owner"] mutableCopy];
        ItemsArray=[[Dic objectForKey:@"item_detail"] mutableCopy];
        TypeArray=[[Dic objectForKey:@"type"] mutableCopy];
        LikeArray=[[Dic objectForKey:@"liked"] mutableCopy];
        UserDetailArray=[[Dic objectForKey:@"user_detail"] mutableCopy];
        FirstpartArray=[[Dic objectForKey:@"first_part"] mutableCopy];
        LastPartArray=[[Dic objectForKey:@"last_part"] mutableCopy];
        }
        else{
            TimeStampArray=[NSMutableArray new];
            NotificationArray=[NSMutableArray new];
            OwnerIdArray=[NSMutableArray new];
            ItemsArray=[NSMutableArray new];
            TypeArray=[NSMutableArray new];
            LikeArray=[NSMutableArray new];
            UserDetailArray=[NSMutableArray new];
            FirstpartArray=[NSMutableArray new];
            LastPartArray=[NSMutableArray new];
        }
    }
    else{
        TimeStampArray=[NSMutableArray new];
        NotificationArray=[NSMutableArray new];
        OwnerIdArray=[NSMutableArray new];
        ItemsArray=[NSMutableArray new];
        TypeArray=[NSMutableArray new];
        LikeArray=[NSMutableArray new];
        UserDetailArray=[NSMutableArray new];
        FirstpartArray=[NSMutableArray new];
        LastPartArray=[NSMutableArray new];
    }
    [TimeStampArray addObject:[self Unix]];
    [NotificationArray addObject:(closet)?@"added by":@"has been added to"];
    [OwnerIdArray addObject:[Utility UserID]];
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:(closet)?@"brand":[param objectForKey:@"brand"] forKey:@"brand"];
    [dic setObject:(closet)?@"closet_detail":[param objectForKey:@"closet_name"] forKey:@"closet_detail"];
    [dic setObject:(closet)?RandonID:[param objectForKey:@"closet_id"] forKey:@"closet_id"];
    [dic setObject:(closet)?@"color":[param objectForKey:@"color"] forKey:@"color"];
    [dic setObject:(closet)?[param objectForKey:@"closet_name"]:[param objectForKey:@"description"] forKey:@"desc"];
    [dic setObject:RandonID forKey:@"id"];
    [dic setObject:imgdata forKey:@"image_name"];
    [dic setObject:(closet)?@"size":[param objectForKey:@"size"] forKey:@"size"];
    [dic setObject:(closet)?@"empty":@"1" forKey:@"status"];
    [ItemsArray addObject:dic];
    [TypeArray addObject:(closet)?@"closet":@"item"];
    [LikeArray addObject:@"0"];
    dic=[NSMutableDictionary new];
    [dic setObject:@"image_name" forKey:@"image_name"];
    [dic setObject:@"username" forKey:@"username"];
    [UserDetailArray addObject:dic];
    [FirstpartArray addObject:(closet)?[param objectForKey:@"closet_name"]:[param objectForKey:@"item_name"]];
    [LastPartArray addObject:(closet)?[Utility UserName]:[param objectForKey:@"closet_name"]];
    
    dic=[NSMutableDictionary new];
    [dic setObject:TimeStampArray forKey:@"time_stamp"];
    [dic setObject:NotificationArray forKey:@"notification"];
    [dic setObject:OwnerIdArray forKey:@"owner"];
    [dic setObject:ItemsArray forKey:@"item_detail"];
    [dic setObject:TypeArray forKey:@"type"];
    [dic setObject:LikeArray forKey:@"liked"];
    [dic setObject:UserDetailArray forKey:@"user_detail"];
    [dic setObject:FirstpartArray forKey:@"first_part"];
    [dic setObject:LastPartArray forKey:@"last_part"];
    [dic setObject:@"success" forKey:@"message"];
    [GCCacheSaver saveDictionary:dic withName:@"feeds" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    [self saveHistoryDetail:param ItemImage:imgdata Iscloset:closet];
    if (closet) {
        [self Saveclosetdetail:param Itemimage:imgdata];
        [self SaveClosetitem:param withimage:imgdata];
        [self savemyClosetsdetail:param withimage:imgdata];
    }
    else{
    [self SaveTomyitems:param Itemimage:imgdata];
    }
}
-(void)saveHistoryDetail:(NSMutableDictionary *)param ItemImage:(NSData *)imgdata Iscloset:(BOOL)closet
{
    NSMutableArray *TimeStampArray;
    NSMutableArray *NotificationArray;
    NSMutableArray *OwnerIdArray;
    NSMutableArray *ItemsArray;
    NSMutableArray *TypeArray;
    NSMutableArray *LikeArray;
    //NSMutableArray *UserDetailArray;
  //  NSMutableArray *FirstpartArray;
   // NSMutableArray *LastPartArray;
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"History" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            TimeStampArray=[[Dic objectForKey:@"time_stamp"] mutableCopy];
            NotificationArray=[[Dic objectForKey:@"notification"] mutableCopy];
            OwnerIdArray=[[Dic objectForKey:@"owner"] mutableCopy];
            ItemsArray=[[Dic objectForKey:@"item_detail"] mutableCopy];
            TypeArray=[[Dic objectForKey:@"type"] mutableCopy];
            LikeArray=[[Dic objectForKey:@"liked"] mutableCopy];
           // UserDetailArray=[[Dic objectForKey:@"user_detail"] mutableCopy];
           // FirstpartArray=[[Dic objectForKey:@"first_part"] mutableCopy];
           // LastPartArray=[[Dic objectForKey:@"last_part"] mutableCopy];
        }
        else{
            TimeStampArray=[NSMutableArray new];
            NotificationArray=[NSMutableArray new];
            OwnerIdArray=[NSMutableArray new];
            ItemsArray=[NSMutableArray new];
            TypeArray=[NSMutableArray new];
            LikeArray=[NSMutableArray new];
           // UserDetailArray=[NSMutableArray new];
            //FirstpartArray=[NSMutableArray new];
            //LastPartArray=[NSMutableArray new];
        }
    }
    else{
        TimeStampArray=[NSMutableArray new];
        NotificationArray=[NSMutableArray new];
        OwnerIdArray=[NSMutableArray new];
        ItemsArray=[NSMutableArray new];
        TypeArray=[NSMutableArray new];
        LikeArray=[NSMutableArray new];
        //UserDetailArray=[NSMutableArray new];
       // FirstpartArray=[NSMutableArray new];
       // LastPartArray=[NSMutableArray new];
    }
    RandonID=[NSString stringWithFormat:@"%i",arc4random()%7857858];
    [TimeStampArray addObject:[self Unix]];
    [NotificationArray addObject:(closet)?[NSString stringWithFormat:@"%@ added by %@",[param objectForKey:@"closet_name"],[Utility UserName]]:[NSString stringWithFormat:@"%@ has been added to %@",[param objectForKey:@"item_name"],[param objectForKey:@"closet_name"]]];
    [OwnerIdArray addObject:[Utility UserID]];
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:(closet)?@"brand":[param objectForKey:@"brand"] forKey:@"brand"];
    [dic setObject:(closet)?@"closet_detail":[param objectForKey:@"closet_name"] forKey:@"closet_detail"];
    [dic setObject:(closet)?RandonID:[param objectForKey:@"closet_id"] forKey:@"closet_id"];
    [dic setObject:(closet)?@"color":[param objectForKey:@"color"] forKey:@"color"];
    [dic setObject:(closet)?[param objectForKey:@"closet_name"]:[param objectForKey:@"description"] forKey:@"desc"];
    [dic setObject:RandonID forKey:@"id"];
    [dic setObject:imgdata forKey:@"image_name"];
    [dic setObject:(closet)?@"size":[param objectForKey:@"size"] forKey:@"size"];
    [dic setObject:(closet)?@"empty":@"1" forKey:@"status"];
    [ItemsArray addObject:dic];
    [TypeArray addObject:(closet)?@"closet":@"item"];
    [LikeArray addObject:@"0"];
//    dic=[NSMutableDictionary new];
//    [dic setObject:@"image_name" forKey:@"image_name"];
//    [dic setObject:@"username" forKey:@"username"];
//    [UserDetailArray addObject:dic];
   // [FirstpartArray addObject:(closet)?[param objectForKey:@"closet_name"]:[param objectForKey:@"item_name"]];
    //[LastPartArray addObject:(closet)?[Utility UserName]:[param objectForKey:@"closet_name"]];
    
    dic=[NSMutableDictionary new];
    [dic setObject:TimeStampArray forKey:@"time_stamp"];
    [dic setObject:NotificationArray forKey:@"notification"];
    [dic setObject:OwnerIdArray forKey:@"owner"];
    [dic setObject:ItemsArray forKey:@"item_detail"];
    [dic setObject:TypeArray forKey:@"type"];
    [dic setObject:LikeArray forKey:@"liked"];
   // [dic setObject:UserDetailArray forKey:@"user_detail"];
   // [dic setObject:FirstpartArray forKey:@"first_part"];
   // [dic setObject:LastPartArray forKey:@"last_part"];
    [dic setObject:@"success" forKey:@"message"];
    [GCCacheSaver saveDictionary:dic withName:@"History" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
}

-(void)Saveclosetdetail:(NSMutableDictionary *)param Itemimage:(NSData *)imgdat
{
    NSMutableArray *ClosetNameArray;
    NSMutableArray *ClosetIdArray;
    NSMutableArray *ClosetIconArray;
    NSMutableArray *ClosetStatusArray;
    NSMutableArray *ClosetPrivacyArray;
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"closet" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            ClosetNameArray=[[Dic objectForKey:@"closet_names"] mutableCopy];
            ClosetIdArray=[[Dic objectForKey:@"closet_id"] mutableCopy];
            ClosetIconArray=[[Dic objectForKey:@"closet_icon"] mutableCopy];
            ClosetStatusArray=[[Dic objectForKey:@"status"] mutableCopy];
            ClosetPrivacyArray=[[Dic objectForKey:@"privacy_type"] mutableCopy];
        }
        else{
            ClosetNameArray=[NSMutableArray new];
            ClosetIdArray=[NSMutableArray new];
            ClosetIconArray=[NSMutableArray new];
            ClosetStatusArray=[NSMutableArray new];
            ClosetPrivacyArray=[NSMutableArray new];
        }
    }
    else{
        ClosetNameArray=[NSMutableArray new];
        ClosetIdArray=[NSMutableArray new];
        ClosetIconArray=[NSMutableArray new];
        ClosetStatusArray=[NSMutableArray new];
        ClosetPrivacyArray=[NSMutableArray new];
    }
    [ClosetNameArray addObject:[param objectForKey:@"closet_name"]];
    [ClosetIdArray addObject:RandonID];
    [ClosetIconArray addObject:imgdat];
    [ClosetStatusArray addObject:@"1"];
    [ClosetPrivacyArray addObject:[param objectForKey:@"privacy_type"]];
    
    NSMutableDictionary* dic=[NSMutableDictionary new];
    [dic setObject:ClosetNameArray forKey:@"closet_names"];
    [dic setObject:ClosetIdArray forKey:@"closet_id"];
    [dic setObject:ClosetIconArray forKey:@"closet_icon"];
    [dic setObject:ClosetStatusArray forKey:@"status"];
    [dic setObject:ClosetPrivacyArray forKey:@"privacy_type"];
    [dic setObject:@"success" forKey:@"message"];
    [GCCacheSaver saveDictionary:dic withName:@"closet" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
}

-(void)SaveTomyitems:(NSMutableDictionary *)param Itemimage:(NSData *)imgdata
{
    NSMutableArray *MyItemsIdArray;
    NSMutableArray *MyItemsArray;
    NSMutableArray *MyItemsBrandArray;
    NSMutableArray *MyItemsColorArray;
    NSMutableArray *MyItemsDecripArray;
    NSMutableArray *MyItemsImageArray;
    NSMutableArray *MyItemsSizeArray;
    NSMutableArray *MyItemsStatusArray;
    NSMutableArray *MyItemsTypeArray;
    NSMutableArray *MyClosetIDArray;
    NSMutableArray *MyClosetNameArray;
    NSMutableArray *MyObjectIDArray;
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"items" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            MyItemsIdArray=[[Dic objectForKey:@"item_ids"] mutableCopy];
            MyItemsArray=[[Dic objectForKey:@"name"] mutableCopy];
            MyItemsBrandArray=[[Dic objectForKey:@"brand_arr"] mutableCopy];
            MyItemsColorArray=[[Dic objectForKey:@"color_arr"] mutableCopy];
            MyItemsDecripArray=[[Dic objectForKey:@"description_arr"] mutableCopy];
            MyItemsImageArray=[[Dic objectForKey:@"image_name_arr"] mutableCopy];
            MyItemsSizeArray=[[Dic objectForKey:@"size_arr"] mutableCopy];
            MyItemsStatusArray=[[Dic objectForKey:@"status_arr"] mutableCopy];
            MyItemsTypeArray=[[Dic objectForKey:@"type_arr"] mutableCopy];
            MyClosetIDArray=[[Dic objectForKey:@"closet_ids"] mutableCopy];
            MyClosetNameArray=[[Dic objectForKey:@"closet_name"] mutableCopy];
            MyObjectIDArray=[[Dic objectForKey:@"objectId"] mutableCopy];
        }
        else{
            MyItemsIdArray=[NSMutableArray new];;
            MyItemsArray=[NSMutableArray new];;
            MyItemsBrandArray=[NSMutableArray new];;
            MyItemsColorArray=[NSMutableArray new];;
            MyItemsDecripArray=[NSMutableArray new];;
            MyItemsImageArray=[NSMutableArray new];;
            MyItemsSizeArray=[NSMutableArray new];;
            MyItemsStatusArray=[NSMutableArray new];;
            MyItemsTypeArray=[NSMutableArray new];;
            MyClosetIDArray=[NSMutableArray new];;
            MyClosetNameArray=[NSMutableArray new];;
            MyObjectIDArray=[NSMutableArray new];;
        }
    }
    else{
        MyItemsIdArray=[NSMutableArray new];;
        MyItemsArray=[NSMutableArray new];;
        MyItemsBrandArray=[NSMutableArray new];;
        MyItemsColorArray=[NSMutableArray new];;
        MyItemsDecripArray=[NSMutableArray new];;
        MyItemsImageArray=[NSMutableArray new];;
        MyItemsSizeArray=[NSMutableArray new];;
        MyItemsStatusArray=[NSMutableArray new];;
        MyItemsTypeArray=[NSMutableArray new];;
        MyClosetIDArray=[NSMutableArray new];;
        MyClosetNameArray=[NSMutableArray new];;
        MyObjectIDArray=[NSMutableArray new];;
    }
    [MyItemsIdArray addObject:RandonID];
    [MyItemsArray addObject:[param objectForKey:@"item_name"]];
    [MyItemsBrandArray addObject:[param objectForKey:@"brand"]];
    [MyItemsColorArray addObject:[param objectForKey:@"color"]];
    [MyItemsDecripArray addObject:[param objectForKey:@"description"]];
    [MyItemsImageArray addObject:imgdata];
    [MyItemsSizeArray addObject:[param objectForKey:@"size"]];
    [MyItemsStatusArray addObject:@"1"];
    [MyItemsTypeArray addObject:@"item"];
    [MyClosetIDArray addObject:[param objectForKey:@"closet_id"]];
    [MyClosetNameArray addObject:[param objectForKey:@"closet_name"]];
    [MyObjectIDArray addObject:RandonID];
    
    NSMutableDictionary* dic=[NSMutableDictionary new];
    [dic setObject:MyItemsIdArray forKey:@"item_ids"];
    [dic setObject:MyItemsArray forKey:@"name"];
    [dic setObject:MyItemsBrandArray forKey:@"brand_arr"];
    [dic setObject:MyItemsColorArray forKey:@"color_arr"];
    [dic setObject:MyItemsDecripArray forKey:@"description_arr"];
    [dic setObject:MyItemsImageArray forKey:@"image_name_arr"];
    [dic setObject:MyItemsSizeArray forKey:@"size_arr"];
    [dic setObject:MyItemsStatusArray forKey:@"status_arr"];
    [dic setObject:MyItemsTypeArray forKey:@"type_arr"];
    [dic setObject:MyClosetIDArray forKey:@"closet_ids"];
    [dic setObject:MyClosetNameArray forKey:@"closet_name"];
    [dic setObject:MyObjectIDArray forKey:@"objectId"];
    [dic setObject:@"success" forKey:@"message"];
     [GCCacheSaver saveDictionary:dic withName:@"items" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    [self SaveClosetitem:param withimage:imgdata];
    
}

-(void)SaveClosetitem:(NSMutableDictionary *)param withimage:(NSData *)imgdata
{
    NSMutableArray *ItemsIDArray;
    NSMutableArray *ItemsBrandArray;
    NSMutableArray *ItemsColorArray;
    NSMutableArray *ItemsDecriptionArray;
    NSMutableArray *ItemsimageArray;
    NSMutableArray *ItemsSizeArray;
    NSMutableArray *ItemsStatusArray;
    NSMutableArray *ItemsTypeArray;
    NSString *ItemsOwnerIDArray;
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"detail" inRelativePath:[param objectForKey:@"closet_id"]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            ItemsIDArray=[[Dic objectForKey:@"item_ids"] mutableCopy];
            ItemsBrandArray=[[Dic objectForKey:@"brand_arr"] mutableCopy];
            ItemsColorArray=[[Dic objectForKey:@"color_arr"] mutableCopy];
            ItemsDecriptionArray=[[Dic objectForKey:@"description_arr"] mutableCopy];
            ItemsimageArray=[[Dic objectForKey:@"image_name_arr"] mutableCopy];
            ItemsSizeArray=[[Dic objectForKey:@"size_arr"] mutableCopy];
            ItemsStatusArray=[[Dic objectForKey:@"status_arr"] mutableCopy];
            ItemsTypeArray=[[Dic objectForKey:@"type_arr"] mutableCopy];
            ItemsOwnerIDArray=[[Dic objectForKey:@"owner_id"] mutableCopy];
        }
        else{
            ItemsIDArray=[NSMutableArray new];;
            ItemsBrandArray=[NSMutableArray new];;
            ItemsColorArray=[NSMutableArray new];;
            ItemsDecriptionArray=[NSMutableArray new];;
            ItemsimageArray=[NSMutableArray new];;
            ItemsSizeArray=[NSMutableArray new];;
            ItemsStatusArray=[NSMutableArray new];;
            ItemsTypeArray=[NSMutableArray new];;
           // ItemsOwnerIDArray=[NSMutableArray new];;

        }
    }
    else{
        ItemsIDArray=[NSMutableArray new];;
        ItemsBrandArray=[NSMutableArray new];;
        ItemsColorArray=[NSMutableArray new];;
        ItemsDecriptionArray=[NSMutableArray new];;
        ItemsimageArray=[NSMutableArray new];;
        ItemsSizeArray=[NSMutableArray new];;
        ItemsStatusArray=[NSMutableArray new];;
        ItemsTypeArray=[NSMutableArray new];;
        //ItemsOwnerIDArray=[NSMutableArray new];;
    }
    [ItemsIDArray addObject:RandonID];
    [ItemsBrandArray addObject:@"brand"];
    [ItemsColorArray addObject:@"color"];
    [ItemsDecriptionArray addObject:@"descrip"];
    [ItemsimageArray addObject:imgdata];
    [ItemsSizeArray addObject:@"size"];
    [ItemsStatusArray addObject:@"1"];
    [ItemsTypeArray addObject:@"item"];
    ItemsOwnerIDArray =[Utility UserID];
    
    NSMutableDictionary* dic=[NSMutableDictionary new];
    [dic setObject:ItemsIDArray forKey:@"item_ids"];
    [dic setObject:ItemsBrandArray forKey:@"name"];
    [dic setObject:ItemsColorArray forKey:@"brand_arr"];
    [dic setObject:ItemsDecriptionArray forKey:@"color_arr"];
    [dic setObject:ItemsimageArray forKey:@"description_arr"];
    [dic setObject:ItemsSizeArray forKey:@"image_name_arr"];
    [dic setObject:ItemsStatusArray forKey:@"size_arr"];
    [dic setObject:ItemsTypeArray forKey:@"status_arr"];
    [dic setObject:ItemsOwnerIDArray forKey:@"owner_id"];
    [dic setObject:@"success" forKey:@"message"];
     [GCCacheSaver saveDictionary:dic withName:@"detail" inRelativePath:RandonID];
}

-(void)savemyClosetsdetail:(NSMutableDictionary *)param withimage:(NSData *)imgdata
{
    NSMutableArray *ClosetnameArrray;
    NSMutableArray *ClosetIDArray;
    NSMutableArray *ClosetImageArray;
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"newitem" inRelativePath:@"List"];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            ClosetnameArrray=[[Dic objectForKey:@"closet_names"] mutableCopy];
            ClosetIDArray=[[Dic objectForKey:@"closet_id"] mutableCopy];
            ClosetImageArray=[[Dic objectForKey:@"closet_icon"] mutableCopy];
        }
        else{
            ClosetnameArrray=[NSMutableArray new];;
            ClosetIDArray=[NSMutableArray new];;
            ClosetImageArray=[NSMutableArray new];;
        }
    }
    else{
            ClosetnameArrray=[NSMutableArray new];;
            ClosetIDArray=[NSMutableArray new];;
            ClosetImageArray=[NSMutableArray new];;
    }
    NSString *name=[NSString stringWithFormat:@"%@",[param objectForKey:@"closet_name"]];
    [ClosetnameArrray addObject:name];
    [ClosetIDArray addObject:RandonID];
    [ClosetImageArray addObject:imgdata];
    
    NSMutableDictionary* dic=[NSMutableDictionary new];
    [dic setObject:ClosetnameArrray forKey:@"closet_names"];
    [dic setObject:ClosetIDArray forKey:@"closet_id"];
    [dic setObject:ClosetImageArray forKey:@"closet_icon"];
    [dic setObject:@"success" forKey:@"message"];
    [GCCacheSaver saveDictionary:dic withName:@"newitem" inRelativePath:@"List"];
    
}

-(void)savemylikes:(NSMutableDictionary *)param Itemid:(NSString *)iid
{
    
    NSMutableArray *iTemArray;
    NSMutableArray *iTemIDArray;
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"likes" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            iTemArray=[[Dic objectForKey:@"items"] mutableCopy];
            iTemIDArray=[[Dic objectForKey:@"ids"] mutableCopy];
        }
        else{
            iTemArray=[NSMutableArray new];;
            iTemIDArray=[NSMutableArray new];;
        }
    }
    else{
        iTemArray=[NSMutableArray new];;
        iTemIDArray=[NSMutableArray new];;
    }
    [iTemArray addObject:param];
    [iTemIDArray addObject:iid];
    
    NSMutableDictionary* dic=[NSMutableDictionary new];
    [dic setObject:iTemArray forKey:@"items"];
    [dic setObject:iTemIDArray forKey:@"ids"];
    [dic setObject:@"success" forKey:@"message"];
    [GCCacheSaver saveDictionary:dic withName:@"likes" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
}

-(void)SaveLikeAtindex:(NSString * )closetid Condition:(BOOL)liked
{
    NSMutableArray *TimeStampArray;
    NSMutableArray *NotificationArray;
    NSMutableArray *OwnerIdArray;
    NSMutableArray *ItemsArray;
    NSMutableArray *TypeArray;
    NSMutableArray *LikeArray;
    NSMutableArray *UserDetailArray;
    NSMutableArray *FirstpartArray;
    NSMutableArray *LastPartArray;
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"feeds" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        TimeStampArray=[[Dic objectForKey:@"time_stamp"] mutableCopy];
        NotificationArray=[[Dic objectForKey:@"notification"] mutableCopy];
        OwnerIdArray=[[Dic objectForKey:@"owner"] mutableCopy];
        ItemsArray=[[Dic objectForKey:@"item_detail"] mutableCopy];
        TypeArray=[[Dic objectForKey:@"type"] mutableCopy];
        LikeArray=[[Dic objectForKey:@"liked"] mutableCopy];
        UserDetailArray=[[Dic objectForKey:@"user_detail"] mutableCopy];
        FirstpartArray=[[Dic objectForKey:@"first_part"] mutableCopy];
        LastPartArray=[[Dic objectForKey:@"last_part"] mutableCopy];
        for (int i=0; i<ItemsArray.count; i++) {
            NSString *Closte=[[ItemsArray objectAtIndex:i] objectForKey:@"closet_id"];
            if ([Closte isEqualToString:closetid]) {
                [LikeArray replaceObjectAtIndex:i withObject:(liked)?@"1":@"0"];
            }
        }
        
        
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:TimeStampArray forKey:@"time_stamp"];
        [dic setObject:NotificationArray forKey:@"notification"];
        [dic setObject:OwnerIdArray forKey:@"owner"];
        [dic setObject:ItemsArray forKey:@"item_detail"];
        [dic setObject:TypeArray forKey:@"type"];
        [dic setObject:LikeArray forKey:@"liked"];
        [dic setObject:UserDetailArray forKey:@"user_detail"];
        [dic setObject:FirstpartArray forKey:@"first_part"];
        [dic setObject:LastPartArray forKey:@"last_part"];
        [dic setObject:@"success" forKey:@"message"];
        [GCCacheSaver saveDictionary:dic withName:@"feeds" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    }
}

-(void)DeleteLikeAtIndex:(NSInteger)index
{
    NSMutableArray *iTemArray;
    NSMutableArray *iTemIDArray;
    NSMutableDictionary *Dic=[GCCacheSaver getDictionaryWithName:@"likes" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
    if (Dic) {
        if ([[Dic objectForKey:@"message"] isEqualToString:@"success"]) {
            iTemArray=[[Dic objectForKey:@"items"] mutableCopy];
            iTemIDArray=[[Dic objectForKey:@"ids"] mutableCopy];
            [iTemArray removeObjectAtIndex:index];
            [iTemIDArray removeObjectAtIndex:index];
            NSMutableDictionary *Dics=[NSMutableDictionary new];
            if (iTemIDArray.count==0) {
                [Dics setObject:@"success" forKey:@"fail"];
            }
            else{
            [Dics setObject:iTemIDArray forKey:@"ids"];
            [Dics setObject:iTemArray forKey:@"items"];
                [Dics setObject:@"success" forKey:@"message"];
            }
            [GCCacheSaver saveDictionary:Dics withName:@"likes" inRelativePath:[NSString stringWithFormat:@"List_%@",[Utility UserID]]];
        }
}
    
}

-(NSString *)Unix
{
    NSDate *date=[NSDate date];
    int startTime = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%i",startTime];
}

@end
