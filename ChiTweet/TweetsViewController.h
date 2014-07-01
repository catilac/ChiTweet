//
//  TweetsViewController.h
//  ChiTweet
//
//  Created by Chirag Davé on 6/22/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetTableViewCell.h"

@protocol TweetsViewControllerDelegate <NSObject>

- (void)dismissView;

@end

typedef NS_ENUM(NSInteger, APICall) {
    TwitterHomeTimeline,
    TwitterMentionsTimeline,
    TwitterUserTimeline
};

@interface TweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetViewCellDelegate>

@property (nonatomic, weak) id <TweetsViewControllerDelegate> delegate;

- (id)initWithAPICall:(APICall)apiCall;
- (id)initUserTimeline:(User *)user;

@end
