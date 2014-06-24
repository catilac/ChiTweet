//
//  TweetViewController.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/23/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MHPrettyDate.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRetweets;
@property (weak, nonatomic) IBOutlet UILabel *numFavorites;
@property (weak, nonatomic) IBOutlet UILabel *retweetedBy;

@property (weak, nonatomic) Tweet *tweet;

@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTweet:(Tweet *)tweet {
    self = [super init];
    if (self) {
        self.tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fullName.text = self.tweet.author.fullName;
    self.screenName.text = [NSString stringWithFormat:@"@%@",self.tweet.author.userName];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateStyle:NSDateFormatterLongStyle];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    
    NSDate *newDate = [df dateFromString:self.tweet.timestamp];
    NSString *prettyDate = [MHPrettyDate prettyDateFromDate:newDate withFormat:MHPrettyDateLongRelativeTime];
    
    self.dateLabel.text = prettyDate;
    self.tweetText.text= self.tweet.text;
    
    if (self.tweet.retweeted) {
        self.retweetedBy.text = [NSString stringWithFormat:@"RT'd By: %@", self.tweet.retweetedBy];
    } else {
        self.retweetedBy.text = @"";
    }
    
    [self.profilePhoto setImageWithURL:self.tweet.author.profileImageURL];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end