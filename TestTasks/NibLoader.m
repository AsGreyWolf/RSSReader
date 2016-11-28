//
//  NibLoader.m
//  RSSReader
//
//  Created by User on 11/28/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "NibLoader.h"
#import <UIKit/UIKit.h>

@implementation NibLoader

- (id) loadType:(Class)type withNibName:(NSString *)name{
	@try {
		NSArray* elements = [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
		if (!elements) return nil;
		for (int i=0; i < elements.count; i++){
			id obj = [elements objectAtIndex:i];
			if ([obj isKindOfClass:type])
				return obj;
		}
	} @catch (NSException *exception) {
		NSLog(@"%@", exception);
	}
	return nil;
};

@end
