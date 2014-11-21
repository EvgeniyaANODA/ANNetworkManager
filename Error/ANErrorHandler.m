//
//  ANErrorHandler.m
//
//  Created by Oksana Kovalchuk on 4/7/14.
//  Copyright (c) 2014 ANODA. All rights reserved.
//

#import "ANErrorHandler.h"
#import "ANApiRoutes.h"

@implementation ANErrorHandler

+ (void)handleNetworkApplicationError:(NSError *)error
{
    [self showMessageForError:error];
}

+ (void)handleNetworkServerError:(ANError *)error
{
    [self showMessageForError:error];
}

+ (void)handleInternalError:(NSError *)error
{
    [self showMessageForError:error];
}

+ (void)handleApplicationError:(NSError *)error
{
    [self showMessageForError:error];
}

+ (void)showMessageForError:(NSError *)error
{
    if (!error) return;
    ANLogError(error);
}

+ (void)handleCoreDataInternalError:(NSError *)error
{
    [self showMessageForError:error];
}

@end
