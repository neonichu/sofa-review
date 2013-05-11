//
//  BBUGitHubRepo.m
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "AFNetworking.h"

#import "BBUGitHubRepo.h"
#import "BBUGitHubTreeNode.h"

@interface BBUGitHubRepo ()

@property (nonatomic, strong) NSURL* avatarURL;
@property (nonatomic, strong) NSURL* commitsURL;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSURL* treesURL;

@end

#pragma mark -

@implementation BBUGitHubRepo

-(NSString*)dropShaFromURLString:(NSString*)searchText {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{.*\\}" options:0 error:&error];
    if (!regex) {
        NSLog(@"Error creating regex: %@", error.localizedDescription);
        return nil;
    }
    
    return [regex stringByReplacingMatchesInString:searchText
                                           options:0
                                             range:NSMakeRange(0, [searchText length])
                                      withTemplate:@""];
}

-(void)fetchCommits {
    [[self class] scheduleRequestWithURL:self.commitsURL
                             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSLog(@"Success: %@", responseObject);
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 NSLog(@"Fail: %@", error.localizedDescription);
                             }];
}

//commit, tree, url

-(void)fetchTree {
    [[self class] scheduleRequestWithURL:self.treesURL
                             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSLog(@"Success: %@", responseObject);
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 NSLog(@"Fail: %@", error.localizedDescription);
                             }];
}

-(void)fetchTreeForLatestCommitWithCompletionBlock:(BBURecvTreeBlock)block {
    [[self class] scheduleRequestWithURL:self.commitsURL
                             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSString* treeURLString = responseObject[0][@"commit"][@"tree"][@"url"];
                                 
                                 [[self class] scheduleRequestWithURL:[NSURL URLWithString:treeURLString]
                                                          withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                              //NSLog(@"tree: %@", responseObject);
                                                              
                                                              NSMutableArray* nodes = [NSMutableArray new];
                                                              
                                                              for (NSDictionary* treeNode in responseObject[@"tree"]) {
                                                                  BBUGitHubTreeNode* node = [[BBUGitHubTreeNode alloc]
                                                                                             initWithDictionary:treeNode];
                                                                  [nodes addObject:node];
                                                              }
                                                              
                                                              block([nodes copy]);
                                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                              [UIAlertView bbu_showAlertWithError:error];
                                                          }];
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [UIAlertView bbu_showAlertWithError:error];
                             }];
}

-(id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.commitsURL = [NSURL URLWithString:[self dropShaFromURLString:dictionary[@"commits_url"]]];
        self.name = dictionary[@"name"];
        self.treesURL = [NSURL URLWithString:[self dropShaFromURLString:dictionary[@"trees_url"]]];
        
        NSDictionary* owner = dictionary[@"owner"];
        self.avatarURL = [NSURL URLWithString:owner[@"avatar_url"]];
    }
    return self;
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
