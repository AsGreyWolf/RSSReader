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
		id value = [NSObject loadType:[UITableViewCell class] withNibName:@"RSSTableViewCell"];
		NSLog(@"%@",value);
	}
	return 0;
}
