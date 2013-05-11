//
//  BBUGitHubTreeOwner.h
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BBURecvTreeBlock)(NSArray* treeNodes);

@class AFHTTPRequestOperation;

@interface BBUGitHubTreeOwner : NSObject

+(void)scheduleRequestWithURL:(NSURL*)url
                  withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(NSURL*)commitURL;
-(void)fetchTreeWithCompletionBlock:(BBURecvTreeBlock)block;
-(void)fetchTreeWithURL:(NSURL*)treeURL completionBlock:(BBURecvTreeBlock)block;
-(id)initWithDictionary:(NSDictionary*)dictionary;
-(BBUGitHubTreeOwner*)parent;

@property (nonatomic, readonly) NSString* canonicalName;
@property (nonatomic, strong) NSString* commitSha;
@property (nonatomic, readonly) Class nodeClass;
@property (nonatomic, readonly) BBUGitHubTreeOwner* root;

@end
