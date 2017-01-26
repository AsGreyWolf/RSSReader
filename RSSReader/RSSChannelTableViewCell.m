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
@property (weak, nonatomic) IBOutlet UILabel *counter;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

@implementation RSSChannelTableViewCell

-(void)setChannel:(RSSChannel *)channel{
	_channel = channel;
	self.title.text = channel.name;
	int unread = channel.unreadCount;
	self.counter.hidden = unread == 0;
	self.counter.text = [NSString stringWithFormat:@"%d", unread];
	self.image.image = [ImagePool imageWithUrl:channel.image];
}

@end
