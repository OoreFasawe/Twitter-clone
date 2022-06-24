//
//  DetailsViewController.h
//  twitter
//
//  Created by Oore Fasawe on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic,strong) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
