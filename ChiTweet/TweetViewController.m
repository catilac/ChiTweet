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
#import "TwitterClient.h"
#import "ComposeViewController.h"

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


- (IBAction)reply:(id)sender;
- (IBAction)retweet:(id)sender;
- (IBAction)favorite:(id)sender;

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
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fullName.text = self.tweet.author.fullName;
    self.screenName.text = [NSString stringWithFormat:@"@%@",self.tweet.author.screenName];
    
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
    
    self.numRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.numRetweets];
    self.numFavorites.text = [NSString stringWithFormat:@"%d", self.tweet.numFavorites];
    
    [self.profilePhoto setImageWithURL:self.tweet.author.profileImageURL];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)reply:(id)sender {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (IBAction)retweet:(id)sender {
    [[TwitterClient instance] retweetWithTweet:self.tweet success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success Retweet");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail Retweet, %@", error);
    }];
}

- (IBAction)favorite:(id)sender {
    [[TwitterClient instance] favoriteWithTweet:self.tweet success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success Favorite");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail Favorite: %@", error);
    }];
}

@end
