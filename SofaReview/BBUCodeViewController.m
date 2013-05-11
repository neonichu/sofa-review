//
//  BBUCodeViewController.m
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <objc/runtime.h>

#import "BBUCodeViewController.h"
#import "BBUGitHubTreeNode.h"
#import "JLTextView.h"

NSString* const kBBUSourceCodeTextReceivedNotification = @"BBUSourceCodeTextReceivedNotification";
NSString* const kCode = @"Code";
NSString* const kTreeNode = @"TreeNode";

@interface BBUCodeViewController ()

@property (nonatomic, readonly) NSURL* highlightedSelectionURL;
@property (nonatomic, strong) BBUGitHubTreeNode* node;
@property (nonatomic, readonly) NSInteger selectionEndLine;
@property (nonatomic, readonly) NSInteger selectionStartLine;
@property (nonatomic, strong) JLTextView* textView;

@end

#pragma mark -

@implementation BBUCodeViewController

-(NSString *)code {
    return self.textView.text;
}

-(void)comment:(id)sender {
}

-(void)highlight:(id)sender {
    [self showCurrentSelectionOnGitHub];
}

-(void)mail:(id)sender {
    
}

- (void)loadView
{
    JLTextView *textView = [[JLTextView alloc] initWithFrame:CGRectZero];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView.editable = NO;
    textView.font = [UIFont fontWithName:@"Menlo-Regular" size:13];
    textView.syntaxTokenizer = [[JLTokenizer alloc] init];
    textView.syntaxTokenizer.theme = kTokenizerThemeDusk;
    
    // Too lazy to subclass :)
    IMP myIMP = imp_implementationWithBlock(^(id sself, SEL action, id sender) {
        return (action == @selector(comment:) && action == @selector(highlight:));
    });
    Method m = class_getInstanceMethod([JLTextView class], @selector(canPerformAction:withSender:));
    method_setImplementation(m, myIMP);
    
    self.view = textView;
    self.textView = textView;
    
    UIMenuItem* highlight = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Highlight", nil)
                                                       action:@selector(highlight:)];
    UIMenuItem* comment = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Comment", nil)
                                                     action:@selector(comment:)];
    UIMenuItem* mail = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Mail", nil)
                                                  action:@selector(mail:)];
    
    UIMenuController* menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:@[ highlight, comment ]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kBBUSourceCodeTextReceivedNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      self.node = note.userInfo[kTreeNode];
                                                      
                                                      NSString* code = note.userInfo[kCode];
                                                      // Makes no sense to do this anyways...
                                                      [self.textView performSelectorOnMainThread:@selector(setText:)
                                                                                      withObject:code waitUntilDone:NO];
                                                  }];
}

// Inspired by https://github.com/larsxschneider/ShowInGitHub/blob/master/Source/Classes/SIGPlugin.m

-(NSInteger)selectionStartLine {
    NSRange selectedRange = self.textView.selectedRange;
    NSString* untilSelection = [self.textView.text substringWithRange:NSMakeRange(0, selectedRange.location)];
    return [[untilSelection componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
}

-(NSInteger)selectionEndLine {
    NSRange selectedRange = self.textView.selectedRange;
    NSString* selection = [self.textView.text substringWithRange:selectedRange];
    NSUInteger selectedLines = [[selection componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
    return self.selectionStartLine + (selectedLines > 1 ? selectedLines - 2 : 0);
}

-(void)setCode:(NSString *)code {
    self.textView.text = code;
}

#pragma mark - GitHub browser actions

-(NSURL*)highlightedSelectionURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@#L%d-%d", self.node.commitURL,
                                 self.selectionStartLine, self.selectionEndLine]];
}

-(void)showCurrentSelectionOnGitHub {
    [[UIApplication sharedApplication] openURL:self.highlightedSelectionURL];
}

@end
