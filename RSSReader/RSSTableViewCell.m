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

@end


@implementation RSSTableViewCell

-(void)setData:(RSSNews *)data{
	_data = data;
	self.title.text = data.title;
	if(data.date)
		self.date.text = [NSDateFormatter localizedStringFromDate:data.date
													dateStyle:NSDateFormatterShortStyle
													timeStyle:NSDateFormatterShortStyle];
	else
		self.date.text = @"";
	[self.date sizeToFit];
	if(data.read){
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else{
		self.accessoryType = UITableViewCellAccessoryDetailButton;
	}
}

- (void)awakeFromNib {
	[super awakeFromNib];
}

@end
