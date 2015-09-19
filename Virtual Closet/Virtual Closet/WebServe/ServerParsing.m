//
//  ServerParsing.m
//  MitoCard
//
//  Created by Apple on 10/12/13.
//  Copyright (c) 2013 Vibrantappz. All rights reserved.
//

#import "ServerParsing.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "GCNetworkConnected.h"

ServerParsing *Parse;
@implementation ServerParsing
+(ServerParsing *)server
{
    if (Parse==Nil) {
        Parse=[[ServerParsing alloc]init];
    }
    return Parse;
}
-(void)RequestGetAction:(NSString *)url WithParameter:(NSDictionary *) param Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors {
    dispatch_queue_t ParseQueue = dispatch_queue_create("ParseQueue", NULL);
    dispatch_async(ParseQueue, ^{
        
        if ([GCNetworkConnected isConnected]) {
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError* error;
                NSMutableDictionary* json = [NSJSONSerialization
                                             JSONObjectWithData:operation.responseData
                                             
                                             options:kNilOptions
                                             error:&error];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //Callback
                    completion(json);
                });
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //Callback
                     NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                    errors();
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Callback
                errors();
            });
        }
    });
}


-(void)RequestPostAction:(NSString *)url WithParameter:(NSDictionary *) parameters Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors {
    
    dispatch_queue_t ParseQueue = dispatch_queue_create("ParseQueue", NULL);
    dispatch_async(ParseQueue, ^{
        if ([GCNetworkConnected isConnected]) {
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
             manager.responseSerializer=[AFHTTPResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 10000000;
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError* error;
                //NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                NSMutableDictionary* json = [NSJSONSerialization
                                             JSONObjectWithData:operation.responseData
                                             
                                             options:kNilOptions
                                             error:&error];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //Callback
                    completion(json);
                });
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //Callback
                    NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                    errors();
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Callback
                errors();
            });
        }
        
            });
}

-(void)PostWithImageAction:(NSString *)url WithParameter:(NSDictionary *) parameters image:(NSData *)imageData ImageKeyName:(NSString *)key Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors {
    
    dispatch_queue_t ParseQueue = dispatch_queue_create("ParseQueue", NULL);
    dispatch_async(ParseQueue, ^{
        
        NSString *PicName=[NSString stringWithFormat:@"%d.jpg",arc4random()%1000000000];
        if ([GCNetworkConnected isConnected]) {
            
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
            AFHTTPRequestOperation *op = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //do not put image inside parameters dictionary as I did, but append it!
                [formData appendPartWithFileData:imageData name:key fileName:PicName mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                NSError* error;
                NSMutableDictionary* json = [NSJSONSerialization
                                      JSONObjectWithData:operation.responseData
                                      
                                      options:kNilOptions 
                                      error:&error];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //Callback
                    completion(json);
                });
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //Callback
                    
                    errors();
                });
            }];
            [op start];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Callback
                
                errors();
            });
        }
    });
}

-(void)PostAction1:(NSString *)url WithParameter:(NSDictionary *) parameters image:(NSData *)imageData Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors {
    
    dispatch_queue_t ParseQueue = dispatch_queue_create("ParseQueue", NULL);
    dispatch_async(ParseQueue, ^{
        
        NSString *PicName=[NSString stringWithFormat:@"%d.jpg",arc4random()%1000000000];
        if ([GCNetworkConnected isConnected]) {
            
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
            AFHTTPRequestOperation *op = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //do not put image inside parameters dictionary as I did, but append it!
                [formData appendPartWithFileData:imageData name:@"myfile" fileName:PicName mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                NSError* error;
                NSMutableDictionary* json = [NSJSONSerialization
                                             JSONObjectWithData:operation.responseData
                                             
                                             options:kNilOptions
                                             error:&error];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //Callback
                    completion(json);
                });
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //Callback
                    
                    errors();
                });
            }];
            [op start];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Callback
                
                errors();
            });
        }
    });
}
-(void) FetchingData: (NSString *) url Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors {
    NSLog(@"%@",url);
    //Check if location must update
    dispatch_queue_t ParseQueue = dispatch_queue_create("ParseQueue", NULL);
    dispatch_async(ParseQueue, ^{
        int errorReasonCode = 0;
        NSString *newString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *Url = [NSURL URLWithString:newString];
        NSData* data = [NSData dataWithContentsOfURL:Url];
        NSError* error;
        id json;
        if (data) {
            json = [NSJSONSerialization
                       JSONObjectWithData:data
                       options:kNilOptions
                       error:&error];
        }
        
        if (json!=NULL) {
            errorReasonCode=0;
        }
        else{
            errorReasonCode=1;
        }
        
        //Success or error
        if (errorReasonCode > 0) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Callback
                errors();
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Callback
                completion(json);
            });
        }
    });
}



@end
