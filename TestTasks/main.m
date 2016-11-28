//
//  main.m
//  RSSReader
//
//  Created by User on 11/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "NibLoader.h"
#import <UIKit/UIKit.h>

int main2(int argc, char * argv[]) {
	@autoreleasepool {
		NibLoader *loader = [NibLoader new];
		id value = [loader loadType:[UITableViewCell class] withNibName:@"RSSTableViewCell"];
		NSLog(@"%@",value);
	}
	return 0;
}
