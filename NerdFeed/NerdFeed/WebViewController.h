//
//  WebViewController.h
//  NerdFeed
//
//  Created by Luis Carbuccia on 8/31/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSString *title;

@end
