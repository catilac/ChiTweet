//
//  ProfileViewController.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/29/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()

@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numTweets;
@property (weak, nonatomic) IBOutlet UILabel *numFollowing;
@property (weak, nonatomic) IBOutlet UILabel *numFollowers;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.user.backgroundImageURL) {
        [self.bannerImage setImageWithURL:self.user.backgroundImageURL];
    }
    
    [self.profileImage setImageWithURL:self.user.profileImageURL];
    
    self.fullNameLabel.text = self.user.fullName;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    NSLog(@"%@", self.user.numFollowing);
    NSLog(@"%@", self.user.numFollowers);
    NSLog(@"%@", self.user.numTweets);

    self.numFollowing.text = [NSString stringWithFormat:@"%@", self.user.numFollowing];
    self.numFollowers.text = [NSString stringWithFormat:@"%@", self.user.numFollowers];
    self.numTweets.text = [NSString stringWithFormat:@"%@", self.user.numTweets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
