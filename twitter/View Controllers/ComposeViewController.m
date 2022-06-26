//
//  ComposeViewController.m
//  twitter
//
//  Created by Oore Fasawe on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.composeTextField.delegate = self;
    self.composeTextField.layer.borderWidth = 1;
    self.composeTextField.layer.cornerRadius = 10;
    self.composeTextField.layer.borderColor = UIColor.blackColor.CGColor;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 280;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.composeTextField.text stringByReplacingCharactersInRange:range withString:text];
    self.charRemainingLabel.text = [NSString stringWithFormat:@"%d", (int)(characterLimit - newText.length) ];
    
    if(characterLimit - newText.length < 15){
        self.charRemainingLabel.text = [NSString stringWithFormat:@"You've got %d characters left", (int)(characterLimit - newText.length)];
        self.charRemainingLabel.textColor = UIColor.redColor;
    }
    else
    {
        self.charRemainingLabel.textColor = UIColor.blueColor;
    }
    return newText.length < characterLimit;
}

- (IBAction)composeTweet:(id)sender {
    [[APIManager shared] postStatusWithText:(self.composeTextField.text) completion:^(Tweet *tweet, NSError *error){
    }];
    [self dismissViewControllerAnimated:true completion:nil];
        
}
- (IBAction)cancelTweet:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
