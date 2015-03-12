ANNetworkManager
================

```
pod 'ANNetworkManager'
```

Easily wraps NSURLSession requests in RACSignal* 

1) override ANNetworkSessionManager or setup another way

```
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setBaseURL:kBaseURL andAPIVersion:kApiVersion];
    }
    return self;
}
```

Example : 

```
+ (RACSignal*)sendSMSCodeOnPhone:(NSString *)phone
{
    NSParameterAssert(phone.length);
    
    phone = [phone an_stripAllNonNumericCharacters];
    
    return [[CDNetworkSessionManager shared] requestWithPath:[apiAuthSms stringByAppendingString:phone]
                                                  parameters:nil
                                                  httpMethod:CDHttpMethodTypeGET];
}

```

