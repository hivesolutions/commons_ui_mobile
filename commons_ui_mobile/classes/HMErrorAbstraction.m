// Hive Mobile
// Copyright (c) 2008-2020 Hive Solutions Lda.
//
// This file is part of Hive Mobile.
//
// Hive Mobile is free software: you can redistribute it and/or modify
// it under the terms of the Apache License as published by the Apache
// Foundation, either version 2.0 of the License, or (at your option) any
// later version.
//
// Hive Mobile is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// Apache License for more details.
//
// You should have received a copy of the Apache License along with
// Hive Mobile. If not, see <http://www.apache.org/licenses/>.

// __author__    = João Magalhães <joamag@hive.pt>
// __version__   = 1.0.0
// __revision__  = $LastChangedRevision$
// __date__      = $LastChangedDate$
// __copyright__ = Copyright (c) 2008-2020 Hive Solutions Lda.
// __license__   = Apache License, Version 2.0

#import "HMErrorAbstraction.h"

@implementation HMErrorAbstraction

+ (void)handleErrorData:(id)data authenticationDelegate:(NSObject<HMAuthenticationDelegate> *)authenticationDelegate view:(UIView *)view viewController:(UIViewController *)viewController {
    // casts the remote data as an exception
    NSDictionary *remoteDataException = (NSDictionary *) data;

    // retrieves the exception map
    NSDictionary *exception = [remoteDataException objectForKey:@"exception"];

    // retrieves the exception name
    NSString *exceptionName = [exception objectForKey:@"exception_name"];

    // retrieves the exception message
    NSString *message = [exception objectForKey:@"message"];

    // prints the error message
    NSLog(@"Error received with name: %@ and message: %@", exceptionName, message);

    // in case it's an authentication error
    if([exceptionName isEqualToString:@"AuthenticationError"]) {
        // retrieves the current application
        UIApplication *currentApplication = [UIApplication sharedApplication];

        // retrieves the current application delegate
        NSObject<HMApplicationDelegate> *currentApplicationDelegate = (NSObject<HMApplicationDelegate> *) currentApplication.delegate;

        // retrieves the authentication view controller
        HMAuthenticationViewController *authenticationViewController = [currentApplicationDelegate getAuthenticationViewController];

        // sets the current instance as the authentication delegate
        authenticationViewController.authenticationDelegate = authenticationDelegate;

        // pushes the login view controller
        [viewController presentModalViewController:authenticationViewController animated:YES];
    }
    // otherwise it's a generic error
    else {
        // retrieves the (localized) base error message
        NSString *baseErrorMessage = NSLocalizedString(@"ServerError", @"ServerError");

        // creates the error message from the base error message and the
        // localized error description
        NSString *errorMessage = [NSString stringWithFormat:@"%@\n%@", baseErrorMessage, message];

        // creates the action sheet
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"Dismiss") destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.alpha = 0.75;

        // sets the action sheet style
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;

        // shows the action sheet in the table view
        [actionSheet showInView:view];

        // releases the action sheet
        [actionSheet release];
    }
}

@end
