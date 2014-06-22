//
//  TweetsViewController.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/22/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "User.h"

@interface TweetsViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
