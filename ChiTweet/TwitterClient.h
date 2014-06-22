//
//  TwitterClient.h
//  ChiTweet
//
//  Created by Chirag Davé on 6/18/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) instance;

- (void) login;

- (AFHTTPRequestOperation *)homeTimeline;
@end
