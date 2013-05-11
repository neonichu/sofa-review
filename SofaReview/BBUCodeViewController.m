//
//  BBUCodeViewController.m
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUCodeViewController.h"
#import "JLTextView.h"

NSString* const kBBUSourceCodeTextReceivedNotification = @"BBUSourceCodeTextReceivedNotification";
NSString* const kCode = @"Code";

@interface BBUCodeViewController ()

@property (nonatomic, strong) JLTextView* textView;

@end

#pragma mark -

@implementation BBUCodeViewController

-(NSString *)code {
    return self.textView.text;
}

- (void)loadView
{
    JLTextView *textView = [[JLTextView alloc] initWithFrame:CGRectZero];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView.editable = NO;
    textView.font = [UIFont fontWithName:@"Menlo-Regular" size:13];
    textView.syntaxTokenizer = [[JLTokenizer alloc] init];
    textView.syntaxTokenizer.theme = kTokenizerThemeDusk;
    
    self.view = textView;
    self.textView = textView;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kBBUSourceCodeTextReceivedNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSString* code = note.userInfo[kCode];
                                                      // Makes no sense to do this anyways...
                                                      [self.textView performSelectorOnMainThread:@selector(setText:)
                                                                                      withObject:code waitUntilDone:NO];
                                                  }];
}

-(void)setCode:(NSString *)code {
    self.textView.text = code;
}

@end
