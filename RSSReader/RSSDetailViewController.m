//
//  RSSDetailViewController.m
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSDetailViewController.h"

@interface RSSDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *linkButton;

@end


@implementation RSSDetailViewController

- (void)setNews:(RSSNews *)news {
	_news = news;
	NSString *date;
	if(news.date){
		date = [NSDateFormatter localizedStringFromDate:news.date
									   dateStyle:NSDateFormatterShortStyle
									   timeStyle:NSDateFormatterShortStyle];
	}else{
		date = @"";
	}
	NSMutableString *text = [NSMutableString stringWithFormat:@"<h1>%@</h1><em>%@</em><p>%@</p>",
							 news.title,
							 date,
							 news.text];
	self.text.attributedText = [[NSAttributedString alloc]
						initWithData: [text dataUsingEncoding:NSUnicodeStringEncoding]
						options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
						documentAttributes: nil
						error: nil
					  ];
	self.title = news.title;
	if(!news.url){
		self.linkButton.enabled = false;
	}
	[self.text setContentOffset:CGPointZero animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.news = self.news;
}

- (IBAction)linkButtonTapped:(id)sender {
	[[UIApplication sharedApplication] openURL:self.news.url];
}

@end
