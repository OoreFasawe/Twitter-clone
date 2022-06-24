//
//  ComposeViewController.h
//  twitter
//
//  Created by Oore Fasawe on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate <NSObject>

- (void)didTweet:(Tweet *)tweet;

@end
@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *composeTextField;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *charRemainingLabel;

@end

NS_ASSUME_NONNULL_END
