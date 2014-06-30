//
//  TweetTableViewCell.h
//  ChiTweet
//
//  Created by Chirag Davé on 6/22/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

@protocol TweetViewCellDelegate <NSObject>

- (void)showProfile:(User *)profile;

@end

@interface TweetTableViewCell : UITableViewCell

@property (nonatomic, weak) UIViewController<TweetViewCellDelegate> *delegate;

- (void)setTweet:(Tweet *)tweet;

@end
