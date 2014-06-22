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

- (AFHTTPRequestOperation *)homeTimeline {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"What ");
    }];
}

@end
