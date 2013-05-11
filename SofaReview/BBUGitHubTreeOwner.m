//
//  BBUGitHubTreeOwner.m
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "AFNetworking.h"
#import "BBUGitHubTreeOwner.h"

@interface BBUGitHubTreeOwner ()

@property (nonatomic, strong) NSURL* commitURL; // Makes no sense for repo object
@property (nonatomic, readonly) NSString* fullPath;
@property (nonatomic, strong) BBUGitHubTreeOwner* parent; // nil on repo object
@property (nonatomic, strong) NSString* urlTemplate;

@end

#pragma mark -

@implementation BBUGitHubTreeOwner

-(void)fetchTreeWithCompletionBlock:(BBURecvTreeBlock)block {
    [self doesNotRecognizeSelector:_cmd];
}

-(void)fetchTreeWithURL:(NSURL*)treeURL completionBlock:(BBURecvTreeBlock)block {
    [[self class] scheduleRequestWithURL:treeURL
                             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSMutableArray* nodes = [NSMutableArray new];
                                 
                                 for (NSDictionary* treeNode in responseObject[@"tree"]) {
                                     BBUGitHubTreeOwner* node = [[self.nodeClass alloc] initWithDictionary:treeNode];
                                     [nodes addObject:node];
                                     
                                     node.commitSha = self.commitSha;
                                     node.parent = self;
                                     
                                     NSString* urlString = [NSString stringWithFormat:self.urlTemplate,
                                                            self.root.canonicalName, self.commitSha, node.fullPath];
                                     
                                     node.commitURL = [NSURL URLWithString:urlString];
                                 }
                                 
                                 block([nodes copy]);
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [UIAlertView bbu_showAlertWithError:error];
                             }];

}

-(NSString *)fullPath {
    if (self.parent) {
        return [self.parent.fullPath stringByAppendingPathComponent:self.canonicalName];
    }
    return @"";
}

-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.urlTemplate = @"https://github.com/%@/blob/%@/%@";
    }
    return self;
}

-(BBUGitHubTreeOwner *)root {
    BBUGitHubTreeOwner* root = self;
    while (root.parent) {
        root = root.parent;
    }
    return root;
}

#pragma mark - Helper

+(void)scheduleRequestWithURL:(NSURL*)url
                  withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation* oper = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [oper setCompletionBlockWithSuccess:success failure:failure];
    [[NSOperationQueue mainQueue] addOperation:oper];
}

@end
