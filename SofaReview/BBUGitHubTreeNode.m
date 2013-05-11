//
//  BBUGitHubTreeNode.m
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUGitHubTreeNode.h"

@implementation BBUGitHubTreeNode

-(NSString *)canonicalName {
    return self.path;
}

-(void)fetchTreeWithCompletionBlock:(BBURecvTreeBlock)block {
    if (self.type != GHTreeNodeType_Tree) {
        return;
    }
    
    [self fetchTreeWithURL:self.url completionBlock:block];
}

-(id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        //NSLog(@"node: %@", dictionary);
        
        self.path = dictionary[@"path"];
        self.type = [self parseType:dictionary[@"type"]];
        self.url = [NSURL URLWithString:dictionary[@"url"]];
    }
    return self;
}

-(Class)nodeClass {
    return [BBUGitHubTreeNode class];
}

-(GHTreeNodeType)parseType:(NSString*)string {
    if ([string isEqualToString:@"blob"]) {
        return GHTreeNodeType_Blob;
    }
    
    if ([string isEqualToString:@"tree"]) {
        return GHTreeNodeType_Tree;
    }
    
    // FIXME: When does this come up?
    if ([string isEqualToString:@"commit"]) {
        return GHTreeNodeType_Commit;
    }
    
    NSAssert(false, @"Unknown type: %@", string);
    return -1;
}

@end
