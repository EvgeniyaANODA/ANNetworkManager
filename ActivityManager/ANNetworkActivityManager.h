//
//  ANNetwokActivityManager.h
//
//  Created by Oksana Kovalchuk on 3/7/14.
//  Copyright (c) 2014 ANODA. All rights reserved.
//

@interface ANNetworkActivityManager : NSObject

/**
 A Boolean value indicating whether the manager is enabled.
 
 If YES, the manager will change status bar network activity indicator according to network operation notifications it receives. The default value is NO.
 */
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

/**
 A Boolean value indicating whether the network activity indicator is currently displayed in the status bar.
 */
@property (readonly, nonatomic, assign) BOOL isNetworkActivityIndicatorVisible;

/**
 Returns the shared network activity indicator manager object for the system.
 
 @return The systemwide network activity indicator manager.
 */
+ (instancetype)shared;

/**
 Increments the number of active network requests. If this number was zero before incrementing, this will start animating the status bar network activity indicator.
 */
- (void)incrementActivityCount;

/**
 Decrements the number of active network requests. If this number becomes zero after decrementing, this will stop animating the status bar network activity indicator.
 */
- (void)decrementActivityCount;


@end
