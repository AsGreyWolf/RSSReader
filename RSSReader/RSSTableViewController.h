//
//  RSSTableViewController.h
//  RSSReader
//
//  Created by User on 11/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSLoader.h"

@interface RSSTableViewController <RSSLoaderDelegate> : UITableViewController

@property(strong, nonatomic) NSArray* newsList;

@end
