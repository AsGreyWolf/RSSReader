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
	if(self.viewLoaded){
		[self update];
	}
}

- (void)update{
	NSString *date;
	if(self.news.date){
		date = [NSDateFormatter localizedStringFromDate:self.news.date
											  dateStyle:NSDateFormatterShortStyle
											  timeStyle:NSDateFormatterShortStyle];
	}else{
		date = @"";
	}
	NSMutableString *text = [NSMutableString stringWithFormat:@"<h1>%@</h1><em>%@</em><p>%@</p>",
							 self.news.title,
							 date,
							 self.news.text];
	self.text.attributedText = [[NSAttributedString alloc]
								initWithData: [text dataUsingEncoding:NSUnicodeStringEncoding]
								options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
								documentAttributes: nil
								error: nil
								];
	self.title = self.news.title;
	if(!self.news.url){
		self.linkButton.enabled = false;
	}
	self.news.read = true;
	CGPoint point = self.text.contentOffset;
	point.y = -64;  // FIXME: do smth less stupid
	[self.text setContentOffset:point animated:NO];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self update];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	CGPoint point = self.text.contentOffset;
	point.y = -64;  // FIXME: do smth less stupid
	[self.text setContentOffset:point animated:animated];  // FIXME: scrolls after show
}

- (IBAction)linkButtonTapped:(id)sender {
	[[UIApplication sharedApplication] openURL:self.news.url];
}

@end
