//
//  RSSTableViewCell.m
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSTableViewCell.h"

@interface RSSTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *text;

@end


@implementation RSSTableViewCell

-(void)setData:(RSSNews *)data{
	_data = data;
	self.title.text = data.title;
	self.text.text = data.text;
	if(data.date)
		self.date.text = [NSDateFormatter localizedStringFromDate:data.date
													dateStyle:NSDateFormatterShortStyle
													timeStyle:NSDateFormatterShortStyle];
	else
		self.date.text = @"";
	[self.date sizeToFit];
	[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	NSString * font = [[self.title.font.fontName stringByReplacingOccurrencesOfString:@"-Bold" withString:@""]  stringByReplacingOccurrencesOfString:@"-Semibold" withString:@""];
	if(!data.read)
		self.title.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold", font] size:self.title.font.pointSize];
	else
		self.title.font = [UIFont fontWithName:font size:self.title.font.pointSize];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.title.lineBreakMode = NSLineBreakByTruncatingTail;
	self.text.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
}

@end
