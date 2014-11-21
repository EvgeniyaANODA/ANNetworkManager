//
//  CDErrorHandler.m
//  CtrlDo
//
//  Created by Oksana Kovalchuk on 4/7/14.
//  Copyright (c) 2014 ANODA. All rights reserved.
//

#import "ANErrorHandler.h"
#import "CDScreenManager.h"

#define UN_AUTH_ERROR_CODE 107 // create a file with codes later, when all codes will exist on server
#define ALREADY_AUTH 207

@implementation ANErrorHandler

+ (void)handleNetworkApplicationError:(NSError *)error
{
    [self showMessageForError:error];
}

+ (void)handleNetworkServerError:(CDError *)error
{
    if ((error.code == UN_AUTH_ERROR_CODE) ||
        (error.code == ALREADY_AUTH))
    {
        [[CDScreenManager shared] showAuth];
    }
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
    CDLogError(error);
    if (error.code == CDServerErrorCodeCouldntComplete)
    {
        [CDMessageManager showDangerMessageForError:error];
    }
    else
    {
        [CDMessageManager showMessageForError:error];
    }
}

+ (void)handleCoreDataInternalError:(NSError *)error
{
    [self showMessageForError:error];
}

@end
