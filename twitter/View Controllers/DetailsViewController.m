//
//  DetailsViewController.m
//  twitter
//
//  Created by Oore Fasawe on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name.text = self.tweet.user.name;
    self.username.text =  [@"@" stringByAppendingString:self.tweet.user.screenName];
    self.tweetText.text = self.tweet.text;
    
    NSString *profilePictureURLString = self.tweet.user.profilePicture;
        NSString *profilePictureURLStringHighQual = [profilePictureURLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *profilePictureUrl = [NSURL URLWithString:profilePictureURLStringHighQual];

    self.profilePicture.image = nil;
    [self.profilePicture setImageWithURL:profilePictureUrl];
    
    self.profilePicture.layer.masksToBounds = false;
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
    self.profilePicture.clipsToBounds = true;
    self.profilePicture.layer.borderWidth = 0.05;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
