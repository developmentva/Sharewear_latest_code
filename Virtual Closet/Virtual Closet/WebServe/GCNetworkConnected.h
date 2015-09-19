//
//  GCNetworkConnected.h
//  Appy Birthday
//
//  Created by Apple on 24/05/13.
//  Copyright (c) 2013 Vibrantappz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
@interface GCNetworkConnected : NSObject
+(BOOL)isConnected;
@end
