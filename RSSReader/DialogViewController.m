//
//  DialogViewController.m
//  RSSReader
//
//  Created by User on 1/27/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "DialogViewController.h"

@interface DialogViewController (){
	NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation DialogViewController

- (instancetype)init{
	return [super initWithNibName:@"Dialog" bundle:nil];
}

- (void)viewDidLoad {
	self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
	self.container.layer.cornerRadius = 5;
	self.container.layer.shadowOpacity = 0.8;
	self.container.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
																			action:@selector(didOutsideTapped:)]];
    [super viewDidLoad];
}

- (void)showInView:(UIView *)aView withTitle:(NSString*)title withText:(NSString*)text
{
	self.view.bounds = aView.bounds;
	self.view.center = aView.center;
	self.titleLabel.text = title;
	self.text.text = text;
	[aView addSubview:self.view];
	self.container.transform = CGAffineTransformMakeRotation(90);
	self.view.alpha = 0;
	[UIView animateWithDuration:.25 animations:^{ //TODO:transitionCoordinator
		self.view.alpha = 1;
		self.container.transform = CGAffineTransformMakeRotation(0);
	}];
	_timer = [NSTimer scheduledTimerWithTimeInterval:2.0
											  target:self
											selector:@selector(close)
											userInfo:nil
											 repeats:NO];
}

- (void)close {
	[_timer invalidate];
	[UIView animateWithDuration:.25 animations:^{//TODO:transitionCoordinator
		self.container.transform = CGAffineTransformMakeRotation(90);
		self.view.alpha = 0.0;
	} completion:^(BOOL finished) {
		if (finished) {
			[self.view removeFromSuperview];
		}
	}];
}

- (void)didOutsideTapped:(UITapGestureRecognizer *)recognizer {
	[self close];
}
@end
