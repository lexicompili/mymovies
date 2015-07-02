//
//  WebServiceRequestManager.m
//  MyMovies
//
//  Created by User on 6/17/15.
//  Copyright (c) 2015 Seer Technologies Inc. All rights reserved.
//

#import "MMHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@implementation MMHTTPClient


static NSString * const PATH_GET_MOVIE = @"/wabz/guide.php";

#pragma mark Singleton Methods
+ (id)sharedManager {
    static MMHTTPClient *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


-(void) HTTPCall: (int) offset
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    id url = @"http://www.whatsbeef.net/wabz/guide.php";
    id params = @{@"start": [@(offset) stringValue]};
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        [self getMoviesCallback:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}


#pragma mark - API Calls
-(void) getMovies:(int) offset
{

    [self HTTPCall:offset];

}

-(void) getMoviesCallback:(NSMutableDictionary *) data

{
    [self.delegate resultFromCall:data];
}

@end
