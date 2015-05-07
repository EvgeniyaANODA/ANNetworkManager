//
//  ANNetworkRequest.m
//
//  Created by Oksana Kovalchuk on 5/18/14.
//  Copyright (c) 2014 ANODA. All rights reserved.
//

NSString* const kAuthTokenHeader = @"X-Auth-Token";
NSString* const kMultipartFormBoundary = @"Boundary+0xAbCdEfGbOuNdArY";

#import "ANNetworkRequest.h"

#pragma mark - HTTP Method Type

static NSString* kBaseURL = @"";
static NSString* kApiVersion = @"";

@implementation ANNetworkRequest

+ (void)setBaseURL:(NSString *)baseURL andAPIVersion:(NSString *)apiVersion
{
    kBaseURL = baseURL;
    kApiVersion = apiVersion;
}

+ (instancetype)requestWithPath:(NSString *)path parameters:(NSDictionary*)params httpMethod:(ANHttpMethodType)httpMethodType
{
    return [[self alloc] initWithPath:path parameters:params httpMethod:httpMethodType];
}

- (instancetype)initWithPath:(NSString*)path parameters:(NSDictionary*)params httpMethod:(ANHttpMethodType)httpMethodType
{
    self = [super init];
    if (self)
    {
        self.URL = [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:[kBaseURL stringByAppendingString:kApiVersion]]];
        
        [self addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //setting application token
        if (self.token)
        {
            [self addValue:self.token forHTTPHeaderField:kAuthTokenHeader];
        }
        //switch between sync and normal mode
        if (httpMethodType == ANHttpMethodTypePOSTJSON)
        {
            [self addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [self setHTTPMethod:ANHttpMethodTypeStringFromEnumValue(ANHttpMethodTypePOST)];
        }
        else
        {
            [self setHTTPMethod:ANHttpMethodTypeStringFromEnumValue(httpMethodType)];
        }
        //apply parameters
        switch (httpMethodType)
        {
            case ANHttpMethodTypeGET:     [self applyGetAndDeleteParameters:params];  break;
            case ANHttpMethodTypeDELETE:  [self applyGetAndDeleteParameters:params];  break;
            case ANHttpMethodTypePOST:    [self applyPOSTParameters:params];          break;
            case ANHttpMethodTypePOSTJSON: [self applyPOSTJSONParameters:params];   break;
            default: break;
        }
    }
    return self;
}

+ (instancetype)requestMultipartWithPath:(NSString*)path photo:(UIImage*)photo
{
    ANNetworkRequest* request = [ANNetworkRequest requestWithPath:path parameters:nil httpMethod:ANHttpMethodTypePOST];
    
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", kMultipartFormBoundary] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData* data = [NSMutableData data];
    
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", kMultipartFormBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"name=\"%@\";", @"photo"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"filename=\"%@\"\r\n", @"photo.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:UIImageJPEGRepresentation(photo, 0.9)];
    [data appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [data appendData:[[NSString stringWithFormat:@"--%@--\r\n", kMultipartFormBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPBody = data;
    
    return request;
}

- (void)applyPOSTJSONParameters:(id)parameters
{
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:parameters
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    ANLogError(error);
    if (!error)
    {
        [self setHTTPBody:data];
    }
}

- (void)applyPOSTParameters:(NSDictionary*)params
{
    if (params)
    {
        [self setHTTPBody:[self encodeDictionary:params]];
    }
    else
        return;
}

- (NSData*)encodeDictionary:(NSDictionary*)dictionary
{
    NSMutableArray *parts = [NSMutableArray array];
    for (NSString *key in dictionary)
    {
        NSString *encodedValue = [[dictionary objectForKey:key]
                                  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)applyGetAndDeleteParameters:(NSDictionary*)params
{
    NSMutableString* paramString = [NSMutableString string];
    if (!params | !params.allKeys.count)
    {
        return;
    }
    [params.allKeys enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        
        if (idx == 0)
        {
            [paramString appendFormat:@"%@=%@", obj, params[obj]];
        }
        else
        {
            [paramString appendFormat:@"&%@=%@", obj, params[obj]];
        }
    }];

    NSString* urlString = [[self.URL absoluteString] stringByAppendingFormat:@"?%@", paramString];
    [self setURL:[NSURL URLWithString:urlString]];
}

@end
