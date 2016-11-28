//
//  NibLoader.h
//  RSSReader
//
//  Created by User on 11/28/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NibLoader : NSObject

- (id) loadType:(Class)type withNibName:(NSString *)name;

@end
