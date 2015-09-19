//
//  GCNetworkConnected.m
//  Appy Birthday
//
//  Created by Apple on 24/05/13.
//  Copyright (c) 2013 Vibrantappz. All rights reserved.
//

#import "GCNetworkConnected.h"

@implementation GCNetworkConnected
+(BOOL)isConnected {
//    struct sockaddr_in zeroAddress;
//    bzero(&zeroAddress, sizeof(zeroAddress));
//    zeroAddress.sin_len = sizeof(zeroAddress);
//    zeroAddress.sin_family = AF_INET;
//    
//    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
//    if(reachability != NULL) {
//        //NetworkStatus retVal = NotReachable;
//        SCNetworkReachabilityFlags flags;
//        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
//            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
//            {
//                // if target host is not reachable
//                return NO;
//            }
//            
//            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
//            {
//                // if target host is reachable and no connection is required
//                //  then we'll assume (for now) that your on Wi-Fi
//                return YES;
//            }
//            
//            
//            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
//                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
//            {
//                // ... and the connection is on-demand (or on-traffic) if the
//                //     calling application is using the CFSocketStream or higher APIs
//                
//                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
//                {
//                    // ... and no [user] intervention is needed
//                    return YES;
//                }
//            }
//            
//            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
//            {
//                // ... but WWAN connections are OK if the calling application
//                //     is using the CFNetwork (CFSocketStream?) APIs.
//                return YES;
//            }
//        }
//    }
//    
//    return NO;
    
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    
    return (isReachable && !needsConnection) ? YES : NO;
}

@end
