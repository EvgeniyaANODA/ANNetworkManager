//
//  ANError.m
//
//  Created by Oksana Kovalchuk on 5/16/14.
//  Copyright (c) 2014 ANODA. All rights reserved.
//

#import "ANError.h"

NSString* const kErrorCodeKey = @"code";
NSString* const kErrorMessageKey = @"message";
NSString* const kErrorDomain = @"";

@implementation ANError

+ (instancetype)apiErrorWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:dictionary[kErrorMessageKey],
                              kErrorMessageKey, nil];

    return [ANError errorWithDomain:kErrorDomain
                                  code:[dictionary[kErrorCodeKey] integerValue]
                              userInfo:userInfo];
}

+ (instancetype)errorWithKey:(NSString *)key
{
    NSDictionary* userInfo = @{kErrorMessageKey : key};
    
    return [ANError errorWithDomain:kErrorDomain code:0 userInfo:userInfo];
}

@end
