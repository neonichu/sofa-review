//
//  BBUGitHubTreeNode.h
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GHTreeNodeType_Tree = 0,
    GHTreeNodeType_Blob = 1,
} GHTreeNodeType;

@interface BBUGitHubTreeNode : NSObject

@property (nonatomic, strong) NSURL* commitURL;
@property (nonatomic, strong) NSString* path;
@property (nonatomic, assign) GHTreeNodeType type;
@property (nonatomic, strong) NSURL* url;

-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
