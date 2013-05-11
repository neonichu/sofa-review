//
//  UIAlertView+BBU.m
//  Slope
//
//  Created by Boris Bügling on 05.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "UIAlertView+BBU.h"

@implementation UIAlertView (BBU)

+(instancetype)bbu_showAlertWithError:(NSError*)error {
    UIAlertView* alertView = [[[self class] alloc] initWithTitle:error.localizedDescription
                                                         message:error.localizedRecoverySuggestion
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
    [alertView show];
    return alertView;
}

@end
