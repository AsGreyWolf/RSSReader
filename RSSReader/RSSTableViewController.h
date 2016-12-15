//
//  RSSTableViewController.h
//  RSSReader
//
//  Created by User on 11/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSChannel.h"

@interface RSSTableViewController : UITableViewController

@property (strong,nonatomic) RSSChannel *channel;

@end
