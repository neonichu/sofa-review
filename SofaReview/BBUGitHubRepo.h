//
//  BBUGitHubRepo.h
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

typedef void(^BBURecvTreeBlock)(NSArray* treeNodes);

@interface BBUGitHubRepo : NSObject

+(void)scheduleRequestWithURL:(NSURL*)url
                  withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(id)initWithDictionary:(NSDictionary*)dictionary;

-(NSURL*)avatarURL;
-(NSString*)name;
-(NSURL*)treesURL;

-(void)fetchTreeForLatestCommitWithCompletionBlock:(BBURecvTreeBlock)block;

@end
