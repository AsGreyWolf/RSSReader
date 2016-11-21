//
//  RSSDetailViewController.m
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSDetailViewController.h"

@interface RSSDetailViewController ()

@end

@implementation RSSDetailViewController

- (void)setNews:(RSSNews *)news {
	_news = news;
	NSMutableString *text = [NSMutableString stringWithFormat:@"<h1>%@</h1><em>%@</em><p>%@</p>", news.title,
							 [NSDateFormatter localizedStringFromDate:news.date
															dateStyle:NSDateFormatterShortStyle
															timeStyle:NSDateFormatterShortStyle],
							 news.text];
	self.text.attributedText = [[NSAttributedString alloc]
						initWithData: [text dataUsingEncoding:NSUnicodeStringEncoding]
						options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
						documentAttributes: nil
						error: nil
					  ];
	self.title = news.title;
	self.titleBar.title = news.title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.news = self.news;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
