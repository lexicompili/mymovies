//
//  WebServiceRequestManager.h
//  MyMovies
//
//  Created by User on 6/17/15.
//  Copyright (c) 2015 Seer Technologies Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDReachability.h"

@protocol MMHTTPClientProtocol <NSObject>

@optional
-(void) resultFromCall: (NSMutableDictionary *)result;

@end


@interface MMHTTPClient : NSObject

+ (id)sharedManager;

@property (weak) id<MMHTTPClientProtocol> delegate;
@property Reachability *internetReachable;
@property NSObject *owner;

-(void) getMovies:(int) offset;
@end
