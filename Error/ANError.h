//
//  ANError.h
//
//  Created by Oksana Kovalchuk on 5/16/14.
//  Copyright (c) 2014 ANODA. All rights reserved.
//

#pragma mark - HTTP Server Responce Error Keys

extern NSString* const kErrorCodeKey;
extern NSString* const kErrorMessageKey;
extern NSString* const kErrorDomain;

@interface ANError : NSError

+ (instancetype)apiErrorWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)errorWithKey:(NSString *)key;

@end
