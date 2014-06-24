//
//  Tweet.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/21/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    NSDictionary *parentTweet = dictionary;
    NSLog(@"%@", parentTweet);
    self = [super init];
    if (self) {
        if (parentTweet[@"retweeted_status"]) {
            NSDictionary *retweet = parentTweet[@"retweeted_status"];
            [self setTweetValues:retweet];
            self.retweeted = YES;
            self.retweetedBy = parentTweet[@"user"][@"name"];
            
        } else {
            [self setTweetValues:parentTweet];
        }
    }
    return self;
}

- (void)setTweetValues:(NSDictionary *)tweet {
    self.text = tweet[@"text"];
    self.timestamp = tweet[@"created_at"];
    self.author = [[User alloc] initWithDictionary:tweet[@"user"]];
    self.numFavorites = (NSInteger)tweet[@"favourites_count"];
    self.numRetweets = (NSInteger)tweet[@"retweet_count"];
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    
    return tweets;
}

@end
