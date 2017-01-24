//
//  UIViewController+UIViewController_showError_h.m
//  RSSReader
//
//  Created by User on 1/24/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "UIViewController+showError.h"

@implementation UIViewController (showError)

- (void)showError:(NSError *)err{
	UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
																	message:NSLocalizedString(@"Can not load RSS", nil)
															 preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil)
											  style:UIAlertActionStyleDestructive
											handler:nil]];
	[self presentViewController:alert animated:true completion:nil];
}

@end
