//
//  UIViewController+UIViewController_showError_h.m
//  RSSReader
//
//  Created by User on 1/24/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "UIViewController+showError.h"
#import "DialogViewController.h"

@implementation UIViewController (showError)

- (void)showError:(NSError *)err{
//	UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
//																	message:NSLocalizedString(@"Can not load RSS", nil)
//															 preferredStyle:UIAlertControllerStyleAlert];
//	[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil)
//											  style:UIAlertActionStyleCancel
//											handler:nil]];
//	[self presentViewController:alert animated:true completion:nil];
	static DialogViewController *controller;
	controller =[DialogViewController new];
	UIView *view = self.view.window.rootViewController.view;
	[controller showInView:view
				 withTitle:NSLocalizedString(@"Error", nil)
				  withText:NSLocalizedString(@"Can't load rss", nil)];
	[view autoresizesSubviews];
}

@end
