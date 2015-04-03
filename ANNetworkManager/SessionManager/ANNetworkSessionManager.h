//
//  ANNetworkSessionManager.h
//
//  Created by Oksana Kovalchuk on 5/18/14.
//  Copyright (c) 2014 ANODA. All rights reserved.
//

@class RACSignal;
@protocol RACSubscriber;

#import "ANNetworkRequest.h"

@interface ANNetworkSessionManager : NSObject

+ (instancetype)shared;

// Methods for Child

- (void)setBaseURL:(NSString*)baseURL andAPIVersion:(NSString*)apiVersion;
//override
- (void)handleResponse:(NSDictionary*)response subscriber:(id<RACSubscriber>)subscriber;

/**
 *  Sends HTPP request without any parameters, sets properly Token
 *
 *  @param path       NSString* URL Path for request
 *  @param httpMethod enum ANHttpMethodType HTPP method for request - GET/POST/DELETE
 *
 *  @return RACSignal* signal on completion with serilialized response
 */

- (RACSignal*)requestWithPath:(NSString*)path httpMethod:(ANHttpMethodType)httpMethod;


/**
 *  Sends HTPP request without any parameters, sets properly Token
 *
 *  @param path       NSString* URL Path for request
 *  @param httpMethod enum ANHttpMethodType HTPP method for request - GET/POST/DELETE
 *  @param params     NSDictionary provided parameters for request, encoded - filedName : value
 *
 *  @return RACSignal* signal on completion with serilialized response
 */
- (RACSignal*)requestWithPath:(NSString*)path
                   parameters:(NSDictionary*)params
                   httpMethod:(ANHttpMethodType)httpMethod;

/**
 *  Uploads specified photo on server and returns link
 *
 *  @param photoFileLink NSString - absolute path for file on device
 *  @param path          NSString* URL Path for request
 *  @param params        NSDictionary params for request, encoded - filedName : value
 *
 *  @return RACSignal* signal on completion with NSString value for this photo link
 */

- (RACSignal*)uploadPhoto:(NSString*)photoFileLink path:(NSString*)path parameters:(NSDictionary*)params;


- (RACSignal*)loadRequest:(ANNetworkRequest*)request;
- (void)injectSideEffectToRequest:(ANNetworkRequest*)request;

@end
