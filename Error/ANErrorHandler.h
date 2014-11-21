//
//  CDErrorHandler.h
//
//  Created by Oksana Kovalchuk on 4/7/14.
//  Copyright (c) 2014 ANODA. All rights reserved.
//

typedef NS_ENUM (NSInteger, ANServerErrorCode)
{
    CDServerErrorCodeCouldntComplete = 202
};

@interface ANErrorHandler : NSObject

/**
 *  Handles only errors that come from api.ctrldo.com
 *
 *  @param error CDError object initialized from server respose
 */
+ (void)handleNetworkServerError:(CDError*)error;


/**
 *  Handles only errors that sends Cocoa Network Framework and NSURLSession
 *
 *  @param error NSError object from thrown error
 */

+ (void)handleNetworkApplicationError:(NSError*)error;

+ (void)handleApplicationError:(NSError*)error;

+ (void)handleInternalError:(NSError*)error;

+ (void)handleCoreDataInternalError:(NSError*)error;

@end
