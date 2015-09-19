//
//  UIImageView+Network.m
//
//  Created by Soroush Khanlou on 8/25/12.
//
//

#import "UIImageView+Network.h"
#import "FTWCache.h"
#import <objc/runtime.h>
static char URL_KEY;
inline static NSString* keyForURL(NSURL* url, NSString* style) {
    if(style) {
        return [NSString stringWithFormat:@"GCImageLoader-%lu-%lu", (unsigned long)[[url description] hash], (unsigned long)[style hash]];
    } else {
        return [NSString stringWithFormat:@"GCImageLoader-%lu", (unsigned long)[[url description] hash]];
    }
}

@implementation UIImageView(Network)

@dynamic imageURL;

- (void) loadImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder cachingKey:(NSString*)key {
	self.imageURL = url;
	self.image = placeholder;
	key = keyForURL(url, nil);
	//NSData *cachedData = [[EGOCache currentCache] dataForKey:key];
    
    NSData *cachedData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	if (cachedData) {   
 	   self.imageURL   = nil;
 	   self.image      = [UIImage imageWithData:cachedData scale:.5];
	   return;
	}

	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		NSData *data = [NSData dataWithContentsOfURL:url];
		
		UIImage *imageFromData = [UIImage imageWithData:data scale:.5];
		
		//[[EGOCache currentCache] setData:data forKey:key];
       // [FTWCache setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];

		if (imageFromData) {
			//if ([self.imageURL.absoluteString isEqualToString:url.absoluteString]) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					self.image = imageFromData;
				});
//			} else {
////				NSLog(@"urls are not the same, bailing out!");
//			}
		}
		self.imageURL = nil;
	});
}
-(void)loadimage:(NSData *)cachedData
{
    self.imageURL   = nil;
    self.image      = [UIImage imageWithData:cachedData scale:.5];
}

- (void) setImageURL:(NSURL *)newImageURL {
    //self.image=[UIImage imageNamed:@"defaultimage"];
	objc_setAssociatedObject(self, &URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}

- (NSURL*) imageURL {
    //self.image=[UIImage imageNamed:@"defaultimage"];
	return objc_getAssociatedObject(self, &URL_KEY);
}

@end
