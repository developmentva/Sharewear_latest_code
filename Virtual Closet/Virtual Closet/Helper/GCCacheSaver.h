//
//  GCCacheSaver.h
//  SaveDataLocal
//
//  Created by Guramrit on 10/07/13.
//  Copyright (c) 2013 Guramrit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCCacheSaver : NSObject
+ (void)saveDictionary:(NSMutableDictionary *)dictionary
        withName:(NSString *)saveName
  inRelativePath:(NSString *)path;
+ (NSMutableDictionary *)getDictionaryWithName:(NSString *)dataName
                          inRelativePath:(NSString *)path;
+ (void)deleteItemsAtPath:(NSString *)path;
+ (void)saveData:(NSData *)data
         withName:(NSString *)saveName
   inRelativePath:(NSString *)path;
+ (NSData *)getDataWithName:(NSString *)dataName
             inRelativePath:(NSString *)path;
+(void)Updatedatabase:(NSMutableDictionary *)ChatDic WithItems:(NSArray *)items Otheruser:(NSString *)user;
+(void)DeleteAllStoredData;
@end
