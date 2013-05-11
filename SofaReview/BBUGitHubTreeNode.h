//
//  BBUGitHubTreeNode.h
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUGitHubTreeOwner.h"

@class BBUGitHubRepo;

typedef enum {
    GHTreeNodeType_Tree = 0,
    GHTreeNodeType_Blob = 1,
} GHTreeNodeType;

@interface BBUGitHubTreeNode : BBUGitHubTreeOwner

@property (nonatomic, strong) NSString* path;
@property (nonatomic, assign) GHTreeNodeType type;
@property (nonatomic, strong) NSURL* url;

@end
