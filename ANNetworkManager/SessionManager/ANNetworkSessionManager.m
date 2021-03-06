//
//  ANNetworkSessionManager.m
//
//  Created by Oksana Kovalchuk on 5/18/14.
//  Copyright (c) 2014 ANODA. All rights reserved.
//

#import "ANNetworkSessionManager.h"
#import "ANNetworkActivityManager.h"
#import "ReactiveCocoa.h"

@interface ANNetworkSessionManager () <NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSession* session;

@end

@implementation ANNetworkSessionManager

+ (instancetype)shared
{
    static id _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [self new];
    });
    return _sharedClient;
}

- (void)setBaseURL:(NSString*)baseURL andAPIVersion:(NSString*)apiVersion
{
    [ANNetworkRequest setBaseURL:baseURL andAPIVersion:apiVersion];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.allowsCellularAccess = YES;
        sessionConfig.timeoutIntervalForRequest = 30.0;
        sessionConfig.timeoutIntervalForResource = 60.0;
        sessionConfig.HTTPMaximumConnectionsPerHost = 8;
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig];
    }
    return self;
}

#pragma mark - Public

- (RACSignal *)requestWithPath:(NSString *)path httpMethod:(ANHttpMethodType)httpMethod
{
    return [self requestWithPath:path parameters:nil httpMethod:httpMethod];
}

- (RACSignal*)requestWithPath:(NSString*)path parameters:(NSDictionary *)params httpMethod:(ANHttpMethodType)httpMethod
{
    ANNetworkRequest* request = [ANNetworkRequest requestWithPath:path parameters:params httpMethod:httpMethod];
    return [self loadRequest:request];
}

- (RACSignal*)loadRequest:(ANNetworkRequest *)request
{
    [self injectSideEffectToRequest:request];
    return [self requestWithURLSession:self.session request:request];
}

- (void)injectSideEffectToRequest:(ANNetworkRequest*)request
{
    //
}



#pragma mark - Private

- (RACSignal*)requestWithURLSession:(NSURLSession*)session request:(ANNetworkRequest*)request
{
    NSString* requestDescription = [NSString stringWithFormat:@"URI: %@\n HTTP METHOD: %@\n",
                                    request.URL.absoluteString,
                                    request.HTTPMethod];
    
    RACSignal* signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[ANNetworkActivityManager shared] incrementActivityCount];
        
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            [[ANNetworkActivityManager shared] decrementActivityCount];
            
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if (!error)
            {
                NSError *parseError = nil;
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:0
                                                                                 error:&parseError];
                
                [self logResponse:httpResponse description:requestDescription json:jsonDictionary];

                if (!parseError)
                {
                    [self handleResponse:jsonDictionary subscriber:subscriber];
                }
                else
                {
                    [self handleError:error subscriber:subscriber];
                }
            }
            else
            {
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                userInfo[@"requestDescription"] = requestDescription;
                NSError* taskError = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
                [self handleError:taskError subscriber:subscriber];
            }
        }];
        
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    signal.name = requestDescription;
    return signal;
}


#pragma mark - Logging & handling

- (void)handleResponse:(NSDictionary*)response subscriber:(id<RACSubscriber>)subscriber
{
    //override
    NSString * reason = [NSString stringWithFormat:@"%@ should implement %@ method\n",
                         NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    NSException * exc =
    [NSException exceptionWithName:@"Override exception"
                            reason:reason
                          userInfo:nil];
    [exc raise];

}

- (void)logResponse:(NSHTTPURLResponse*)httpResponse description:(NSString*)description json:(NSDictionary*)json
{

}


#pragma mark - Override

- (void)handleNetworkError:(NSError*)error subscriber:(id<RACSubscriber>)subscriber
{
    [subscriber sendError:error];
}

- (void)handleError:(NSError*)error subscriber:(id<RACSubscriber>)subscriber
{
    NSString * reason = [NSString stringWithFormat:@"%@ should implement %@ method\n",
                         NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    NSException * exc =
    [NSException exceptionWithName:@"Override exception"
                            reason:reason
                          userInfo:nil];
    [exc raise];
}

#pragma mark - Photo Uploading

- (RACSignal*)uploadPhoto:(UIImage*)photoFile path:(NSString*)path parameters:(NSDictionary*)params
{
    if (!photoFile)
    {
        return [RACSignal empty];
    }
    ANNetworkRequest* request = [ANNetworkRequest requestMultipartWithPath:path photo:photoFile];
    return [self loadRequest:request];
}

@end
