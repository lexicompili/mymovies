//
//  WebServiceRequestManager.m
//  SketchDetective
//
//  Created by User on 6/17/15.
//  Copyright (c) 2015 Seer Technologies Inc. All rights reserved.
//

#import "SDHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "SDGameLogic.h"

@implementation SDHTTPClient

#pragma mark - BASE URL
static NSString * const BASE_URL_DEV = @"http://0.0.0.0:5000";
static NSString * const BASE_URL_PROD = @"http://0.0.0.0:5000";

#pragma mark - PATH URL
//Sign Up and Login
static NSString * const PATH_URL_LOGIN = @"/logIn";
static NSString * const PATH_URL_SIGN_UP = @"/signUp";
static NSString * const PATH_URL_SAMPLE= @"/confirmEmail";
static NSString * const PATH_URL_GET_PRODUCT_BY_ID = @"/confirmEmail";
static NSString * const PATH_URL_GET_ALL_PRODUCTS = @"/confirmEmail";

#pragma mark Singleton Methods
+ (id)sharedManager {
    static SDHTTPClient *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


#pragma mark - Internet Reachable
- (void)testInternetConnection:(void (^) (NSString * response))handler
{
    self.internetReachable = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    self.internetReachable.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
            handler(@"YES");
            
        });
    };
    
    // Internet is not reachable
    self.internetReachable.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(@"NO");
        });
    };
    
    [self.internetReachable startNotifier];
}

#pragma mark - HTTP Request POST and GET
-(BOOL) HTTPRequest: (NSString *) requestType withPath:(NSString *) path withParameters:(NSDictionary *) param withCallbackFunction: (NSString *) callback
{
    
    [self testInternetConnection:^(NSString *response)
     {
         NSLog(@"param: %@",param);
         if([response  isEqualToString:@"YES"])
         {
             NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_DEV, path];
             
             AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             
             
             if([requestType isEqualToString:@"POST"])
             {
                 //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                 //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                 manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                 [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
                     NSMutableDictionary * response = [[NSMutableDictionary alloc] init];
                     [response setObject:@"SUCCESS" forKey:@"status"];
                     [response addEntriesFromDictionary:responseObject];
                     
                     SEL callbackFunction;
                     callbackFunction = NSSelectorFromString([callback stringByAppendingString:@":"]);
                     
                     #pragma clang diagnostic push
                     #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                     [self performSelector:callbackFunction withObject:response];
                     #pragma clang diagnostic pop
                     
                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     
                     NSMutableDictionary * response = [[NSMutableDictionary alloc] init];
                     [response setObject:@"FAIL" forKey:@"status"];
                     [response setObject:error forKey:@"data"];
                     
                     SEL callbackFunction;
                     callbackFunction = NSSelectorFromString([callback stringByAppendingString:@":"]);
                     
                     #pragma clang diagnostic push
                     #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                     [self performSelector:callbackFunction withObject:response];
                     #pragma clang diagnostic pop
                     
                 }];
                 
             }
             else if([requestType isEqualToString:@"GET"])
             {
                 //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                 //[manager.requestSerializer setValue:@"multi/json" forHTTPHeaderField:@"Accept"];
                 manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                 [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
                     NSMutableDictionary * response = [[NSMutableDictionary alloc] init];
                     [response setObject:@"SUCCESS" forKey:@"status"];
                     [response addEntriesFromDictionary:responseObject];
                     
                     SEL callbackFunction;
                     callbackFunction = NSSelectorFromString([callback stringByAppendingString:@":"]);
                     
                     #pragma clang diagnostic push
                     #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                     [self performSelector:callbackFunction withObject:response];
                     #pragma clang diagnostic pop
                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     
                     NSMutableDictionary * response = [[NSMutableDictionary alloc] init];
                     [response setObject:@"FAIL" forKey:@"status"];
                     [response setObject:error forKey:@"data"];
                     
                     SEL callbackFunction;
                     callbackFunction = NSSelectorFromString([callback stringByAppendingString:@":"]);
                     
                     #pragma clang diagnostic push
                     #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                     [self performSelector:callbackFunction withObject:response];
                     #pragma clang diagnostic pop
                     
                 }];
             }
             
         }
         else if([response isEqualToString:@"NO"])
         {
             [self noConnectionCallback];
         }
     }];
    
    return NO;
}



#pragma mark - No Internet Connection
-(void) noConnectionCallback
{
    UIAlertView *message = [[UIAlertView alloc]
                            initWithTitle:@"No Connection"
                            message:@"Cannot connect to server."
                            delegate:nil
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil];
    [message show];
}

#pragma mark - API Calls
//Login and SignUp
-(void) loginWithEmail: (NSString *) email
                 password: (NSString *) pass
{
    NSDictionary *parameters = @{ @"email":email, @"password": pass};
    [self HTTPRequest:@"POST" withPath:PATH_URL_LOGIN withParameters:parameters withCallbackFunction:@"loginWithEmailCallback"];
}

-(void) signUpWithFirstName: (NSString *) first_name
                      last_name: (NSString *) last_name
                          email: (NSString *) email
                           pass: (NSString *) pass
{
    NSDictionary *parameters = @{@"email":email, @"f_name": first_name, @"l_name": last_name,  @"pass": pass, @"email":email};
    
    [self HTTPRequest:@"GET" withPath:PATH_URL_SIGN_UP withParameters:parameters withCallbackFunction:@"signUpWithFirstNameCallback"];
}

//Product Authentication
-(void) getAllProducts: (int) account_id
{
    NSDictionary *parameters = @{@"format": @"json", @"account_id":[NSNumber numberWithInt:account_id]};
    [self HTTPRequest:@"GET" withPath:PATH_URL_GET_ALL_PRODUCTS withParameters:parameters withCallbackFunction:@"loginWithEmailCallback"];
}


-(void) getProductById:(int) product_id withAccountId:(int) account_id
{
    NSDictionary *parameters = @{@"format": @"json", @"id":[NSNumber numberWithInt:product_id], @"account_id":[NSNumber numberWithInt:account_id]};
    [self HTTPRequest:@"GET" withPath:PATH_URL_GET_PRODUCT_BY_ID withParameters:parameters withCallbackFunction:@"getProductByIdCallback"];
}


#pragma mark - API Callback Functions
// Login and Sign Up
-(void) loginWithEmailCallback:(NSDictionary *) data
{
//    if([[data objectForKey:@"status"] isEqualToString:@"SUCCESS"])
//    {
//        NSLog(@"success data: %@",data);
//    }
//    else if([[data objectForKey:@"status"] isEqualToString:@"FAIL"])
//    {
//        NSLog(@"fail data: %@",data);
//    }
}

-(void) signUpWithFirstNameCallback:(NSDictionary *) data
{
    if([[data objectForKey:@"status"] isEqualToString:@"SUCCESS"])
    {
        NSLog(@"success data: %@", data);

    }
    else if([[data objectForKey:@"status"] isEqualToString:@"FAIL"])
    {
        NSLog(@"fail data: %@",[[data objectForKey:@"data"]  objectForKey:@"token"]);
    }
}

//Product Authentication
-(void) getAllProductsCallBack:(NSDictionary *) data
{
    if([[data objectForKey:@"status"] isEqualToString:@"SUCCESS"])
    {
        SDGameLogic *game_logic = (SDGameLogic *) self.owner;
        NSArray *products = [NSArray arrayWithObject:[data objectForKey:@"products"]];
        [game_logic.database insertProducts:products];
    }
    else
    {
        NSLog(@"sampleCallBack post fail:%@",data);
    }
}

-(void) getProductByIdCallBack:(NSDictionary *) data
{
    if([[data objectForKey:@"status"] isEqualToString:@"SUCCESS"])
    {
        SDGameLogic *game_logic = (SDGameLogic *) self.owner;
        
        NSArray *products = [NSArray arrayWithObject:[data objectForKey:@"products"]];
        [game_logic.database insertProducts:products];
    }
    else
    {
        NSLog(@"sampleCallBack post fail:%@",data);
    }
}


@end
