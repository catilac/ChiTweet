//
//  TwitterClient.h
//  ChiTweet
//
//  Created by Chirag Davé on 6/18/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) instance;

- (void) login;

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)favoriteWithTweet:(Tweet *)tweet
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)retweetWithTweet:(Tweet *)tweet
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (AFHTTPRequestOperation *)verifyCredentialsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
