//
//  RSSChannelTableViewCell.m
//  RSSReader
//
//  Created by User on 12/23/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSChannelTableViewCell.h"
#import "ImagePool.h"

@interface RSSChannelTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

@implementation RSSChannelTableViewCell

-(void)setChannel:(RSSChannel *)channel{
	_channel = channel;
	self.title.text = channel.name;
	int unread = 0;
	for(RSSNews *news in channel.news){
		if(!news.read) unread++;
	}
	if(unread>0){
		self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		self.title.text = [NSString stringWithFormat:@"(%d)%@", unread, self.title.text];
	}
	else{
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	if(channel.image != nil){
		self.image.image = [ImagePool imageWithUrl:channel.image];
	}
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
