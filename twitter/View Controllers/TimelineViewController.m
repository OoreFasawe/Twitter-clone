//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DateTools.h"
#import "DetailsViewController.h"


@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong)UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController
- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchTweets{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets.count > 0) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = (NSMutableArray *) tweets;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
        
    }];
}




- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];

    tweetCell.tweetText.text = tweet.text;
    tweetCell.textWithLink.text = tweet.text;
    tweetCell.author.text = tweet.user.name;
    tweetCell.username.text = [@"@" stringByAppendingString:tweet.user.screenName];
    tweetCell.numRetweets.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    tweetCell.numLikes.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    tweetCell.tweet = tweet;
    tweetCell.timeSinceTweetLabel.text = [@". " stringByAppendingString:[tweet.timeSinceNowDate shortTimeAgoSinceNow]];
    NSString *profilePictureURLString = tweet.user.profilePicture;
    NSString *profilePictureURLStringHighQual = [profilePictureURLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *profilePictureUrl = [NSURL URLWithString:profilePictureURLStringHighQual];

    tweetCell.profilePicture.image = nil;
    [tweetCell.profilePicture setImageWithURL:profilePictureUrl];
    
    tweetCell.profilePicture.layer.masksToBounds = false;
    tweetCell.profilePicture.layer.cornerRadius = tweetCell.profilePicture.frame.size.width/2;
    tweetCell.profilePicture.clipsToBounds = true;
    tweetCell.profilePicture.layer.borderWidth = 0.05;
    if(tweetCell.tweet.favorited)
    {
        [tweetCell.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }
    else{
        [tweetCell.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    if(tweetCell.tweet.retweeted)
    {
        [tweetCell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }
    else{
        [tweetCell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    
    return tweetCell;
}

#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ComposeViewController"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if([[segue identifier] isEqualToString:@"DetailsViewController"]){
        UITableViewCell *tweetCell = sender;
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:tweetCell];
        // Pass the selected object to the new view controller.
        Tweet *tweet = self.arrayOfTweets[myIndexPath.row];
        DetailsViewController *detailsController = [segue destinationViewController];
        detailsController.tweet = tweet;
    }
}

@end
