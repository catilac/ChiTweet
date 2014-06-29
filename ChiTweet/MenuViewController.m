//
//  MenuViewController.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/28/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "MenuViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;

@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) UINavigationController *homeTimeline;
@property (strong, nonatomic) UINavigationController *mentionsTimeline;
@property (strong, nonatomic) ProfileViewController *profileView;

- (IBAction)gotoProfile:(id)sender;
- (IBAction)gotoHomeTimeline:(id)sender;
- (IBAction)gotoMentions:(id)sender;

@end

@implementation MenuViewController

static int MenuFullyDisplayedWidth = 194;
static Boolean menuOpen = false;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.profileView = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];
    self.homeTimeline = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
    [self displayContentController:self.homeTimeline];
    self.currentViewController = self.homeTimeline;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openMenu {
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.frame = CGRectMake(MenuFullyDisplayedWidth,
                                            0,
                                            self.contentView.frame.size.width,
                                            self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        menuOpen = YES;
    }];
}

- (void)closeMenu {
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        menuOpen = NO;
    }];

}

- (IBAction)displayMenuOnPan:(UIPanGestureRecognizer *)sender {
    CGPoint vel = [sender velocityInView:self.view];
    if (vel.x > 0 && !menuOpen) {
        [self openMenu];
    } else if (vel.x < 0 && menuOpen) {
        [self closeMenu];
    }

}

- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    CGRect frame = CGRectMake(0, 0,
                              self.contentView.frame.size.width,
                              self.contentView.frame.size.height);
    content.view.frame = frame;
    [self.contentView addSubview:content.view];
    [content didMoveToParentViewController:self];
    self.currentViewController = content;
}

- (void)hideCurrentView {
    if (self.currentViewController != nil) {
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
    }
}

- (IBAction)gotoProfile:(id)sender {
    [self hideCurrentView];
    if (self.profileView == nil) {
        self.profileView = [[ProfileViewController alloc] init];
    }
    [self displayContentController:self.profileView];
    [self closeMenu];
}

- (IBAction)gotoHomeTimeline:(id)sender {
    if (self.homeTimeline == nil) {
        TweetsViewController *tweetsViewController = [[TweetsViewController alloc] initWithAPICall:TwitterHomeTimeline];
        self.homeTimeline = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
    }
    [self displayContentController:self.homeTimeline];
    [self closeMenu];
}

- (IBAction)gotoMentions:(id)sender {
    if (self.mentionsTimeline == nil) {
        TweetsViewController *mentionsViewController = [[TweetsViewController alloc] initWithAPICall:TwitterMentionsTimeline];
        self.mentionsTimeline = [[UINavigationController alloc] initWithRootViewController:mentionsViewController];
    }
    [self displayContentController:self.mentionsTimeline];
    [self closeMenu];
}
@end
