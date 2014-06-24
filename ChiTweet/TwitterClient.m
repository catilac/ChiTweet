//
//  TwitterClient.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/18/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/"]
                                              consumerKey:@"vTrFw2BfDZfjpwocfKtH5BBZ1"
                                           consumerSecret:@"Mz5kxK2rU9DAK0ATEqAv9kLnFvMSLWVhXvN4S5PY64lV3ndNnT"];
    });
    
    return instance;
}

- (void)login {
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"chitweet://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Failed, %@", [error description]);
    }];
}

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                                            failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

-(AFHTTPRequestOperation *)favoriteWithTweet:(Tweet *)tweet
                                     success:(void (^)(AFHTTPRequestOperation *, id))success
                                     failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {

    NSDictionary *params = @{@"id": tweet.tweetId};
    
    return [self POST:@"1.1/favorites/create.json" parameters:params success:success failure:failure];
}

-(AFHTTPRequestOperation *)retweetWithTweet:(Tweet *)tweet
                                    success:(void (^)(AFHTTPRequestOperation *, id))success
                                    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.tweetId];
    return [self POST:url parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)verifyCredentialsWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                                                failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

@end
