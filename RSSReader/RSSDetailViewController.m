//
//  RSSDetailViewController.m
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSDetailViewController.h"
#import "RSSModelUtils.h"

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
	NSString *text = [NSString stringWithFormat:@"<h1>%@</h1><em>%@</em><p>%@</p>",
							 self.news.title,
							 date,
							 self.news.text];
	[self.webView loadHTMLString:text baseURL:nil];
	self.title = self.news.title;
	if(!self.news.url){
		self.linkButton.enabled = false;
	}
	[RSSModelUtils setRead:true withNews:self.news];
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
	NSString *cssString = @"img { max-width: 100%; } h1 { font-size: 150%; }";
	NSString *javascriptWithCSSString = [NSString stringWithFormat:@"var style = document.createElement('style'); \
										 style.innerHTML = '%@'; \
										 document.head.appendChild(style)", cssString];
	[webView stringByEvaluatingJavaScriptFromString:javascriptWithCSSString];
}

@end
