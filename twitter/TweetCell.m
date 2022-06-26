//
//  TweetCell.m
//  twitter
//
//  Created by Oore Fasawe on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "DateTools.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited)
    {
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {}];
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    else
    {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {}];
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    [self refreshData];
}
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted)
    {
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {}];
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    else{
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {}];
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    [self refreshData];
}


- (void)refreshData{
    self.numLikes.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.numRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
