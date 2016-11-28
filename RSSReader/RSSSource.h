//
//  RSSSource.h
//  RSSReader
//
//  Created by User on 11/28/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSSourceDelegate.h"

@interface RSSSource : NSObject

@property (nonatomic, weak) id <RSSSourceDelegate> delegate;

- (void)refresh;
- (id)initWithURL:(NSURL*)url;

+ (id)sourceWithURL:(NSURL*)url;

@end
