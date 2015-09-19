//
//  GCFacebookSDK.h
//  GCFacebook
//
//  Created by Apple on 24/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#define Alert(title,msg)  [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

typedef void(^SCFacebookCallback)(BOOL success, id result);

typedef NS_ENUM(NSInteger, FBPostType) {
    FBPostTypeStatus = 0,
    FBPostTypePhoto = 1,
    FBPostTypeLink = 2,
    FBPostTypeVideo = 3
};

typedef NS_ENUM(NSInteger, FBAlbumPrivacyType) {
    FBAlbumPrivacyEveryone = 0,
    FBAlbumPrivacyAllFriends = 1,
    FBAlbumPrivacyFriendsOfFriends = 2,
    FBAlbumPrivacySelf = 3
};

@interface GCFacebookSDK : NSObject
@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) NSArray *permissions;
@property (assign, nonatomic) FBPostType postType;


/**
 *  When a person logs into your app via Facebook Login you can access a subset of that person's data stored on Facebook. Permissions are how you ask someone if you can access that data. A person's privacy settings combined with what you ask for will determine what you can access.
 *
 *  Permissions are strings that are passed along with a login request or an API call. Here are two examples of permissions:
 *
 *  email - Access to a person's primary email address.
 *  user_likes - Access to the list of things a person likes.
 *
 *  https://developers.facebook.com/docs/facebook-login/permissions/v2.1
 *
 *  @param permissions
 */
+ (void)initWithPermissions:(NSArray *)permissions;

/**
 *  Checks if there is an open session, if it is not checked if a token is created and returned there to validate session.
 *
 *  @return BOOL
 */
+ (BOOL)isSessionValid;

/**
 *  Facebook login
 *
 * https://developers.facebook.com/docs/ios/graph
 *
 *  @param callBack (BOOL success, id result)
 */
+ (void)loginCallBack:(SCFacebookCallback)callBack;

/**
 *  Facebook logout
 *
 * https://developers.facebook.com/docs/ios/graph
 *
 *  @param callBack (BOOL success, id result)
 */
+ (void)logoutCallBack:(SCFacebookCallback)callBack;

/**
 *  Get the data from the logged in user by passing the fields.
 *
 *  https://developers.facebook.com/docs/facebook-login/permissions/v2.1#reference-public_profile
 *
 *  Permissions required: public_profile...
 *
 *  @param fields   fields example: id, name, email, birthday, about, picture
 *  @param callBack (BOOL success, id result)
 */
+ (void)getUserFields:(NSString *)fields callBack:(SCFacebookCallback)callBack;

/**
 *  This will only return any friends who have used (via Facebook Login) the app making the request.
 *  If a friend of the person declines the user_friends permission, that friend will not show up in the friend list for this person.
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/user/friends/
 *
 *  Permissions required: user_friends
 *
 *  @param callBack (BOOL success, id result)
 */
+ (void)getUserFriendsCallBack:(SCFacebookCallback)callBack;

/**
 *  Post in the user profile with link and caption
 *
 * https://developers.facebook.com/docs/graph-api/reference/v2.1/user/feed
 *
 *  Permissions required: publish_actions
 *
 *  @param url      NSString
 *  @param caption  NSString
 *  @param callBack (BOOL success, id result)
 */
+ (void)feedPostWithLinkPath:(NSString *)url caption:(NSString *)caption callBack:(SCFacebookCallback)callBack;

/**
 *  Post in the user profile with message
 *
 * https://developers.facebook.com/docs/graph-api/reference/v2.1/user/feed
 *
 *  Permissions required: publish_actions
 *
 *  @param message  NSString
 *  @param callBack (BOOL success, id result)
 */
+ (void)feedPostWithMessage:(NSString *)message callBack:(SCFacebookCallback)callBack;

/**
 *  Post in the user profile with photo and caption
 *
 * https://developers.facebook.com/docs/graph-api/reference/v2.1/user/feed
 *
 *  Permissions required: publish_actions
 *
 *  @param photo    UIImage
 *  @param caption  NSString
 *  @param callBack (BOOL success, id result)
 */
+ (void)feedPostWithPhoto:(UIImage *)photo caption:(NSString *)caption callBack:(SCFacebookCallback)callBack;

/**
 *  Post in the user profile with video, title and description
 *
 * https://developers.facebook.com/docs/graph-api/reference/v2.1/user/feed
 *
 *  Permissions required: publish_actions
 *
 *  @param videoData   NSData
 *  @param title       NSString
 *  @param description NSString
 *  @param callBack    (BOOL success, id result)
 */
+ (void)feedPostWithVideo:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack;

/**
 *  The feed of posts (including status updates) and links published by this person, or by others on this person's profile.
 *
 * https://developers.facebook.com/docs/graph-api/reference/v2.1/user/feed
 *
 *  Permissions required: read_stream
 *
 *  @param callBack (BOOL success, id result)
 */
+ (void)myFeedCallBack:(SCFacebookCallback)callBack;

/**
 *  Invite friends with message via dialog
 *
 * https://developers.facebook.com/docs/graph-api/reference/v2.1/user/
 *
 *  @param message  NSString
 *  @param callBack (BOOL success, id result)
 */
+ (void)inviteFriendsWithMessage:(NSString *)message callBack:(SCFacebookCallback)callBack;

/**
 *  Get pages in user
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/page
 *
 *  Permissions required: manage_pages
 *
 *  @param callBack (BOOL success, id result)
 */
+ (void)getPagesCallBack:(SCFacebookCallback)callBack;

/**
 *
 *  Get page with id
 *
 *  Facebook Web address ou pageId
 *  Example http://www.lucascorrea.com/PageId.png
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/page
 *
 *  Permissions required: manage_pages
 *
 *  @param pageId   Facebook Web address ou pageId
 *  @param callBack (BOOL success, id result)
 */
+ (void)getPageById:(NSString *)pageId callBack:(SCFacebookCallback)callBack;

/**
 *  Post in the page profile with message
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/page
 *
 *  Permissions required: publish_actions
 *
 *  @param page     NSString
 *  @param message  NSString
 *  @param callBack (BOOL success, id result)
 */
+ (void)feedPostForPage:(NSString *)page message:(NSString *)message callBack:(SCFacebookCallback)callBack;

/**
 *  Post in the page profile with message and photo
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/page
 *
 *  Permissions required: publish_actions
 *
 *  @param page     NSString
 *  @param message  NSString
 *  @param photo    UIImage
 *  @param callBack (BOOL success, id result)
 */
+ (void)feedPostForPage:(NSString *)page message:(NSString *)message photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack;

/**
 *  Post in the page profile with message and link
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/page
 *
 *  Permissions required: publish_actions
 *
 *  @param page     NSString
 *  @param message  NSString
 *  @param url      NSString
 *  @param callBack (BOOL success, id result)
 */
+ (void)feedPostForPage:(NSString *)page message:(NSString *)message link:(NSString *)url callBack:(SCFacebookCallback)callBack;

/**
 *  Post in the page profile with video, title and description
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/page
 *
 *  Permissions required: publish_actions
 *
 *  @param page        NSString
 *  @param videoData   NSData
 *  @param title       NSString
 *  @param description NSString
 *  @param callBack    (BOOL success, id result)
 */
+ (void)feedPostForPage:(NSString *)page video:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack;

/**
 *  Post on page with administrator profile with a message
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/page
 *
 *  Permissions required: publish_actions
 *
 *  @param page     NSString
 *  @param message  NSString
 *  @param callBack (BOOL success, id result)
 */
+ (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message callBack:(SCFacebookCallback)callBack;

/**
 *  Post on page with administrator profile with a message and link
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/page
 *
 *  Permissions required: publish_actions
 *
 *  @param page     NSString
 *  @param message  NSString
 *  @param url      NSString
 *  @param callBack (BOOL success, id result)
 */
+ (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message link:(NSString *)url callBack:(SCFacebookCallback)callBack;

/**
 *  Post on page with administrator profile with a message and photo
 *
 *  Permissions required: publish_actions
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/page
 *
 *
 *  @param page     NSString
 *  @param message  NSString
 *  @param photo    UIImage
 *  @param callBack (BOOL success, id result)
 */
+ (void)feedPostAdminForPageName:(NSString *)page message:(NSString *)message photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack;

/**
 *  Post on page with administrator profile with a video, title and description
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/page
 *
 *  Permissions required: publish_actions
 *
 *  @param page        NSString
 *  @param videoData   NSData
 *  @param title       NSString
 *  @param description NSString
 *  @param callBack    (BOOL success, id result)
 */
+ (void)feedPostAdminForPageName:(NSString *)page video:(NSData *)videoData title:(NSString *)title description:(NSString *)description callBack:(SCFacebookCallback)callBack;

/**
 *  Get albums in user
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/user/albums
 *
 *  Permissions required: user_photos
 *
 *  @param callBack (BOOL success, id result)
 */
+ (void)getAlbumsCallBack:(SCFacebookCallback)callBack;

/**
 *  Get album with id
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/user/albums
 *
 *  Permissions required: user_photos
 *
 *  @param albumId  NSString
 *  @param callBack (BOOL success, id result)
 */
+ (void)getAlbumById:(NSString *)albumId callBack:(SCFacebookCallback)callBack;

/**
 *  Get photos the album with id
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/album/photos
 *
 *  Permissions required: user_photos
 *
 *  @param albumId  NSString
 *  @param callBack (BOOL success, id result)
 */
+ (void)getPhotosAlbumById:(NSString *)albumId callBack:(SCFacebookCallback)callBack;

/**
 *  Create album the user
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/user/albums
 *
 *  Permissions required: publish_actions and user_photos
 *
 *  @param name     NSString
 *  @param message  NSString
 *  @param privacy  ENUM
 *  @param callBack (BOOL success, id result)
 */
+ (void)createAlbumName:(NSString *)name message:(NSString *)message privacy:(FBAlbumPrivacyType)privacy callBack:(SCFacebookCallback)callBack;

/**
 *  Post the photo album in your user profile
 *
 *  https://developers.facebook.com/docs/graph-api/reference/v2.1/album/photos
 *
 *  Permissions required: publish_actions
 *
 *  @param albumId  NSString
 *  @param photo    UIImage
 *  @param callBack (BOOL success, id result)
 */
+ (void)feedPostForAlbumId:(NSString *)albumId photo:(UIImage *)photo callBack:(SCFacebookCallback)callBack;

/**
 *  Post open graph
 *
 *  Open Graph lets apps tell stories on Facebook through a structured, strongly typed API. When people engage with these stories they are directed to your app or, if they don't have your app installed, to your app's App Store page, driving engagement and distribution for your app.
 *
 *  Stories have the following core components:
 *
 *   An actor: the person who publishes the story, the user.
 *   An action the actor performs, for example: cook, run or read.
 *   An object on which the action is performed: cook a meal, run a race, read a book.
 *   An app: the app from which the story is posted, which is featured alongside the story.
 *  We provide some built in objects and actions for frequent use cases, and you can also create custom actions and objects to fit your app.
 *
 *  https://developers.facebook.com/docs/ios/open-graph
 *
 *  Permissions required: publish_actions
 *
 *  @param path            NSString
 *  @param openGraphObject NSString
 *  @param objectName      NSString
 *  @param callBack        (BOOL success, id result)
 */
+ (void)sendForPostOpenGraphPath:(NSString *)path graphObject:(NSMutableDictionary<FBOpenGraphObject> *)openGraphObject objectName:(NSString *)objectName callBack:(SCFacebookCallback)callBack;

/**
 *   Post open graph with image
 *
 *  Open Graph lets apps tell stories on Facebook through a structured, strongly typed API. When people engage with these stories they are directed to your app or, if they don't have your app installed, to your app's App Store page, driving engagement and distribution for your app.
 *
 *  Stories have the following core components:
 *
 *   An actor: the person who publishes the story, the user.
 *   An action the actor performs, for example: cook, run or read.
 *   An object on which the action is performed: cook a meal, run a race, read a book.
 *   An app: the app from which the story is posted, which is featured alongside the story.
 *  We provide some built in objects and actions for frequent use cases, and you can also create custom actions and objects to fit your app.
 *
 *  https://developers.facebook.com/docs/ios/open-graph
 *
 *  Permissions required: publish_actions
 *
 *  @param path            NSString
 *  @param openGraphObject NSString
 *  @param objectName      NSString
 *  @param image           UIImage
 *  @param callBack        (BOOL success, id result)
 */
+ (void)sendForPostOpenGraphPath:(NSString *)path graphObject:(NSMutableDictionary<FBOpenGraphObject> *)openGraphObject objectName:(NSString *)objectName withImage:(UIImage *)image callBack:(SCFacebookCallback)callBack;

/**
 *  If not on the list in SCFacebook method, this method can be used to make calls via the graph API GET
 *
 *  Calling the Graph API GET
 *
 *  https://developers.facebook.com/docs/ios/graph
 *
 *  @param method   NSString
 *  @param params   NSDictionary
 *  @param callBack (BOOL success, id result)
 */
+ (void)graphFacebookForMethodGET:(NSString *)method params:(id)params callBack:(SCFacebookCallback)callBack;

/**
 *  If not on the list in SCFacebook method, this method can be used to make calls via the graph API POST
 *
 *  Calling the Graph API POST
 *
 *  https://developers.facebook.com/docs/ios/graph
 *
 *  @param method   NSString
 *  @param params   NSDictionary
 *  @param callBack (BOOL success, id result)
 */
+ (void)graphFacebookForMethodPOST:(NSString *)method params:(id)params callBack:(SCFacebookCallback)callBack;
@end