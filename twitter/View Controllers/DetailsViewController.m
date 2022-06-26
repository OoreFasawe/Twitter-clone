//
//  DetailsViewController.m
//  twitter
//
//  Created by Oore Fasawe on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetMediaImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name.text = self.tweet.user.name;
    self.username.text =  [@"@" stringByAppendingString:self.tweet.user.screenName];
    self.tweetText.text = self.tweet.text;
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.likeCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    NSString *profilePictureURLString = self.tweet.user.profilePicture;
        NSString *profilePictureURLStringHighQual = [profilePictureURLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *profilePictureUrl = [NSURL URLWithString:profilePictureURLStringHighQual];

    self.profilePicture.image = nil;
    [self.profilePicture setImageWithURL:profilePictureUrl];
    
    self.profilePicture.layer.masksToBounds = false;
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
    self.profilePicture.clipsToBounds = true;
    self.profilePicture.layer.borderWidth = 0.05;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
            // Convert Date to String
    NSString *tweetDateForm = [formatter stringFromDate:self.tweet.timeSinceNowDate];
            
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *tweetTimeForm = [formatter stringFromDate:self.tweet.timeSinceNowDate];
    
    self.dateLabel.text = [[tweetTimeForm stringByAppendingString:@" . "] stringByAppendingString:tweetDateForm];
    
    
    if(self.tweet.favorited)
    {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    if(self.tweet.retweeted)
    {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    
    if(self.tweet.entities[@"media"] && self.tweet.entities[@"media"][0][@"media_url_https"]){
        
        NSString *tweetMediaImageString = self.tweet.entities[@"media"][0][@"media_url_https"];
        NSURL *tweetMediaImageUrl = [NSURL URLWithString:tweetMediaImageString];
        [self.tweetMediaImage setImageWithURL:tweetMediaImageUrl];
        self.tweetMediaImage.layer.cornerRadius = 10;
        self.tweetMediaImage.layer.borderWidth = 0.05;
        
    }
    else{
        self.tweetMediaImage.image = nil;
        self.tweetMediaImage.hidden = YES;
    }
    
    [self refreshData];
}
- (IBAction)retweetButton:(id)sender {
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
- (IBAction)likeButton:(id)sender {
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
- (IBAction)messageButton:(id)sender {
}

- (void)refreshData{
    self.likeCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
}
@end
