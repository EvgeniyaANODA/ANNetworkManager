//
//  ANApiRoutes.h
//
//  Created by Oksana Kovalchuk on 21/11/14.
//
//

#define ANNETWORKLOG //comment this line for disable logging

#pragma mark - API Routes settings

static NSString* const kBaseURL = @"";
static NSString* const kApiVersion = @"";
static NSString* const kErrorDomain = @"";


#pragma mark - HTTP Server Responce Error Keys

NSString* const kErrorCodeKey = @"code";
NSString* const kErrorMessageKey = @"message";

#ifdef ANNETWORKLOG
#    define ANLog(...) NSLog(__VA_ARGS__)
#    define ANLogError(e) if (error != nil) ANLog(@"Network Error:\n%@",error);
#else
#    define ANLog(...) /* */
#endif
#define ALog(...) NSLog(__VA_ARGS__)

typedef NS_ENUM(NSInteger, ANHttpMethodType)
{
    ANHttpMethodTypeGET = 0,
    ANHttpMethodTypePOST = 1,
    ANHttpMethodTypeDELETE = 2,
    ANHttpMethodTypePOSTJSON
};

