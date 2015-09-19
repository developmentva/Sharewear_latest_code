//
//  GCCacheSaver.m
//  SaveDataLocal
//
//  Created by Guramrit on 10/07/13.
//  Copyright (c) 2013 Guramrit. All rights reserved.
//

#import "GCCacheSaver.h"
#import "Utility.h"
@implementation GCCacheSaver



+ (void)saveData:(NSData *)data
        withName:(NSString *)saveName
  inRelativePath:(NSString *)path
{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
	[data writeToFile:[folder stringByAppendingPathComponent:saveName] atomically:YES];
}



+ (NSData *)getDataWithName:(NSString *)dataName
             inRelativePath:(NSString *)path
{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0]  stringByAppendingPathComponent:path];
	NSString *dataPath = [folder stringByAppendingPathComponent:dataName];
	NSFileManager *fm = [NSFileManager defaultManager];
	
	return [fm contentsAtPath:dataPath];
}


+ (void)saveDictionary:(NSMutableDictionary *)dictionary
        withName:(NSString *)saveName
  inRelativePath:(NSString *)path
{
     NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dictionary forKey:path];
    [archiver finishEncoding];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
	[data writeToFile:[folder stringByAppendingPathComponent:saveName] atomically:YES];
}


+ (NSMutableDictionary *)getDictionaryWithName:(NSString *)dataName
             inRelativePath:(NSString *)path
{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0]  stringByAppendingPathComponent:path];
	NSString *dataPath = [folder stringByAppendingPathComponent:dataName];
	NSFileManager *fm = [NSFileManager defaultManager];
    NSData *data = [[NSMutableData alloc] initWithData:[fm contentsAtPath:dataPath]];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableDictionary *myDictionary = [unarchiver decodeObjectForKey:path];
    [unarchiver finishDecoding];
	return myDictionary;
}


+ (void)deleteItemsAtPath:(NSString *)path{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:folder error:NULL];
}

+(void)Updatedatabase:(NSMutableDictionary *)ChatDic WithItems:(NSArray *)items Otheruser:(NSString *)user
{
    if (ChatDic==nil) {
         ChatDic=[GCCacheSaver getDictionaryWithName:@"History" inRelativePath:[NSString stringWithFormat:@"Chat_%@",user]];
    }
   NSMutableArray* CreatedAtArray=[[ChatDic objectForKey:@"createdAt"] mutableCopy];
    if (!CreatedAtArray) {
        CreatedAtArray=[NSMutableArray new];
    }
    NSMutableArray* MessagesArray=[[ChatDic objectForKey:@"messages"] mutableCopy];
    if (!MessagesArray) {
        MessagesArray=[NSMutableArray new];
    }
    NSMutableArray* OtheruserIDArray=[[ChatDic objectForKey:@"sender_fb_ids"] mutableCopy];
    if (!OtheruserIDArray) {
        OtheruserIDArray=[NSMutableArray new];
    }
    NSMutableArray* MessageIDArray=[[ChatDic objectForKey:@"message_ids"] mutableCopy];
    if (!MessageIDArray) {
        MessageIDArray=[NSMutableArray new];
    }
    [CreatedAtArray addObject:[items objectAtIndex:0]];
     [MessagesArray addObject:[items objectAtIndex:1]];
    [OtheruserIDArray addObject:[items objectAtIndex:2]];
    [MessageIDArray addObject:[items objectAtIndex:3]];
    NSMutableDictionary *Dics=[NSMutableDictionary new];
    [Dics setObject:CreatedAtArray forKey:@"createdAt"];
    [Dics setObject:MessagesArray forKey:@"messages"];
    [Dics setObject:OtheruserIDArray forKey:@"sender_fb_ids"];
    [Dics setObject:MessageIDArray forKey:@"message_ids"];
    [Dics setObject:@"success" forKey:@"message"];
    [GCCacheSaver saveDictionary:Dics withName:@"History" inRelativePath:[NSString stringWithFormat:@"Chat_%@",user]];
}

+(void)DeleteAllStoredData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        NSLog(@"Path: %@", [paths objectAtIndex:0]);
        
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // Remove Documents directory and all the files
        BOOL deleted = [fileManager removeItemAtPath:[paths objectAtIndex:0] error:&error];
        
        if (deleted != YES || error != nil)
        {
            // Deal with the error...
        }
        
    }
}
@end
