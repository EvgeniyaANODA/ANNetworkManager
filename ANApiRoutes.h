//
//  ANApiRoutes.h
//
//  Created by Oksana Kovalchuk on 21/11/14.
//
//

#pragma mark - API Routes settings

static NSString* const kBaseURL = @"";
static NSString* const kApiVersion = @"";

typedef NS_ENUM(NSInteger, ANHttpMethodType)
{
    ANHttpMethodTypeGET = 0,
    ANHttpMethodTypePOST = 1,
    ANHttpMethodTypeDELETE = 2,
    ANHttpMethodTypePOSTJSON
};