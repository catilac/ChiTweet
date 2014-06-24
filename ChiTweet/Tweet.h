//
//  Tweet.h
//  ChiTweet
//
//  Created by Chirag Davé on 6/21/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) User *author;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) Boolean retweeted;
@property (nonatomic, strong) NSString *retweetedBy;


- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
