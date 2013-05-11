//
//  BBUGitHubTreeNode.m
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUGitHubTreeNode.h"

@implementation BBUGitHubTreeNode

-(id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        //NSLog(@"node: %@", dictionary);
        
        self.path = dictionary[@"path"];
        self.type = [self parseType:dictionary[@"type"]];
        self.url = [NSURL URLWithString:dictionary[@"url"]];
    }
    return self;
}

-(GHTreeNodeType)parseType:(NSString*)string {
    if ([string isEqualToString:@"blob"]) {
        return GHTreeNodeType_Blob;
    }
    
    if ([string isEqualToString:@"tree"]) {
        return GHTreeNodeType_Tree;
    }
    
    NSAssert(false, @"Unknown type: %@", string);
    return -1;
}

@end
