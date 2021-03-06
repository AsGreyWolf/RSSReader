//
//  NibLoader.m
//  RSSReader
//
//  Created by User on 11/28/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "NSObject+NibLoader.h"
#import <UIKit/UIKit.h>

@implementation NSObject (NibLoader)

+ (id) loadType:(Class)type withNibName:(NSString *)name{
	NSArray* elements = [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
	if (!elements) return nil;
	for (id obj in elements){
		if ([obj isKindOfClass:type])
			return obj;
	}
	return nil;
};

@end
