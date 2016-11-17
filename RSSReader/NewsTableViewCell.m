//
//  NewsTableViewCell.m
//  RSSReader
//
//  Created by User on 11/14/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "NewsTableViewCell.h"

@interface NewsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *text;

@end

@implementation NewsTableViewCell

-(void)setData:(News *)data{
	_data = data;
	self.title.text = data.title;
	self.text.text = data.text;
	self.date.text = [NSDateFormatter localizedStringFromDate:[NSDate date]
													dateStyle:NSDateFormatterShortStyle
													timeStyle:NSDateFormatterShortStyle];
	[self.date sizeToFit];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.title.lineBreakMode = NSLineBreakByTruncatingTail;
	self.text.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
