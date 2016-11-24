//
//  RSSDetailViewController.h
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "RSSNews.h"

@interface RSSDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *linkButton;

@property(nonatomic) RSSNews* news;

@end
