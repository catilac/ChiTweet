//
//  User.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/21/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "User.h"

#define CURRENT_USER_KEY @"chiTweetCurrentUser"
#define ENCODE_SCREEN_NAME_KEY @"screenName"
#define ENCODE_FULL_NAME_KEY @"fullName"
#define ENCODE_USER_PROFILE_IMG_URL @"userProfileImageURL"


@implementation User

static User *currentUser = nil;


+ (User *)currentUser {
    if (currentUser == nil) {
        // look up current user
        // Read from NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *archivedUser = [defaults objectForKey:CURRENT_USER_KEY];
        if (archivedUser != nil) {
            currentUser = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedUser];
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    currentUser = user;
    // but also save the user
    NSData *archivedUser = nil;
    if (user != nil) {
        archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:archivedUser forKey:CURRENT_USER_KEY];
    [defaults synchronize];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.screenName = dictionary[@"screen_name"];
        self.fullName = dictionary[@"name"];
        self.profileImageURL = [[NSURL alloc] initWithString:dictionary[@"profile_image_url"]];
    }
    return self;
}

# pragma mark - NSCoder methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.screenName = [aDecoder decodeObjectForKey:ENCODE_SCREEN_NAME_KEY];
        self.fullName = [aDecoder decodeObjectForKey:ENCODE_FULL_NAME_KEY];
        self.profileImageURL = [aDecoder decodeObjectForKey:ENCODE_USER_PROFILE_IMG_URL];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.screenName forKey:ENCODE_SCREEN_NAME_KEY];
    [aCoder encodeObject:self.fullName forKey:ENCODE_FULL_NAME_KEY];
    [aCoder encodeObject:self.profileImageURL forKey:ENCODE_USER_PROFILE_IMG_URL];
}



@end
