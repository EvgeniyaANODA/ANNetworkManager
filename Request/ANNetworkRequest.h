//
//  ANNetworkRequest.h
//
//  Created by Oksana Kovalchuk on 5/18/14.
//  Copyright (c) 2014 ANODA. All rights reserved.
//

#pragma mark - HTTP Method Type

extern NSString* const kAuthTokenHeader;
extern NSString* const kMultipartFormBoundary;

#import "ANApiRoutes.h"

NSString* ANHttpMethodTypeStringFromEnumValue(ANHttpMethodType);
ANHttpMethodType ANHttpMethodTypeEnumValueFromSrting(NSString*);

@interface ANNetworkRequest : NSMutableURLRequest

@property (nonatomic, strong) NSString* token;

+ (instancetype)requestWithPath:(NSString *)path
                     parameters:(NSDictionary*)params
                     httpMethod:(ANHttpMethodType)httpMethodType;

+ (instancetype)requestMultipartWithPath:(NSString*)path photo:(UIImage*)photo;

- (instancetype)initWithPath:(NSString*)path
                  parameters:(NSDictionary*)params
                  httpMethod:(ANHttpMethodType)httpMethodType;

@end
