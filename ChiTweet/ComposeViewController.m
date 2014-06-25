//
//  ComposeViewController.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/24/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "TwitterClient.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UITextView *tweet;
@property (nonatomic, strong) UILabel *charLimit;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self action:@selector(postTweet)];
    self.charLimit = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
    self.charLimit.textAlignment = NSTextAlignmentRight;
    self.charLimit.text = @"140";
    self.navigationItem.titleView = self.charLimit;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.tweet];

    
    User *user = [User currentUser];
    self.fullName.text = user.fullName;
    self.screenName.text = user.screenName;
    [self.userImage setImageWithURL:user.profileImageURL];
    [self.tweet setContentInset:UIEdgeInsetsMake(2.0, 1.0, 0, 0)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void)textViewDidChange:(UITextView *)textView {
    // Update the character count
    int characterCount = 140 - [[self.tweet text] length];
    [self.charLimit setText:[NSString stringWithFormat:@"%d", characterCount]];
    
    
    // Check if the count is over the limit
    if(characterCount < 0) {
        // Change the color
        [self.charLimit setTextColor:[UIColor redColor]];
    }
    else if(characterCount < 20) {
        // Change the color to yellow
        [self.charLimit setTextColor:[UIColor orangeColor]];
    }
    else {
        // Set normal color
        [self.charLimit setTextColor:[UIColor blackColor]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postTweet {
    [[TwitterClient instance] postTweet:self.tweet.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error Posting Tweet");
    }];
}

@end
