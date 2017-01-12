//
//  RSSDetailViewController.m
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSDetailViewController.h"

@interface RSSDetailViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *linkButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

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
	[self.webView loadHTMLString:text baseURL:nil];
	self.title = self.news.title;
	if(!self.news.url){
		self.linkButton.enabled = false;
	}
	self.news.read = true;
}

- (void)viewDidLoad{
	[super viewDidLoad];
	self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
	self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self update];
}

- (IBAction)linkButtonTapped:(id)sender {
	[[UIApplication sharedApplication] openURL:self.news.url];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return false;
	}
	return true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[webView stringByEvaluatingJavaScriptFromString:
	 @"var images = document.getElementsByTagName(\"img\"); \
	 for(var i=0; i<images.length;i++) \
		images[i].style.maxWidth = \"100%\";"
	 ];
}

@end
