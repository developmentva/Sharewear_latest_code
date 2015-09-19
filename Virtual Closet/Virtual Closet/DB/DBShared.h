//
//  DBShared.h
//  ShareWear
//
//  Created by Apple on 20/11/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBShared;
@interface DBShared : NSObject
+(DBShared *)shared;
-(void)saveNewaddeditemDetail:(NSMutableDictionary *)param ItemImage:(NSData *)imgdata Iscloset:(BOOL)closet Itemid:(NSString *)RID;
-(void)savemylikes:(NSMutableDictionary *)param Itemid:(NSString *)iid;
-(void)SaveLikeAtindex:(NSString * )closetid Condition:(BOOL)liked;
-(void)DeleteLikeAtIndex:(NSInteger)index;
@end
