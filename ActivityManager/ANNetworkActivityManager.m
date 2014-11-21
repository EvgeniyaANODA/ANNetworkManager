//
//  ANNetwokActivityManager.m
//
//  Created by Oksana Kovalchuk on 3/7/14.
//  Copyright (c) 2014 ANODA. All rights reserved.
//

#import "ANNetworkActivityManager.h"
#import <Availability.h>

static NSTimeInterval const kANetworkActivityIndicatorInvisibilityDelay = 0.17;

@interface ANNetworkActivityManager ()

@property (readwrite, nonatomic, assign) NSInteger activityCount;
@property (readwrite, nonatomic, strong) NSTimer *activityIndicatorVisibilityTimer;
@property (readonly, nonatomic, getter = isNetworkActivityIndicatorVisible) BOOL networkActivityIndicatorVisible;

- (void)updateNetworkActivityIndicatorVisibility;
- (void)updateNetworkActivityIndicatorVisibilityDelayed;

@end

@implementation ANNetworkActivityManager

+ (instancetype)shared
{
    static ANNetworkActivityManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [ANNetworkActivityManager new];
	});
    return _sharedClient;
}

+ (NSSet *)keyPathsForValuesAffectingIsNetworkActivityIndicatorVisible {
    return [NSSet setWithObject:@"activityCount"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_activityIndicatorVisibilityTimer invalidate];
}

- (void)updateNetworkActivityIndicatorVisibilityDelayed
{
    if (self.enabled)
    {
        // Delay hiding of activity indicator for a short interval, to avoid flickering
        if (![self isNetworkActivityIndicatorVisible])
        {
            [self.activityIndicatorVisibilityTimer invalidate];
            self.activityIndicatorVisibilityTimer =
            [NSTimer timerWithTimeInterval:kANetworkActivityIndicatorInvisibilityDelay
                                    target:self
                                  selector:@selector(updateNetworkActivityIndicatorVisibility)
                                  userInfo:nil
                                   repeats:NO];
            
            [[NSRunLoop mainRunLoop] addTimer:self.activityIndicatorVisibilityTimer forMode:NSRunLoopCommonModes];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(updateNetworkActivityIndicatorVisibility)
                                   withObject:nil
                                waitUntilDone:NO
                                        modes:@[NSRunLoopCommonModes]];
        }
    }
}

- (BOOL)isNetworkActivityIndicatorVisible
{
    return self.activityCount > 0;
}

- (void)updateNetworkActivityIndicatorVisibility
{
    BOOL isVisible = [self isNetworkActivityIndicatorVisible];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isVisible];
}

- (void)setActivityCount:(NSInteger)activityCount
{
	@synchronized(self) {
        
		_activityCount = activityCount;
	}
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateNetworkActivityIndicatorVisibilityDelayed];
    });
}

- (void)incrementActivityCount
{
    [self willChangeValueForKey:@"activityCount"];
	@synchronized(self) {
        
		_activityCount++;
	}
    [self didChangeValueForKey:@"activityCount"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateNetworkActivityIndicatorVisibilityDelayed];
    });
}

- (void)decrementActivityCount
{
    [self willChangeValueForKey:@"activityCount"];
	@synchronized(self) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
        
		_activityCount = MAX(_activityCount - 1, 0);
        
#pragma clang diagnostic pop
        
	}
    [self didChangeValueForKey:@"activityCount"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateNetworkActivityIndicatorVisibilityDelayed];
    });
}

@end
