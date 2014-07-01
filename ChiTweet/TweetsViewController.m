//
//  TweetsViewController.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/22/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetViewController.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"
#import "User.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"


static NSString *const TVC_REUSE_IDENT = @"TweetCell";

@interface TweetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic) APICall apiCall;
@property (nonatomic, strong) User *user;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithAPICall:(APICall)apiCall {
    self = [super init];
    if (self) {
        self.apiCall = apiCall;
    }
    return self;
}

- (id)initUserTimeline:(User *)user {
    self = [super init];
    if (self) {
        self.apiCall = TwitterUserTimeline;
        self.user = user;
    }
    return self;
}

- (void)loadTweets {
    TwitterClient *client = [TwitterClient instance];
    
    if (self.apiCall == TwitterMentionsTimeline) {
        [client mentionsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.tweets = [Tweet tweetsWithArray:responseObject];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error loading tweets: %@", error);
            [self.refreshControl endRefreshing];
        }];
    } else if (self.apiCall == TwitterUserTimeline) {
        [client userTimelineWithUser:self.user success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.tweets = [Tweet tweetsWithArray:responseObject];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error loading tweets: %@", error);
            [self.refreshControl endRefreshing];
        }];
    } else {
        [client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.tweets = [Tweet tweetsWithArray:responseObject];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error loading tweets: %@", error);
            [self.refreshControl endRefreshing];
        }];
        
    }
}

- (void)logout {
    TwitterClient *client = [TwitterClient instance];
    [client.requestSerializer removeAccessToken];
    [User setCurrentUser:nil];
    
    [self.delegate dismissView];
    
}

- (void)compose {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.user) {
        self.title = self.user.fullName;
    } else {
        self.title = @"Home";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self action:@selector(logout)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self action:@selector(compose)];
    }

    self.delegate = (UIResponder<TweetsViewControllerDelegate> *)[[UIApplication sharedApplication] delegate];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:TVC_REUSE_IDENT];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(loadTweets)
                  forControlEvents:UIControlEventValueChanged];
    
    if (!self.user) {
        [self.tableView addSubview:self.refreshControl];
    }
    
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
    tweetCell.delegate = self;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.user) {
        return 200.0f;
    } else {
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *profileInformation = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 200)];
    UIImageView *bannerImage = [[UIImageView alloc] initWithFrame:profileInformation.frame];
    [bannerImage setImageWithURL:self.user.backgroundImageURL];
    // Add Banner
    [profileInformation addSubview:bannerImage];
    
    CGFloat midX = profileInformation.frame.size.width/2;
    CGFloat midY = profileInformation.frame.size.height/2;
    
    // Add profile Photo
    UIView *pictureFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    [pictureFrame setCenter:CGPointMake(midX, midY)];
    pictureFrame.backgroundColor = [UIColor whiteColor];
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
    [avatar setImageWithURL:self.user.profileImageURL];
    [pictureFrame addSubview:avatar];
    [profileInformation addSubview:pictureFrame];
    
    UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 17)];
    username.text = self.user.fullName;
    username.textColor = [UIColor whiteColor];
    [username sizeToFit];
    [username setCenter:CGPointMake(midX, midY + pictureFrame.frame.size.height/2 + 15)];
    [profileInformation addSubview:username];
    
    UILabel *screenName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 17)];
    screenName.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    screenName.textColor = [UIColor whiteColor];
    [screenName sizeToFit];
    [screenName setCenter:CGPointMake(midX, midY + pictureFrame.frame.size.height/2 + 35)];
    [profileInformation addSubview:screenName];

    
    
    
    return profileInformation;
}


# pragma mark - TweetViewCellDelegate methods

- (void)showProfile:(User *)profile {
    if (!self.user) {
        TweetsViewController *pvc = [[TweetsViewController alloc] initUserTimeline:profile];
        pvc.title = profile.fullName;
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

@end
