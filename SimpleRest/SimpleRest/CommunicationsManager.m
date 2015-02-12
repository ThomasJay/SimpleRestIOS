//
//  CommunicationsManager.m
//  SimpleRest
//
//  Created by Tom Jay on 2/10/15.
//  Copyright (c) 2015 Tom Jay. All rights reserved.
//

#import "CommunicationsManager.h"
#import "NSString+Utils.h"
#import "NSDictionary+Utils.h"
#import "NSArray+Utils.h"
#import "NSData+Utils.h"

#define kCOMMUNICATIONS_HTTP_MODE @"http"
#define kCOMMUNICATIONS_SERVER @"10.21.128.38:8080"
#define kTIMEOUT            10.0

@interface CommunicationsManager() {
    
}

@property (strong, nonatomic) NSOperationQueue *operationQueue;


@end

@implementation CommunicationsManager



+(CommunicationsManager *) sharedCommunicationsManager {
    
    static dispatch_once_t once;
    
    static CommunicationsManager *instance;
    
    dispatch_once(&once, ^{
        instance = [[CommunicationsManager alloc] init];
    });
    
    return instance;
}

- (id)init {
    
    self = [super init];
    if (self) {
        
        // Create a communications queue for REST Messages
        self.operationQueue = [NSOperationQueue new];
        self.operationQueue.MaxConcurrentOperationCount = 1;
        
    }
    return self;
}

- (void) getUserDataForParams:(NSDictionary *) params callback:(void (^)(NSError *error, NSDictionary *values))callback {
    
    NSLog(@"CommunicationsManager::getUserDataForParams started");
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"callback"] = callback;
    parameters[@"inputParams"] = params;
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(getUserDataRestService:)
                                                                              object:parameters];
    // Add the operation to the queue and let it to be executed.
    [self.operationQueue addOperation:operation];
}


-(void) getUserDataRestService:(NSMutableDictionary *)params {
    
    NSLog(@"CommunicationsManager::getUserDataRestService started with params=%@", params);
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSDictionary *inputParams = params[@"inputParams"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@://%@/SimpleRestService/services/v1/users/%@", kCOMMUNICATIONS_HTTP_MODE, kCOMMUNICATIONS_SERVER, inputParams[@"userId"]];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSLog(@"CommunicationsManager::getUserDataRestService url=%@", urlString);
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest addValue: @"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest addValue: @"SECRET" forHTTPHeaderField:@"X-AUTH-TOKEN"];
    urlRequest.timeoutInterval = kTIMEOUT;
    
    
    NSData *responseData;
    NSInteger statusCode = 0;
    
    void (^callback)(NSError *error, NSDictionary *values) = params[@"callback"];
    
    responseData= [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"CommunicationsManager::getUserDataRestService error - %@", error.description);
    }
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    statusCode = [httpResponse statusCode];
    
    NSLog(@"CommunicationsManager::getUserDataRestService statusCode=%ld", (long)statusCode);
    
    
    
    if (statusCode == 200 || statusCode == 400) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"CommunicationsManager::getUserDataRestService Returned responseString=%@", responseString);
        
        // Cleanup any null values in json
        responseString = [responseString stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
        
        NSDictionary *responseDictionary = [responseString jsonStringToObject];
        
        
        if (statusCode == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{ callback(nil, responseDictionary); });
        }
        else {
            
            NSString *errorString = @"Unknown Server Error";
            
            if (responseDictionary[@"status"] != nil) {
                errorString = responseDictionary[@"status"];
            }
            
            NSError *error = [NSError errorWithDomain:@"Server Communications" code:statusCode userInfo:[NSDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey]];
            
            dispatch_async(dispatch_get_main_queue(), ^{ callback(error, responseDictionary); });
        }
        
        
    }
    else {
        
        NSLog(@"CommunicationsManager::getUserDataRestService status code error: %@ code:%ld",error, (long)statusCode);
        
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(error, nil);
                });
    }
    
    
}



@end
