//
//  TweetsViewController.h
//  ChiTweet
//
//  Created by Chirag Davé on 6/22/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TweetsViewControllerDelegate <NSObject>

- (void)dismissView;

@end

@interface TweetsViewController : UIViewController

@property (nonatomic, weak) id <TweetsViewControllerDelegate> delegate;

@end
