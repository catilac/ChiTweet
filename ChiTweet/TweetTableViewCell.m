//
//  TweetTableViewCell.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/22/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *retweetedBy;

@end

@implementation TweetTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    self.fullName.text = tweet.author.fullName;
    self.screenName.text = [NSString stringWithFormat:@"@%@",tweet.author.userName];
    
//    NSDateFormatter *f = [[NSDateFormatter alloc] init];
//    [f setDateStyle:NSDateFormatterShortStyle];
//    [f setTimeStyle:NSDateFormatterShortStyle];
//    NSLog(@"%@ --> %@", tweet.timestamp, [f stringFromDate:[f dateFromString:tweet.timestamp]]);
    
    self.timestamp.text = @"3h";//tweet.timestamp;
    self.tweetText.text= tweet.text;
    
    [self.profilePhoto setImageWithURL:tweet.author.profileImageURL];
}

@end
