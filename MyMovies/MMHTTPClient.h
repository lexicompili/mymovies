//
//  WebServiceRequestManager.h
//  SketchDetective
//
//  Created by User on 6/17/15.
//  Copyright (c) 2015 Seer Technologies Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDReachability.h"

@interface SDHTTPClient : NSObject

+ (id)sharedManager;

//API Calls
-(void) signUpWithFirstName: (NSString *) first_name
                      last_name: (NSString *) last_name
                          email: (NSString *) email
                           pass: (NSString *) pass;
-(void) loginWithEmail: (NSString *) email
                 password: (NSString *) pass;

@property Reachability *internetReachable;
@property NSObject *owner;

@end
