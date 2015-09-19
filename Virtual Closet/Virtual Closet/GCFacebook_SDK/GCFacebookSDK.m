//
//  GCFacebookSDK.m
//  GCFacebook
//
//  Created by Apple on 24/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import "GCFacebookSDK.h"
@interface GCFacebookSDK()

+ (GCFacebookSDK *)shared;

@end


@implementation GCFacebookSDK

#pragma mark -
#pragma mark - Singleton

+ (GCFacebookSDK *)shared
{
    static GCFacebookSDK *Facebook = nil;
    
    @synchronized (self){
        
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            Facebook = [[GCFacebookSDK alloc] init];
        });
    }
    
    return Facebook;
}




#pragma mark -
#pragma mark - Private Methods

- (void)initWithPermissions:(NSArray *)permissions
{
    self.permissions = permissions;
}

- (BOOL)isSessionValid
{
    if (!FBSession.activeSession.isOpen){
        
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded){
            [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                                 FBSessionState status,
                                                                 NSError *error) {
                FBSession.activeSession = session;
            }];
        }
    }
    
    return FBSession.activeSession.isOpen;
}

- (void)loginCallBack:(SCFacebookCallback)callBack
{
    //if (FBSession.activeSession.isOpen){
      //  [FBSession.activeSession closeAndClearTokenInformation];
      //  [FBSession setActiveSession:nil];
    //}
    [FBSession openActiveSessionWithReadPermissions:self.permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        
        if (status == FBSessionStateOpen) {
            
            FBRequest *fbRequest = [FBRequest requestForMe];
            [fbRequest setSession:session];
            
            [fbRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
                NSMutableDictionary *userInfo = nil;
                if( [result isKindOfClass:[NSDictionary class]] ){
                    userInfo = (NSMutableDictionary *)result;
                    if( [userInfo count] > 0 ){
                        [userInfo setObject:session.accessTokenData.accessToken forKey:@"accessToken"];
                    }
                }
                if(callBack){
                    callBack(!error, userInfo);
                }
            }];
        }else if(status == FBSessionStateClosedLoginFailed){
            callBack(NO, @"Closed session state indicating that a login attempt failed");
        }
    }];
}

- (void)logoutCallBack:(SCFacebookCallback)callBack
{
    if (FBSession.activeSession.isOpen){
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession setActiveSession:nil];
    }
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://facebook.com/"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
    
    callBack(YES, @"Logout successfully");
}

- (void)getUserFields:(NSString *)fields callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [self graphFacebookForMethodGET:@"me" params:@{@"fields" : fields} callBack:callBack];
}


- (void)getUserFriendsCallBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        callBack(!error, result[@"data"]);
    }];
}

- (void)feedPostWithLinkPath:(NSString *)url caption:(NSString *)caption message:(NSString *)message photo:(UIImage *)photo video:(NSData *)videoData callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //Need to provide POST parameters to the Facebook SDK for the specific post type
    NSString *graphPath = @"me/feed";
    
    switch (self.postType) {
        case FBPostTypeLink:{
            [params setObject:url forKey:@"link"];
            [params setObject:caption forKey:@"description"];
            break;
        }
        case FBPostTypeStatus:{
            [params setObject:message forKey:@"message"];
            break;
        }
        case FBPostTypePhoto:{
            graphPath = @"me/photos";
            [params setObject:UIImagePNGRepresentation(photo) forKey:@"source"];
            [params setObject:caption forKey:@"message"];
            break;
        }
        case FBPostTypeVideo:{
            graphPath = @"me/videos";
            [params setObject:videoData forKey:@"video.mp4"];
            [params setObject:caption forKey:@"title"];
            [params setObject:message forKey:@"description"];
            break;
        }
            
        default:
            break;
    }
    
    [self graphFacebookForMethodPOST:graphPath params:params callBack:callBack];
}

- (void)myFeedCallBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [self graphFacebookForMethodPOST:@"me/feed" params:nil callBack:callBack];
}

- (void)inviteFriendsWithMessage:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:message
                                                    title:nil
                                               parameters:nil
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Error launching the dialog or sending the request.
                                                          callBack(NO, @"Error sending request.");
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User clicked the "x" icon
                                                              callBack(NO, @"User canceled request.");
                                                          } else {
                                                              callBack(YES, @"Send invite");
                                                          }
                                                      }
                                                  }];
}

- (void)getPagesCallBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [self graphFacebookForMethodGET:@"me/accounts" params:nil callBack:callBack];
}

- (void)getPageById:(NSString *)pageId callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!pageId) {
        callBack(NO, @"Page id or name required");
        return;
    }
    
    [GCFacebookSDK graphFacebookForMethodGET:pageId params:nil callBack:callBack];
}

- (void)feedPostForPage:(NSString *)page message:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!page) {
        callBack(NO, @"Page id or name required");
        return;
    }
    
    [GCFacebookSDK graphFacebookForMethodPOST:[NSString stringWithFormat:@"%@/feed", page] params:@{@"message": message} callBack:callBack];
}

- (void)feedPostForPage:(NSString *)page message:(NSString *)message photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!page) {
        callBack(NO, @"Page id or name required");
        return;
    }
    
    [GCFacebookSDK graphFacebookForMethodPOST:[NSString stringWithFormat:@"%@/photos", page] params:@{@"message": message, @"source" : UIImagePNGRepresentation(photo)} callBack:callBack];
}

- (void)feedPostForPage:(NSString *)page message:(NSString *)message link:(NSString *)url callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!page) {
        callBack(NO, @"Page id or name required");
        return;
    }
    
    [GCFacebookSDK graphFacebookForMethodPOST:[NSString stringWithFormat:@"%@/feed", page] params:@{@"message": message, @"link" : url} callBack:callBack];
}

- (void)feedPostForPage:(NSString *)page video:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!page) {
        callBack(NO, @"Page id or name required");
        return;
    }
    
    [GCFacebookSDK graphFacebookForMethodPOST:[NSString stringWithFormat:@"%@/videos", page]
                                    params:@{@"title" : title,
                                             @"description" : description,
                                             @"video.mp4" : videoData} callBack:callBack];
}

- (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    [GCFacebookSDK getPagesCallBack:^(BOOL success, id result) {
        
        if (success) {
            
            NSDictionary *dicPageAdmin = nil;
            
            for (NSDictionary *dic in result[@"data"]) {
                
                if ([dic[@"name"] isEqualToString:page]) {
                    dicPageAdmin = dic;
                    break;
                }
            }
            
            if (!dicPageAdmin) {
                callBack(NO, @"Page not found!");
                return;
            }
            
            FBRequest *requestToPost = [[FBRequest alloc] initWithSession:nil
                                                                graphPath:[NSString stringWithFormat:@"%@/feed",dicPageAdmin[@"id"]]
                                                               parameters:@{@"message" : message, @"access_token" : dicPageAdmin[@"access_token"]}
                                                               HTTPMethod:@"POST"];
            
            FBRequestConnection *requestToPostConnection = [[FBRequestConnection alloc] init];
            [requestToPostConnection addRequest:requestToPost completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    callBack(NO, [error domain]);
                }else{
                    callBack(YES, result);
                }
            }];
            
            [requestToPostConnection start];
        }
    }];
}

- (void)feedPostAdminForPageName:(NSString *)page video:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack
{
    [GCFacebookSDK getPagesCallBack:^(BOOL success, id result) {
        
        if (success) {
            
            NSDictionary *dicPageAdmin = nil;
            
            for (NSDictionary *dic in result[@"data"]) {
                
                if ([dic[@"name"] isEqualToString:page]) {
                    dicPageAdmin = dic;
                    break;
                }
            }
            
            if (!dicPageAdmin) {
                callBack(NO, @"Page not found!");
                return;
            }
            
            FBRequest *requestToPost = [[FBRequest alloc] initWithSession:nil
                                                                graphPath:[NSString stringWithFormat:@"%@/videos",dicPageAdmin[@"id"]]
                                                               parameters:@{@"title" : title,
                                                                            @"description" : description,
                                                                            @"video.mp4" : videoData,
                                                                            @"access_token" : dicPageAdmin[@"access_token"]}
                                                               HTTPMethod:@"POST"];
            
            FBRequestConnection *requestToPostConnection = [[FBRequestConnection alloc] init];
            [requestToPostConnection addRequest:requestToPost completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    callBack(NO, [error domain]);
                }else{
                    callBack(YES, result);
                }
            }];
            
            [requestToPostConnection start];
        }
    }];
}

- (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message link:(NSString *)url callBack:(SCFacebookCallback)callBack
{
    [GCFacebookSDK getPagesCallBack:^(BOOL success, id result) {
        
        if (success) {
            
            NSDictionary *dicPageAdmin = nil;
            
            for (NSDictionary *dic in result[@"data"]) {
                
                if ([dic[@"name"] isEqualToString:page]) {
                    dicPageAdmin = dic;
                    break;
                }
            }
            
            if (!dicPageAdmin) {
                callBack(NO, @"Page not found!");
                return;
            }
            
            FBRequest *requestToPost = [[FBRequest alloc] initWithSession:nil
                                                                graphPath:[NSString stringWithFormat:@"%@/feed",dicPageAdmin[@"id"]]
                                                               parameters:@{@"message" : message,
                                                                            @"link" : url,
                                                                            @"access_token" : dicPageAdmin[@"access_token"]}
                                                               HTTPMethod:@"POST"];
            
            FBRequestConnection *requestToPostConnection = [[FBRequestConnection alloc] init];
            [requestToPostConnection addRequest:requestToPost completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    callBack(NO, [error domain]);
                }else{
                    callBack(YES, result);
                }
            }];
            
            [requestToPostConnection start];
        }
    }];
}

- (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    [GCFacebookSDK getPagesCallBack:^(BOOL success, id result) {
        
        if (success) {
            
            NSDictionary *dicPageAdmin = nil;
            
            for (NSDictionary *dic in result[@"data"]) {
                
                if ([dic[@"name"] isEqualToString:page]) {
                    dicPageAdmin = dic;
                    break;
                }
            }
            
            if (!dicPageAdmin) {
                callBack(NO, @"Page not found!");
                return;
            }
            
            FBRequest *requestToPost = [[FBRequest alloc] initWithSession:nil
                                                                graphPath:[NSString stringWithFormat:@"%@/photos",dicPageAdmin[@"id"]]
                                                               parameters:@{@"message" : message,
                                                                            @"source" : UIImagePNGRepresentation(photo),
                                                                            @"access_token" : dicPageAdmin[@"access_token"]}
                                                               HTTPMethod:@"POST"];
            
            FBRequestConnection *requestToPostConnection = [[FBRequestConnection alloc] init];
            [requestToPostConnection addRequest:requestToPost completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    callBack(NO, [error domain]);
                }else{
                    callBack(YES, result);
                }
            }];
            
            [requestToPostConnection start];
        }
    }];
}

- (void)getAlbumsCallBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    [self graphFacebookForMethodGET:@"me/albums" params:nil callBack:callBack];
}

- (void)getAlbumById:(NSString *)albumId callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!albumId) {
        callBack(NO, @"Album id required");
        return;
    }
    
    [GCFacebookSDK graphFacebookForMethodGET:albumId params:nil callBack:callBack];
}

- (void)getPhotosAlbumById:(NSString *)albumId callBack:(SCFacebookCallback)callBack
{
    
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!albumId) {
        callBack(NO, @"Album id required");
        return;
    }
    
    [GCFacebookSDK graphFacebookForMethodGET:[NSString stringWithFormat:@"%@/photos", albumId] params:nil callBack:callBack];
}

- (void)createAlbumName:(NSString *)name message:(NSString *)message privacy:(FBAlbumPrivacyType)privacy callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!name && !message) {
        callBack(NO, @"Name and message required");
        return;
    }
    
    NSString *privacyString = @"";
    
    switch (privacy) {
        case FBAlbumPrivacyEveryone:
            privacyString = @"EVERYONE";
            break;
        case FBAlbumPrivacyAllFriends:
            privacyString = @"ALL_FRIENDS";
            break;
        case FBAlbumPrivacyFriendsOfFriends:
            privacyString = @"FRIENDS_OF_FRIENDS";
            break;
        case FBAlbumPrivacySelf:
            privacyString = @"SELF";
            break;
        default:
            break;
    }
    
    [GCFacebookSDK graphFacebookForMethodPOST:@"me/albums" params:@{@"name" : name,
                                                                 @"message" : message,
                                                                 @"value" : privacyString} callBack:callBack];
}

- (void)feedPostForAlbumId:(NSString *)albumId photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    if (!albumId) {
        callBack(NO, @"Album id required");
        return;
    }
    
    [GCFacebookSDK graphFacebookForMethodPOST:[NSString stringWithFormat:@"%@/photos", albumId] params:@{@"source": UIImagePNGRepresentation(photo)} callBack:callBack];
}

- (void)sendForPostOpenGraphPath:(NSString *)path graphObject:(NSMutableDictionary<FBOpenGraphObject> *)openGraphObject objectName:(NSString *)objectName callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    // Post custom object
    [FBRequestConnection startForPostOpenGraphObject:openGraphObject completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            // get the object ID for the Open Graph object that is now stored in the Object API
            NSString *objectId = [result objectForKey:@"id"];
            
            // create an Open Graph action
            id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
            [action setObject:objectId forKey:objectName];
            
            // create action referencing user owned object
            [FBRequestConnection startForPostWithGraphPath:path graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(error) {
                    // An error occurred, we need to handle the error
                    // See: https://developers.facebook.com/docs/ios/errors
                    callBack(NO, [NSString stringWithFormat:@"Encountered an error posting to Open Graph: %@", error.description]);
                } else {
                    callBack(YES, [NSString stringWithFormat:@"OG story posted, story id: %@", result[@"id"]]);
                }
            }];
            
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
            callBack(NO, [NSString stringWithFormat:@"Encountered an error posting to Open Graph: %@", error.description]);
        }
    }];
}

- (void)sendForPostOpenGraphPath:(NSString *)path graphObject:(NSMutableDictionary<FBOpenGraphObject> *)openGraphObject objectName:(NSString *)objectName withImage:(UIImage *)image callBack:(SCFacebookCallback)callBack
{
    if (![self isSessionValid]) {
        callBack(NO, @"Not logged in");
        return;
    }
    
    // stage an image
    [FBRequestConnection startForUploadStagingResourceWithImage:image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            NSLog(@"Successfuly staged image with staged URI: %@", [result objectForKey:@"uri"]);
            
            // for og:image we assign the uri of the image that we just staged
            //            object[@"image"] = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }];
            
            openGraphObject.image = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }];
            
            [self sendForPostOpenGraphPath:path graphObject:openGraphObject objectName:objectName callBack:callBack];
        }
    }];
}

- (void)graphFacebookForMethodPOST:(NSString *)method params:(id)params callBack:(SCFacebookCallback)callBack
{
    [FBRequestConnection startWithGraphPath:method parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result,NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            callBack(NO, error);
        } else {
            NSLog(@"%@", result);
            callBack(YES, result);
        }
    }];
}

- (void)graphFacebookForMethodGET:(NSString *)method params:(id)params callBack:(SCFacebookCallback)callBack
{
    [FBRequestConnection startWithGraphPath:method parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result,NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            callBack(NO, error);
        } else {
            NSLog(@"%@", result);
            callBack(YES, result);
        }
    }];
}





#pragma mark -
#pragma mark - Public Methods

+ (void)initWithPermissions:(NSArray *)permissions
{
    [[GCFacebookSDK shared] initWithPermissions:permissions];
}

+(BOOL)isSessionValid
{
    return [[GCFacebookSDK shared] isSessionValid];
}

+ (void)loginCallBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] loginCallBack:callBack];
}

+ (void)logoutCallBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] logoutCallBack:callBack];
}

+ (void)getUserFields:(NSString *)fields callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] getUserFields:fields callBack:callBack];
}

+ (void)getUserFriendsCallBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] getUserFriendsCallBack:callBack];
}

+ (void)feedPostWithLinkPath:(NSString *)url caption:(NSString *)caption callBack:(SCFacebookCallback)callBack
{
    [GCFacebookSDK shared].postType = FBPostTypeLink;
    [[GCFacebookSDK shared] feedPostWithLinkPath:url caption:caption message:nil photo:nil video:nil callBack:callBack];
}

+ (void)feedPostWithMessage:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    [GCFacebookSDK shared].postType = FBPostTypeStatus;
    [[GCFacebookSDK shared] feedPostWithLinkPath:nil caption:nil message:message photo:nil video:nil callBack:callBack];
}

+ (void)feedPostWithPhoto:(UIImage *)photo caption:(NSString *)caption callBack:(SCFacebookCallback)callBack
{
    [GCFacebookSDK shared].postType = FBPostTypePhoto;
    [[GCFacebookSDK shared] feedPostWithLinkPath:nil caption:caption message:nil photo:photo video:nil callBack:callBack];
}

+ (void)feedPostWithVideo:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack
{
    [GCFacebookSDK shared].postType = FBPostTypeVideo;
    [[GCFacebookSDK shared] feedPostWithLinkPath:nil caption:title message:description photo:nil video:videoData callBack:callBack];
}

+ (void)myFeedCallBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] myFeedCallBack:callBack];
}

+ (void)inviteFriendsWithMessage:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] inviteFriendsWithMessage:message callBack:callBack];
}

+ (void)getPagesCallBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] getPagesCallBack:callBack];
}

+ (void)getPageById:(NSString *)pageId callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] getPageById:pageId callBack:callBack];
}

+ (void)feedPostForPage:(NSString *)page message:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] feedPostForPage:page message:message callBack:callBack];
}

+ (void)feedPostForPage:(NSString *)page message:(NSString *)message photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] feedPostForPage:page message:message photo:photo callBack:callBack];
}

+ (void)feedPostForPage:(NSString *)page message:(NSString *)message link:(NSString *)url callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] feedPostForPage:page message:message link:url callBack:callBack];
}

+ (void)feedPostForPage:(NSString *)page video:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] feedPostForPage:page video:videoData title:title description:description callBack:callBack];
}

+ (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] feedPostAdminForPageName:page message:message callBack:callBack];
}

+ (void)feedPostAdminForPageName:(NSString *)page video:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] feedPostAdminForPageName:page video:videoData title:title description:description callBack:callBack];
}

+ (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message link:(NSString *)url callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] feedPostAdminForPageName:page message:message link:url callBack:callBack];
}

+ (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] feedPostAdminForPageName:page message:message photo:photo callBack:callBack];
}

+ (void)getAlbumsCallBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] getAlbumsCallBack:callBack];
}

+ (void)getAlbumById:(NSString *)albumId callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] getAlbumById:albumId callBack:callBack];
}

+ (void)getPhotosAlbumById:(NSString *)albumId callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] getPhotosAlbumById:albumId callBack:callBack];
}

+ (void)createAlbumName:(NSString *)name message:(NSString *)message privacy:(FBAlbumPrivacyType)privacy callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] createAlbumName:name message:message privacy:privacy callBack:callBack];
}

+ (void)feedPostForAlbumId:(NSString *)albumId photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] feedPostForAlbumId:albumId photo:photo callBack:callBack];
}

+ (void)sendForPostOpenGraphPath:(NSString *)path graphObject:(NSMutableDictionary<FBOpenGraphObject> *)openGraphObject objectName:(NSString *)objectName callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] sendForPostOpenGraphPath:path graphObject:openGraphObject objectName:objectName callBack:callBack];
}

+ (void)sendForPostOpenGraphPath:(NSString *)path graphObject:(NSMutableDictionary<FBOpenGraphObject> *)openGraphObject objectName:(NSString *)objectName withImage:(UIImage *)image callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] sendForPostOpenGraphPath:path graphObject:openGraphObject objectName:objectName withImage:image callBack:callBack];
}

+ (void)graphFacebookForMethodGET:(NSString *)method params:(id)params callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] graphFacebookForMethodGET:method params:params callBack:callBack];
}

+ (void)graphFacebookForMethodPOST:(NSString *)method params:(id)params callBack:(SCFacebookCallback)callBack
{
    [[GCFacebookSDK shared] graphFacebookForMethodPOST:method params:params callBack:callBack];
}


@end
