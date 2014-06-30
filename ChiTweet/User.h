//
//  User.h
//  ChiTweet
//
//  Created by Chirag Davé on 6/21/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic, strong) NSURL *profileImageURL;
@property (nonatomic, strong) NSURL *backgroundImageURL;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *numTweets;
@property (nonatomic, strong) NSString *numFollowers;
@property (nonatomic, strong) NSString *numFollowing;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
