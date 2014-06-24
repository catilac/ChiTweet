//
//  TweetsViewController.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/22/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetTableViewCell.h"
#import "TweetViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"


static NSString *const TVC_REUSE_IDENT = @"TweetCell";

@interface TweetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *tweets;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Home";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self action:@selector(logout)];
    }
    return self;
}

- (void) loadTweets {
    [[TwitterClient instance] homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.tweets = [Tweet tweetsWithArray:responseObject];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error loading tweets: %@", error);
        [self.refreshControl endRefreshing];
    }];
}

- (void)logout {
    TwitterClient *client = [TwitterClient instance];
    [client.requestSerializer removeAccessToken];
    [User setCurrentUser:nil];
    
    [self.delegate dismissView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = (UIResponder<TweetsViewControllerDelegate> *)[[UIApplication sharedApplication] delegate];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:TVC_REUSE_IDENT];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(loadTweets)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self loadTweets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:TVC_REUSE_IDENT];
    Tweet *tweet = self.tweets[indexPath.row];
    
    [tweetCell setTweet:tweet];
    
    return tweetCell;
}

# pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    Tweet *tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:[[TweetViewController alloc] initWithTweet:tweet] animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:TVC_REUSE_IDENT];
    
    [tweetCell setTweet:self.tweets[indexPath.row]];
    [tweetCell setNeedsLayout];
    [tweetCell layoutIfNeeded];
    
    CGFloat height = [tweetCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    return height;
}

@end
