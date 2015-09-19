//
//  ServerParsing.h
//  MitoCard
//
//  Created by Apple on 10/12/13.
//  Copyright (c) 2013 Vibrantappz. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^AuthenticationBlocks)(void);
typedef void (^DictionaryBlocks)(NSMutableDictionary *Dic);
@class ServerParsing;
@interface ServerParsing : NSObject
+(ServerParsing *)server;
-(void)RequestGetAction:(NSString *)url WithParameter:(NSDictionary *) param Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors;
-(void)RequestPostAction:(NSString *)url WithParameter:(NSDictionary *) parameters Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors;
-(void) FetchingData: (NSString *) url Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors ;
-(void)PostWithImageAction:(NSString *)url WithParameter:(NSDictionary *) parameters image:(NSData *)imageData ImageKeyName:(NSString *)key Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors ;
-(void)PostAction1:(NSString *)url WithParameter:(NSDictionary *) parameters image:(NSData *)imageData Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors;
@end
