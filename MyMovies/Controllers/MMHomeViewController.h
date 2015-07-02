//
//  MMHomeViewController.h
//  MyMovies
//
//  Created by Mary Alexis Solis on 7/2/15.
//  Copyright (c) 2015 Mary Alexis Solis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMHomeView.h"
#import "MMHTTPClient.h"

@interface MMHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MMHTTPClientProtocol>

@property MMHomeView *homeView;
@property MMHTTPClient * webServiceManager;
@property NSMutableArray *movies;
@property int offset;

@end
