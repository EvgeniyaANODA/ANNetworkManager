//
//  ANEnumAdditions.h
//
//  Created by Oksana Kovalchuk on 21/11/14.
//
//

typedef NS_ENUM(NSInteger, ANHttpMethodType)
{
    ANHttpMethodTypeGET = 0,
    ANHttpMethodTypePOST = 1,
    ANHttpMethodTypeDELETE = 2,
    ANHttpMethodTypePOSTJSON
};

NSString* ANHttpMethodTypeStringFromEnumValue(ANHttpMethodType);
ANHttpMethodType ANHttpMethodTypeEnumValueFromSrting(NSString*);