//
//  ANNetworkLog.h
//
//  Created by Oksana Kovalchuk on 21/11/14.
//
//

#ifdef ANNETWORKLOG
#    define ANLog(...) NSLog(__VA_ARGS__)
#    define ANLogError(e) if (error != nil) ANLog(@"Network Error:\n%@",error);
#else
#    define ANLog(...) /* */
#endif
#define ALog(...) NSLog(__VA_ARGS__)
